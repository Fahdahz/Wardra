//
//  UploadClothesView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI
import UIKit

struct UploadClothesView: View {

    @ObservedObject var viewModel: UploadClothesViewModel
    var onSave: (ClothingItem) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var showSourceDialog = false
    @State private var showPicker = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.94, blue: 0.92)
                .ignoresSafeArea()

            VStack(spacing: 18) {

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Text("Upload your\nclothes")
                    .font(.custom("American Typewriter", size: 38))
                    .multilineTextAlignment(.center)

                // Upload box
                Button {
                    showSourceDialog = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(red: 0.82, green: 0.67, blue: 0.70),
                                    style: StrokeStyle(lineWidth: 3, dash: [10]))
                            .frame(height: 240)

                        if let img = viewModel.processedImage ?? viewModel.originalImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(10)
                        } else {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 40, weight: .regular))
                                .foregroundColor(Color(red: 0.82, green: 0.67, blue: 0.70))
                        }
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)

                Text("Pick Clothing Catagory")
                    .font(.custom("American Typewriter", size: 20))
                    .foregroundColor(.black.opacity(0.6))
                
                Picker("Category", selection: $viewModel.category) {
                    Text("Top").tag(ClothingCategory.top)
                    Text("Bottom").tag(ClothingCategory.bottom)
                }
                .pickerStyle(.menu)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.82, green: 0.67, blue: 0.70), lineWidth: 1.5)
                )
                .padding(.horizontal, 24)

                if viewModel.isProcessing {
                    ProgressView("Removing background...")
                        .padding(.top, 6)
                }

                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 4)
                }

                Button {
                    guard let item = viewModel.createItem() else { return }
                    onSave(item)
                    dismiss()
                } label: {
                    Text("Save to closet")
                        .font(.custom("American Typewriter", size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(red: 0.82, green: 0.67, blue: 0.70))
                        )
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                Spacer(minLength: 10)
            }
        }
        .confirmationDialog("Upload image", isPresented: $showSourceDialog) {
            Button("Take Photo") {
                pickerSourceType = .camera
                showPicker = true
            }
            Button("Choose from Library") {
                pickerSourceType = .photoLibrary
                showPicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: pickerSourceType) { image in
                viewModel.setImage(image)
            }
        }
    }
}

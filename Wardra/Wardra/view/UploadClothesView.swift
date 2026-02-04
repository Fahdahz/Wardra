//
//  UploadClothesView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct UploadClothesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: UploadClothesViewModel
    let onSave: (ClothingItem) -> Void

    @State private var showPicker = false
    @State private var pickerSource: ImagePicker.Source = .library

    var body: some View {
        ZStack {
            Color(hex: "#FBF6F1").ignoresSafeArea()

            VStack(spacing: 20) {

                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                    Spacer()
                }

                Text("Upload your\nclothes")
                    .font(.system(size: 32, weight: .regular, design: .serif))
                    .multilineTextAlignment(.center)

                // Upload Box
                Button {
                    showPicker = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundColor(Color(hex: "#E5B7C5"))
                            .frame(height: 240)

                        if let image = viewModel.processedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                        } else {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 44))
                                .foregroundColor(Color(hex: "#E5B7C5"))
                        }
                    }
                }

                // Category Picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pick Clothing Category")
                        .font(.system(size: 18, design: .serif))

                    Menu {
                        ForEach(ClothingCategory.allCases) { category in
                            Button(category.rawValue) {
                                viewModel.category = category
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.category.rawValue)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#E5B7C5"))
                        )
                    }
                }

                Spacer()

                // Save Button
                Button {
                    if let item = viewModel.createItem() {
                        onSave(item)
                        dismiss()
                    }
                } label: {
                    Text("Save to closet")
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#D7B7BC"))
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .confirmationDialog("Upload image", isPresented: $showPicker) {
            Button("Take Photo") {
                pickerSource = .camera
            }
            Button("Choose from Library") {
                pickerSource = .library
            }
        }
        .sheet(isPresented: Binding(
            get: { pickerSource != nil && showPicker },
            set: { _ in }
        )) {
            ImagePicker(source: pickerSource) { image in
                viewModel.setImage(image)
                showPicker = false
            }
        }
    }
}


//
//  ClosetView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct ClosetView: View {
    
    @StateObject var viewModel = ClosetViewModel()
    @State private var showUpload = false
    
    var body: some View {
        ZStack {
            
            Color("WardraBackground")
                .ignoresSafeArea()
            
            if viewModel.items.isEmpty {
                
                VStack(spacing: 20) {
                    Text("Your Closet is empty :(")
                        .font(.title2)
                    
                    Text("Start Adding Clothes!")
                        .foregroundColor(.gray)
                }
                
            } else {
                
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 120))],
                        spacing: 16
                    ) {
                        ForEach(viewModel.items) { item in
                            Image(uiImage: item.image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - Plus Button
            
            VStack {
                Spacer()
                
                Button {
                    showUpload = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color("WardraPink"))
                            .frame(width: 65, height: 65)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showUpload) {
            
            UploadClothesView(
                viewModel: UploadClothesViewModel(),
                onSave: { item in
                    viewModel.addItem(item)
                }
            )
        }
    }
}

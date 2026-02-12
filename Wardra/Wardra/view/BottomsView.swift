//
//  BottomsView.swift
//  Wardra
//
//  Created by lulwah on 21/08/1447 AH.
//
import SwiftUI

struct BottomsView: View {

    @ObservedObject var viewModel: ClosetViewModel
    
    private var bottomItems: [ClothingItem] {
        viewModel.items.filter { $0.category == .bottom }
    }

    // Reuse your palette
    private let bgColor = Color(red: 0.96, green: 0.94, blue: 0.92)
    private let accent = Color(red: 0.75, green: 0.45, blue: 0.45) // matches bottom bar color

    var body: some View {
        ZStack {

            // Background
            bgColor
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header
                VStack(spacing: 10) {

                    // Hanger with centered title
                    ZStack {
                        Image("hanger 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 420, height: 120) // bigger hanger

                        // Centered text relative to the hanger
                        Text("Bottoms")
                            .font(.system(size: 25, weight: .semibold, design: .serif)) // bigger text
                            .foregroundColor(.black)
                            .offset(y: 10) // adjust to sit in the hanger opening
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)

                Divider()

                // MARK: - Grid
                if bottomItems.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "figure.walk")
                            .font(.system(size: 60))
                            .foregroundColor(Color("WardraPink"))
                        
                        Text("No Bottoms Yet")
                            .font(.custom("American Typewriter", size: 28))
                        
                        Text("Add some bottoms to your closet!")
                            .font(.custom("American Typewriter", size: 16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(bottomItems) { item in
                                BottomItemCard(item: item, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }

                Spacer()

               
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BottomItemCard: View {
    let item: ClothingItem
    @ObservedObject var viewModel: ClosetViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .frame(height: 170)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.pink.opacity(0.2), lineWidth: 1)
                )
                .overlay {
                    if let image = item.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding(14)
                    }
                }
                .shadow(color: .black.opacity(0.05), radius: 5)
            
            // Favorite heart button
            Button {
                viewModel.toggleFavorite(item)
            } label: {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(Color("WardraPink"))
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            .padding(8)
        }
    }
}

#Preview {
    NavigationStack {
        BottomsView(viewModel: ClosetViewModel())
    }
}

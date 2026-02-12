//
//  FavoritesView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 24/08/1447 AH.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var viewModel: ClosetViewModel
    
    private var favoriteItems: [ClothingItem] {
        viewModel.items.filter { $0.isFavorite }
    }
    
    var body: some View {
        ZStack {
            Color("WardraBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: - Header
                VStack(spacing: 10) {
                    ZStack {
                        Image("hanger 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 420, height: 120)
                        
                        Text("My Favorites")
                            .font(.system(size: 30, weight: .semibold, design: .serif))
                            .foregroundColor(.black)
                            .offset(y: 10)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                Divider()
                
                // MARK: - Content
                if favoriteItems.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color("WardraPink"))
                        
                        Text("No Favorites Yet")
                            .font(.custom("American Typewriter", size: 28))
                        
                        Text("Swipe right on Mix & Match\nto add favorites!")
                            .font(.custom("American Typewriter", size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
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
                            ForEach(favoriteItems) { item in
                                FavoriteItemCard(item: item, viewModel: viewModel)
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

struct FavoriteItemCard: View {
    let item: ClothingItem
    @ObservedObject var viewModel: ClosetViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .frame(height: 170)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("WardraPink"), lineWidth: 2)
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
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
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
        FavoritesView(viewModel: ClosetViewModel())
    }
}

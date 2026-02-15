//
//  FavoritesView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 24/08/1447 AH.
//

import SwiftUI

struct FavoritesView: View {

    @ObservedObject var viewModel: ClosetViewModel

    private var favoriteOutfits: [FavoriteOutfit] {
        viewModel.favoriteOutfits
    }

    var body: some View {
        ZStack {
            Color("WardraBackground")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                Rectangle()
                    .fill(Color("WardraPink"))
                    .frame(height: 3)
                    .padding(.horizontal, 2)
                    .padding(.top, 8)
                
                VStack(spacing: 10) {
                    ZStack {
                        Image("big_hanger")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 420)
                            .padding(.top, -16)

                        Text("My Favorites")
                            .font(.custom("American Typewriter", size: 23))
                            .foregroundColor(.black)
                            .offset(y: 8)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 20)

                Divider()

                if favoriteOutfits.isEmpty {
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
                    ScrollView(showsIndicators: false) {
                        // ✅ التغيير الوحيد: زودنا الـ spacing بين الكروت
                        VStack(spacing: 50) {
                            ForEach(favoriteOutfits) { outfit in
                                FavoriteOutfitCard(outfit: outfit, viewModel: viewModel)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 30)
                    }
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoriteOutfitCard: View {
    let outfit: FavoriteOutfit
    @ObservedObject var viewModel: ClosetViewModel

    @State private var showRemoveAlert = false

    private var topItem: ClothingItem? {
        viewModel.items.first { $0.id == outfit.topID }
    }

    private var bottomItem: ClothingItem? {
        viewModel.items.first { $0.id == outfit.bottomID }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {

            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .shadow(color: .black.opacity(0.12), radius: 20, y: 14)

            VStack(spacing: 0) {

                // نفس الـ pink band حق Mix & Match
                Rectangle()
                    .fill(Color("WardraPink").opacity(0.18))
                    .frame(height: 50)

                

                if let topImage = topItem?.image {
                    Image(uiImage: topImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                }

                Divider()
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)

                if let bottomImage = bottomItem?.image {
                    Image(uiImage: bottomImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 190)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 190)
                }

                Spacer()
            }

            // زر إزالة الأوتفت من الفيفرت (كما هو)
            Button {
                showRemoveAlert = true
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("WardraPink"))
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            .padding(12)
            .alert("Remove from favorites?", isPresented: $showRemoveAlert) {
                Button("Remove", role: .destructive) {
                    viewModel.removeFavoriteOutfit(outfit)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will remove the whole outfit from favorites.")
            }
        }
        // نفس مقاس كارد Mix & Match
        .frame(width: 320, height: 460)
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack {
        FavoritesView(viewModel: ClosetViewModel())
    }
}


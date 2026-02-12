//
//  ClosetView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct ClosetView: View {
    @StateObject private var viewModel = ClosetViewModel()
    
    var body: some View {
        NavigationStack { // ✅ Added فقط عشان التنقل يشتغل
            TabView {

                CanvasView()
                    .tabItem { Image("HangerS") }

                MixMatchCardsView(viewModel: viewModel)
                    .tabItem { Image("cardtabar") }

                ClosetContentView(viewModel: viewModel)
                    .tabItem { Image("tshirtS") }
            }
        }
    }
}

private struct ClosetContentView: View {

    @ObservedObject var viewModel: ClosetViewModel

    @State private var showUpload = false

    @AppStorage("userFirstName") private var userFirstName: String = ""

    private var tops: [ClothingItem] {
        viewModel.items.filter { $0.category == .top }
    }

    private var bottoms: [ClothingItem] {
        viewModel.items.filter { $0.category == .bottom }
    }

    var body: some View {
        ZStack {

            Color("WardraBackground")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header
                ZStack {

                    // الخلفية + الهيدر
                    ZStack {
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(Color("WardraPink"))
                                .frame(height: 4)

                            Spacer(minLength: 0)

                            Rectangle()
                                .fill(Color("WardraPink"))
                                .frame(height: 4)
                        }

                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("WardraBackground"))
                            .frame(width: 310, height: 79)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color("WardraPink"), lineWidth: 2)
                            )
                            .overlay(
                                Text(userFirstName.isEmpty
                                     ? "My Closet"
                                     : "\(userFirstName)'s Closet")
                                    .font(.custom("American Typewriter", size: 26))
                            )
                    }
                    .zIndex(0) // 👈 الهيدر تحت

                    // ✅ Hanger Icon (فوق الكل)
                    ZStack {
                        Image("hanger_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)

                        Image("hanger_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .offset(x: 1)
                    }
                    .rotationEffect(.degrees(15))
                    .offset(x: 108, y: 48)
                    .zIndex(2) // 👈 bring to front
                }
                .padding(.top, 20)

                Spacer()

                // MARK: Content
                if viewModel.items.isEmpty {

                    VStack(spacing: 20) {
                        Text("Your Closet is\nempty :(")
                            .font(.custom("American Typewriter", size: 32))
                            .multilineTextAlignment(.center)

                        Text("Start Adding Clothes!")
                            .foregroundColor(.gray)
                    }

                } else {

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {

                            // My Favorites
                            NavigationLink {
                                FavoritesView(viewModel: viewModel)
                            } label: {
                                VStack(spacing: 10) {

                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color("WardraPink"))

                                        Text("my Favorites")
                                            .font(.custom("American Typewriter", size: 22))
                                    }
                                    .frame(height: 44)
                                    .padding(.horizontal, 24)

                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.white.opacity(0.35))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(Color("WardraPink"), lineWidth: 3)
                                        )
                                        .overlay {
                                            if let firstFavorite = viewModel.items.filter({ $0.isFavorite }).first,
                                               let image = firstFavorite.image {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding(14)
                                            } else {
                                                Image(systemName: "heart")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(Color("WardraPink").opacity(0.5))
                                            }
                                        }
                                        .frame(height: 180)
                                        .padding(.horizontal, 24)
                                }
                            }
                            .buttonStyle(.plain)

                            // Items
                            VStack(alignment: .leading, spacing: 10) {

                                Text("Items")
                                    .font(.custom("American Typewriter", size: 22))
                                    .padding(.horizontal, 24)

                                HStack(spacing: 16) {

                                    // ✅ Tops (صار قابل للضغط ويفتح TopsView)
                                    NavigationLink {
                                        TopsView(viewModel: viewModel)
                                    } label: {
                                        VStack(spacing: 8) {

                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color("WardraPink"))

                                                Text("Tops")
                                                    .font(.custom("American Typewriter", size: 18))
                                            }
                                            .frame(height: 34)

                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.white.opacity(0.35))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color("WardraPink"), lineWidth: 3)
                                                )
                                                .overlay {
                                                    if let firstTop = tops.first,
                                                       let image = firstTop.image {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding(14)
                                                    }
                                                }
                                                .frame(height: 140)
                                        }
                                    }
                                    .buttonStyle(.plain) // ✅ عشان ما يغيّر شكل التصميم

                                    // ✅ Bottoms (صار قابل للضغط ويفتح BottomsView)
                                    NavigationLink {
                                        BottomsView(viewModel: viewModel)
                                    } label: {
                                        VStack(spacing: 8) {

                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color("WardraPink"))

                                                Text("Bottoms")
                                                    .font(.custom("American Typewriter", size: 18))
                                            }
                                            .frame(height: 34)

                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.white.opacity(0.35))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color("WardraPink"), lineWidth: 3)
                                                )
                                                .overlay {
                                                    if let firstBottom = bottoms.first,
                                                       let image = firstBottom.image {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding(14)
                                                    }
                                                }
                                                .frame(height: 140)
                                        }
                                    }
                                    .buttonStyle(.plain) // ✅ عشان ما يغيّر شكل التصميم
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 10)
                    }
                }

                Spacer()
            }

            // MARK: Plus Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showUpload = true
                    } label: {
                        Circle()
                            .fill(Color("WardraPink"))
                            .frame(width: 65, height: 65)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 26))
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 35)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showUpload) {
            UploadClothesView(
                viewModel: UploadClothesViewModel(),
                onSave: { viewModel.addItem($0) }
            )
        }
    }
}

#Preview {
    ClosetView()
}

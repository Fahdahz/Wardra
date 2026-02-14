//
//  MixMatchCardsView.swift
//  Wardra
//
//  Created by reyamnhf on 21/08/1447 AH.
//
//
//  MixMatchCardsView.swift
//  Wardra
//
//  Created by reyamnhf on 21/08/1447 AH.
//
import SwiftUI

struct MixMatchCardsView: View {

    @ObservedObject var viewModel: ClosetViewModel
    @State private var currentTopIndex = 0
    @State private var currentBottomIndex = 0
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    
    private var tops: [ClothingItem] {
        viewModel.items.filter { $0.category == .top }
    }
    
    private var bottoms: [ClothingItem] {
        viewModel.items.filter { $0.category == .bottom }
    }
    
    private var currentTop: ClothingItem? {
        guard !tops.isEmpty, currentTopIndex < tops.count else { return nil }
        return tops[currentTopIndex]
    }
    
    private var currentBottom: ClothingItem? {
        guard !bottoms.isEmpty, currentBottomIndex < bottoms.count else { return nil }
        return bottoms[currentBottomIndex]
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Color("WardraBackground").ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .padding(.top, 18)
                    
                    if tops.isEmpty || bottoms.isEmpty {
                        emptyStateView
                    } else {
                        ZStack {
                            // back card
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                                .frame(width: 300, height: 440)
                                .shadow(color: .black.opacity(0.06),
                                        radius: 14,
                                        y: 10)
                                .offset(x: -18, y: 12)

                            // swipe card
                            if let top = currentTop, let bottom = currentBottom {
                                SwipeableOutfitCard(
                                    topItem: top,
                                    bottomItem: bottom,
                                    onSwipeRight: {
                                        // ✅ Save the WHOLE outfit
                                        viewModel.addFavoriteOutfit(top: top, bottom: bottom)
                                        nextOutfit()
                                    },
                                    onSwipeLeft: {
                                        // Discard
                                        nextOutfit()
                                    }
                                )
                            }
                        }
                        .padding(.top, 40)
                        .padding(.top, -30)
                    }

                    Spacer()
                }
                .frame(width: w, height: h, alignment: .top)
            }
        }
    }
    
    private func nextOutfit() {
        // Cycle through combinations
        currentTopIndex = (currentTopIndex + 1) % tops.count
        if currentTopIndex == 0 {
            currentBottomIndex = (currentBottomIndex + 1) % bottoms.count
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tshirt")
                .font(.system(size: 60))
                .foregroundColor(Color("WardraPink"))
            
            Text("Add Items to Mix & Match")
                .font(.custom("American Typewriter", size: 24))
                .multilineTextAlignment(.center)
            
            Text("Add at least one top and one bottom\nto start creating outfits!")
                .font(.custom("American Typewriter", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }

    // MARK: - Header exactly like reference (line + hanger + title centered)
    private var header: some View {
        VStack(spacing: 2) {

            Rectangle()
                .fill(Color("WardraPink"))
                .frame(height: 3)
                .padding(.horizontal, 2)
                .padding(.top, 8)
            

            ZStack {
                Image("big_hanger")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320)
                    .padding(.top, -10)

                    .padding(.bottom,90)

                Text("Mix & Match")
                    .font(.custom("American Typewriter", size: 18))
                    .foregroundStyle(.black)
                    .offset(y: -35)
            }
        }
    }
}

struct SwipeableOutfitCard: View {
    let topItem: ClothingItem
    let bottomItem: ClothingItem
    let onSwipeRight: () -> Void
    let onSwipeLeft: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .shadow(color: .black.opacity(0.12),
                        radius: 20,
                        y: 14)

            VStack(spacing: 0) {

                // pink band
                Rectangle()
                    .fill(Color("WardraPink").opacity(0.18))
                    .frame(height: 50)

                Text("Tops")
                    .font(.system(size: 34,
                                  weight: .regular,
                                  design: .serif))
                    .padding(.top, 14)

                if let topImage = topItem.image {
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

                if let bottomImage = bottomItem.image {
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

                Text("Bottoms")
                    .font(.system(size: 34,
                                  weight: .regular,
                                  design: .serif))
                    .padding(.bottom, 20)
            }
            
            // Swipe indicators
            if abs(offset.width) > 20 {
                VStack {
                    HStack {
                        if offset.width > 0 {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .opacity(min(Double(offset.width) / 100, 1.0))
                        }
                        Spacer()
                        if offset.width < 0 {
                            Image(systemName: "xmark")
                                .font(.system(size: 60))
                                .foregroundColor(.red)
                                .opacity(min(Double(-offset.width) / 100, 1.0))
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 60)
                    Spacer()
                }
            }
        }
        .frame(width: 320, height: 460)
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    rotation = Double(gesture.translation.width / 20)
                }
                .onEnded { gesture in
                    if abs(gesture.translation.width) > 120 {
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset.width = gesture.translation.width > 0 ? 500 : -500
                            opacity = 0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            if gesture.translation.width > 0 {
                                onSwipeRight()
                            } else {
                                onSwipeLeft()
                            }
                            offset = .zero
                            rotation = 0
                            opacity = 1
                        }
                    } else {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            offset = .zero
                            rotation = 0
                        }
                    }
                }
        )
    }
}

private struct DiagonalDivider: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.35))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.65))
        return p
    }
}

#Preview {
    MixMatchCardsView(viewModel: ClosetViewModel())
}


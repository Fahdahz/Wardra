//
//  MixMatchCardsView.swift
//  Wardra
//
//  Created by reyamnhf on 21/08/1447 AH.
//
import SwiftUI

struct MixMatchCardsView: View {

    private let topImageName = "top"
    private let bottomImageName = "bottom"

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // Tuned to match the reference screenshot proportions
            let cardW = min(360, w * 0.86)
            let cardH = min(520, h * 0.62)

            ZStack {
                Color("WardraBackground").ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .padding(.top, 18)
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
                        SwipeCardView(
                            topImage: "top",
                            bottomImage: "bottom"
                        )
                    }
                    .padding(.top, 40)
                    .padding(.top, -30)

                    Spacer()
                }
                .frame(width: w, height: h, alignment: .top)
            }
        }
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

    // MARK: - Card content exactly like reference (pink strip + clothes + diagonal divider)
    private var frontCardContent: some View {
        VStack(spacing: 0) {

            Text("Tops")
                .font(.system(size: 25, weight: .regular, design: .serif))
                .padding(.top, 80)
                .rotationEffect(.degrees(-2))
            
            // TOP IMAGE (center, no gray box)
            Image(topImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 155)
                .padding(.top, 12)
                .padding(.bottom, 18)

            // Diagonal divider line (like the reference)
            DiagonalDivider()
                .stroke(Color.black.opacity(0.10), lineWidth: 1)
                .frame(height: 40)
                .padding(.horizontal, 18)

            // BOTTOM IMAGE
            Image(bottomImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 190)
                .padding(.top, 6)

            Spacer(minLength: 0)

            Text("Bottoms")
                .font(.system(size: 25, weight: .regular, design: .serif))
                .padding(.bottom, 20)
                .rotationEffect(.degrees(-2))
        }
    }
}

// MARK: - Diagonal divider shape
private struct DiagonalDivider: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        // slight diagonal down to the right like your reference
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.35))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.65))
        return p
    }
}

#Preview {
    MixMatchCardsView()
}

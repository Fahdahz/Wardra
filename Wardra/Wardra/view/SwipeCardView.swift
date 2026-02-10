//
//  SwipeCardView.swift
//  Wardra
//
//  Created by reyamnhf on 21/08/1447 AH.
//
import SwiftUI

struct SwipeCardView: View {

    let topImage: String
    let bottomImage: String

    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0

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

                Image(topImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)

                Divider()
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)

                Image(bottomImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 190)

                Spacer()

                Text("Bottoms")
                    .font(.system(size: 34,
                                  weight: .regular,
                                  design: .serif))
                    .padding(.bottom, 20)
            }
        }
        .frame(width: 320, height: 460)

        // 🔥 swipe physics
        .offset(offset)

        .rotationEffect(.degrees(rotation))

        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation

                    rotation = Double(gesture.translation.width / 20)
                }

                .onEnded { gesture in

                    if abs(gesture.translation.width) > 120 {

                        // fling away
                        offset.width = gesture.translation.width > 0 ? 500 : -500

                    } else {

                        // snap back
                        offset = .zero
                        rotation = 0
                    }
                }
        )

        .animation(.spring(response: 0.35,
                           dampingFraction: 0.75),
                   value: offset)
    }
}



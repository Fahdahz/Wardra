//
//  SplashView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        ZStack {
            // Background color
            Color(hex: "#FBF6F1")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // Top fabric image
                Image("splash_fabric")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
                    .ignoresSafeArea(edges: .top)


                // App name card
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#E5B7C5"), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "#FBF6F1"))
                        )

                    HStack(spacing: 0) {
                        Text("Ward")
                            .foregroundColor(Color(hex: "#E5B7C5"))
                        Text("ra")
                            .foregroundColor(Color(hex: "#3A3A3A"))
                    }
                    .font(.system(size: 26, weight: .medium, design: .serif))
                }
                .frame(width: 220, height: 56)
                .offset(y: -28)

                Spacer()

                // Closet illustration
                Image("splash_closet")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .padding(.bottom, 40)

                Spacer()
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 255, (int >> 8) & 255, int & 255)
        case 8:
            (a, r, g, b) = ((int >> 24) & 255, (int >> 16) & 255, (int >> 8) & 255, int & 255)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


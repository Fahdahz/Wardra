//
//  popup.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 22/08/1447 AH.
//

import SwiftUI

struct Popup: View {
    @State private var showCard: Bool = true

    private let bg = Color(hex: "#FFFBF7")
    private let pinkLine = Color(hex: "#E1C1C4")
    private let pinkButton = Color(hex: "#E1C1C4")
    private let textDark = Color(hex: "#6B5E5E")
    private let cardTop = Color(hex: "#FFF5F5")
    
    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 8)
                Rectangle()
                    .fill(pinkLine)
                    .frame(height: 5)
                
                Spacer()
                
                if showCard {
                    CardView(
                        textDark: textDark,
                        cardTop: cardTop,
                        pinkButton: pinkButton,
                        onClose: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                showCard = false
                            }
                        },
                        onAction: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                showCard = false
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                    .padding(.horizontal, 32)
                }
                
                Spacer()
            }
        }
    }
}

private struct CardView: View {
    let textDark: Color
    let cardTop: Color
    let pinkButton: Color
    let onClose: () -> Void
    let onAction: () -> Void
    
    private let corner: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(textDark.opacity(0.85))
                            .padding(8)
                    }
                    Spacer()
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(cardTop)
            .mask(
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .frame(height: 40)
                    Rectangle().frame(height: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            )
            
            VStack(spacing: 16) {
                Text("You don’t have any clothes!")
                    .font(.custom("American Typewriter", size: 18))
                    .foregroundColor(textDark)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 60)
                    .padding(.top, 2)
                
                Button(action: onAction) {
                    Text("My Closet")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(textDark.opacity(0.95))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 22)
                        .background(
                            Capsule()
                                .fill(pinkButton.opacity(0.25))
                        )
                        .overlay(
                            Capsule()
                                .stroke(pinkButton, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
                }
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .mask(
                VStack(spacing: 0) {
                    Rectangle().frame(height: 0)
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .frame(height: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(Color.white)
        )
        .frame(minWidth: 280, maxWidth: 320)
        .padding(.vertical, 4)
        .shadow(color: .black.opacity(0.10), radius: 12, x: 0, y: 8)
        .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: UUID())
    }
}

private extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

#Preview {
    Popup()
        .previewDevice("iPhone 15")
}

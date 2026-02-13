//
//  CanvasView.swift
//  Wardra
//
//  Created by dana on 23/08/1447 AH.
//



import SwiftUI

struct CanvasView: View {

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // ✅ style it your way
            let cardW = min(360, w * 0.90)
            let cardH = min(520, h * 0.66)

            ZStack {
                Color("WardraBackground")
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color("lightpink").opacity(0.25))
                        .frame(height: 85)
                        .padding(.bottom, 30)
                }

                VStack(spacing: 0) {

                    // Top buttons
                    HStack(spacing: 18) {
                        pillButton(title: "Tops") { }
                        pillButton(title: "Bottoms") { }
                    }
                    .padding(.top, 22)
                    .padding(.bottom, 14)

                    // Canvas card
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)

                        VStack(spacing: 0) {
                            // Header strip
                            ZStack {
                                Rectangle()
                                    .fill(Color("lightpink").opacity(0.35))
                                    .frame(height: 56)

                                Text("Style It Your Way!")
                                    .font(.custom("American Typewriter", size: 22))
                                    .foregroundStyle(.black)
                            }

                          
                            Spacer()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .frame(width: cardW, height: cardH)
                    .padding(.top, 12)
                    .overlay(alignment: .leading) {
                      
                        Button {
                            // action
                        } label: {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color("WardraPink"))
                                .frame(width: 78, height: 45)
                                .overlay(
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.system(size: 26, weight: .regular))
                                        .foregroundColor(.white)
                                )
                        }
                        .offset(x: -32, y: cardH * 0.40)
                    }

                    Spacer()
                }
                .frame(width: w, height: h, alignment: .top)
            }
        }
    }

    private func pillButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom("American Typewriter", size: 20))
                .foregroundColor(.white)
                .frame(width: 140, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color("WardraPink"))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CanvasView()
}



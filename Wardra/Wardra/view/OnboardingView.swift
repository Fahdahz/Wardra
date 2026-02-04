//
//  OnboardingView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            // Base background
            Color(hex: "#FBF6F1")
                .ignoresSafeArea()

            // Background fabric on the left (like sketch)
            HStack(spacing: 0) {
                Image("onboarding_fabric")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170)          // عدليها حسب ذوقك
                    .clipped()
                    .ignoresSafeArea()

                Color(hex: "#FBF6F1")
                    .ignoresSafeArea()
            }

            // Main Card
            VStack {
                Spacer(minLength: 30)

                VStack(spacing: 0) {
                    // ===== Top: Description =====
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.system(size: 28, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#3A3A3A"))

                        // "Description Description" with pink first word
                        (
                            Text("Description ")
                                .foregroundStyle(Color(hex: "#E5B7C5"))
                            +
                            Text("Description\nDescription Description\nDescription Description\nDescription Description\nDescription Description")
                                .foregroundStyle(Color(hex: "#3A3A3A"))
                        )
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 26)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 18)

                    // Divider line (pink-ish)
                    Rectangle()
                        .fill(Color(hex: "#E5B7C5").opacity(0.55))
                        .frame(height: 1)

                    // ===== Bottom: Welcome + Name =====
                    VStack(spacing: 14) {
                        Text("Welcome!")
                            .font(.system(size: 30, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#3A3A3A"))
                            .padding(.top, 22)

                        Text("Please enter your name")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#3A3A3A").opacity(0.85))

                        TextField("First Name", text: $viewModel.firstName)
                            .padding(.horizontal, 14)
                            .frame(height: 44)
                            .background(Color.white.opacity(0.55))
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.black.opacity(0.55), lineWidth: 1)
                            )
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()

                        if let error = viewModel.error {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }

                        Button {
                            viewModel.submit() // هذا لازم يغيّر step للـ closet عندك
                        } label: {
                            Text("My Closet")
                                .font(.system(size: 18, weight: .semibold, design: .serif))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(hex: "#D7B7BC"))
                                .cornerRadius(10)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, 22)
                }
                .background(Color(hex: "#FBF6F1").opacity(0.92))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#E5B7C5").opacity(0.9), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal, 26)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)

                Spacer()
            }
        }
    }
}


//
//  OnboardingView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // ✅ حفظ الاسم
    @AppStorage("userFirstName") private var userFirstName: String = ""
    
    var body: some View {
        ZStack {
            
            // MARK: Background Fabric
            Image("onboarding_fabric")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // MARK: Center Card
            VStack(spacing: 22) {
                
                // Title
                Text("Welcome!")
                    .font(.system(size: 34, weight: .regular, design: .serif))
                    .foregroundColor(.black.opacity(0.75))
                
                Text("Please enter your name")
                    .font(.system(size: 18, design: .serif))
                    .foregroundColor(.black.opacity(0.6))
                
                // MARK: Text Field
                TextField("First Name", text: $viewModel.firstName)
                    .padding(.horizontal, 20)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.black.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.top, 10)
                
                // Error
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                // MARK: Button
                Button {
                    viewModel.submit()
                    
                    // ✅ إذا ما فيه خطأ، خزّني الاسم
                    if viewModel.error == nil {
                        userFirstName = viewModel.firstName
                    }
                } label: {
                    Text("My Closet")
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color("WardraPink"))
                        )
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color("WardraBackground"))
                    .shadow(color: .black.opacity(0.08),
                            radius: 20,
                            x: 0,
                            y: 10)
            )
            .padding(.horizontal, 28)
        }
    }
}

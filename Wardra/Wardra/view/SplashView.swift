//
//  SplashView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel
    
    // Animation states
    @State private var hangerOffset: CGFloat = -180
    @State private var hangerOpacity: Double = 0
    @State private var hangerRotation: Double = -15
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color("WardraBackground")   // Use asset color
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    
                    // MARK: Logo
                    Image("wardra_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260)
                        .opacity(logoOpacity)
                        .overlay(alignment: .trailing) {
                            
                            // MARK: Hanger
                            Image("hanger_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .offset(
                                    x: 12,
                                    y: hangerOffset
                                )
                                .rotationEffect(.degrees(hangerRotation))
                                .opacity(hangerOpacity)
                                .shadow(color: .black.opacity(0.08),
                                        radius: 4,
                                        x: 0,
                                        y: 2)
                        }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    // MARK: Animation Timeline
    private func startAnimation() {
        
        // 1️⃣ Fade logo in
        withAnimation(.easeIn(duration: 1.5)) {
            logoOpacity = 1
        }
        
        // 2️⃣ Drop hanger slightly delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            hangerOpacity = 1
            
            withAnimation(
                .interpolatingSpring(
                    stiffness: 180,
                    damping: 14
                )
            ) {
                hangerOffset = 35     // rests on last letter
                hangerRotation = 0     // straightens when landing
            }
        }
        
        // 3️⃣ Small secondary bounce
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(
                .interpolatingSpring(
                    stiffness: 220,
                    damping: 18
                )
            ) {
                hangerOffset = 33
            }
        }
        
        // 4️⃣ Transition to onboarding
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            viewModel.start()
        }
    }
}

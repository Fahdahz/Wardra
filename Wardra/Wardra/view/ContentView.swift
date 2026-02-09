//
//  ContentView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 13/08/1447 AH.
//

import SwiftUI

enum AppStep {
    case splash
    case onboarding
    case closet
}

struct ContentView: View {
    @State private var step: AppStep = .splash
    
    var body: some View {
        switch step {
        case .splash:
            SplashView(
                viewModel: SplashViewModel {
                    // بعد انتهاء السبلاش
                    step = .onboarding
                }
            )
            
        case .onboarding:
            OnboardingView(
                viewModel: OnboardingViewModel {
                    // بعد إدخال الاسم
                    step = .closet
                }
            )
            
        case .closet:
            ClosetView()
        }
    }
}

#Preview {
    ContentView()
}

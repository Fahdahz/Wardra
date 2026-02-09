//
//  SplashViewModel.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import Foundation
import Combine

@MainActor
final class SplashViewModel: ObservableObject {
    
    private let onFinish: () -> Void
    
    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }
    
    func start() {
        onFinish()
    }
}

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
    @Published var finished = false

    private let onFinish: () -> Void
    private let duration: UInt64 = 3_000_000_000 // 3 seconds

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func start() {
        Task {
            try? await Task.sleep(nanoseconds: duration)
            finished = true
            onFinish()
        }
    }
}


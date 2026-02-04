//
//  OnboardingViewModel.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var error: String?

    private let onSuccess: () -> Void

    init(onSuccess: @escaping () -> Void) {
        self.onSuccess = onSuccess
    }

    func submit() {
        let name = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard name.count > 1 else {
            error = "Please enter your name"
            return
        }
        error = nil
        onSuccess()
    }
}


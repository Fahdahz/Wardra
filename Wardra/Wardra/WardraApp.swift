//
//  WardraApp.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 13/08/1447 AH.
//
import SwiftUI

@main
struct WardraApp: App {

    // 0 = System, 1 = Light, 2 = Dark
    @AppStorage("appearanceMode") private var appearanceMode: Int = 0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(selectedScheme)
        }
    }

    private var selectedScheme: ColorScheme? {
        switch appearanceMode {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return nil // follows system
        }
    }
}

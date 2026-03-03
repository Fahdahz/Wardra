//
//  AppearanceSettingsView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 14/09/1447 AH.
//

import SwiftUI

struct AppearanceSettingsView: View {

    @AppStorage("appearanceMode") private var appearanceMode: Int = 0

    var body: some View {
        VStack(spacing: 20) {

            Text("Appearance")
                .font(.custom("American Typewriter", size: 22))

            Picker("Appearance", selection: $appearanceMode) {
                Text("System").tag(0)
                Text("Light").tag(1)
                Text("Dark").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
    }
}

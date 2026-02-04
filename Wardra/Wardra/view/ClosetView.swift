//
//  ClosetView.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import SwiftUI

struct ClosetView: View {
    @StateObject var viewModel: ClosetViewModel

    var body: some View {
        VStack {
            if viewModel.items.isEmpty {
                Text("Your closet is empty")
            } else {
                List(viewModel.items) { item in
                    Text(item.category.rawValue)
                }
            }

            Button("+ Add") {
                viewModel.showUpload = true
            }
        }
        .sheet(isPresented: $viewModel.showUpload) {
            UploadClothesView(viewModel: UploadClothesViewModel()) { item in
                viewModel.add(item: item)
            }
        }
    }
}

//
//  ClosetViewModel.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import Foundation
import Combine
import SwiftUI


@MainActor
final class ClosetViewModel: ObservableObject {
    
    @Published var items: [ClothingItem] = []
    
    func addItem(_ item: ClothingItem) {
        items.append(item)
    }
}

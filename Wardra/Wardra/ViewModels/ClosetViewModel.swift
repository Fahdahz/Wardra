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
    
    init() {
        loadItems()
    }
    
    func addItem(_ item: ClothingItem) {
        items.append(item)
        saveItems()
    }
    
    func toggleFavorite(_ item: ClothingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isFavorite.toggle()
            saveItems()
        }
    }
    
    func deleteItem(_ item: ClothingItem) {
        items.removeAll { $0.id == item.id }
        // Delete the image file
        PersistenceManager.shared.deleteImage(fileName: item.imageFileName)
        saveItems()
    }
    
    private func saveItems() {
        PersistenceManager.shared.saveItems(items)
    }
    
    private func loadItems() {
        items = PersistenceManager.shared.loadItems()
    }
}

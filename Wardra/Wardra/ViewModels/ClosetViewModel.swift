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

    // ✅ جديد: الأوتفتس المفضلة
    @Published var favoriteOutfits: [FavoriteOutfit] = []

    init() {
        loadItems()
        loadFavoriteOutfits()
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
        PersistenceManager.shared.deleteImage(fileName: item.imageFileName)

        // ✅ إذا القطعة داخلة في أوتفت مفضل، احذف الأوتفت
        favoriteOutfits.removeAll { $0.topID == item.id || $0.bottomID == item.id }
        saveFavoriteOutfits()

        saveItems()
    }

    // ✅ جديد: أضف أوتفت للمفضلة (هذا اللي لازم ينادى عند swipe right)
    func addFavoriteOutfit(top: ClothingItem, bottom: ClothingItem) {
        let exists = favoriteOutfits.contains { $0.topID == top.id && $0.bottomID == bottom.id }
        guard !exists else { return }

        favoriteOutfits.append(FavoriteOutfit(topID: top.id, bottomID: bottom.id))
        saveFavoriteOutfits()

        // (اختياري) خلي القطع نفسها favorite عشان باقي شاشاتكم لو تعتمد عليه
        setItemFavorite(id: top.id, isFavorite: true)
        setItemFavorite(id: bottom.id, isFavorite: true)
        saveItems()
    }

    // ✅ جديد: حذف أوتفت من المفضلة
    func removeFavoriteOutfit(_ outfit: FavoriteOutfit) {
        favoriteOutfits.removeAll { $0.id == outfit.id }
        saveFavoriteOutfits()
    }

    private func setItemFavorite(id: UUID, isFavorite: Bool) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isFavorite = isFavorite
        }
    }

    private func saveItems() {
        PersistenceManager.shared.saveItems(items)
    }

    private func loadItems() {
        items = PersistenceManager.shared.loadItems()
    }

    private func saveFavoriteOutfits() {
        PersistenceManager.shared.saveFavoriteOutfits(favoriteOutfits)
    }

    private func loadFavoriteOutfits() {
        favoriteOutfits = PersistenceManager.shared.loadFavoriteOutfits()
    }
}

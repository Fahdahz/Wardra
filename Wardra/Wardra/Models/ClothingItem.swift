//
//  ClothingItem.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import Foundation

struct ClothingItem: Identifiable, Codable {
    let id: UUID
    let category: ClothingCategory
    let imageData: Data
    let createdAt: Date

    init(category: ClothingCategory, imageData: Data) {
        self.id = UUID()
        self.category = category
        self.imageData = imageData
        self.createdAt = Date()
    }
}

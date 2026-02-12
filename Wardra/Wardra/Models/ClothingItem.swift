//
//  ClothingItem.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import UIKit

struct ClothingItem: Identifiable, Codable {
    let id: UUID
    let imageFileName: String  // Store filename instead of UIImage
    let category: ClothingCategory
    var isFavorite: Bool = false
    
    // Computed property to get the actual image
    var image: UIImage? {
        PersistenceManager.shared.loadImage(fileName: imageFileName)
    }
    
    // For backward compatibility and creating new items
    init(id: UUID = UUID(), image: UIImage, category: ClothingCategory, isFavorite: Bool = false) {
        self.id = id
        self.imageFileName = id.uuidString + ".jpg"
        self.category = category
        self.isFavorite = isFavorite
        
        // Save image to disk
        PersistenceManager.shared.saveImage(image, fileName: self.imageFileName)
    }
    
    // Codable init
    init(id: UUID, imageFileName: String, category: ClothingCategory, isFavorite: Bool) {
        self.id = id
        self.imageFileName = imageFileName
        self.category = category
        self.isFavorite = isFavorite
    }
}

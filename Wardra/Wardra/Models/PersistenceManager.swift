//
//  PersistenceManager.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 24/08/1447 AH.

//  Manages saving and loading clothing items and images
//

import UIKit

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let itemsKey = "savedClothingItems"
    private let imagesDirectory: URL
    
    private init() {
        // Create images directory in documents folder
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        imagesDirectory = documentsPath.appendingPathComponent("ClothingImages", isDirectory: true)
        
        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            try? FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Items Management
    
    func saveItems(_ items: [ClothingItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: itemsKey)
        }
    }
    
    func loadItems() -> [ClothingItem] {
        guard let data = UserDefaults.standard.data(forKey: itemsKey),
              let items = try? JSONDecoder().decode([ClothingItem].self, from: data) else {
            return []
        }
        return items
    }
    
    // MARK: - Image Management
    
    func saveImage(_ image: UIImage, fileName: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        try? data.write(to: fileURL)
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    func deleteImage(fileName: String) {
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
}

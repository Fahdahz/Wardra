//
//  ClosetViewModel.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

import Foundation
import Combine

@MainActor
final class ClosetViewModel: ObservableObject {
    @Published var items: [ClothingItem] = []
    @Published var showUpload = false

    private let key = "closet_items"

    init() {
        load()
    }

    func add(item: ClothingItem) {
        items.insert(item, at: 0)
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ClothingItem].self, from: data)
        else { return }

        items = decoded
    }

    private func save() {
        let data = try? JSONEncoder().encode(items)
        UserDefaults.standard.set(data, forKey: key)
    }
}

//
//  FavoriteOutfit.swift
//  Wardra
//
//  Created by dana on 26/08/1447 AH.
//

import Foundation

struct FavoriteOutfit: Identifiable, Codable, Equatable {
    let id: UUID
    let topID: UUID
    let bottomID: UUID
    let createdAt: Date

    init(id: UUID = UUID(), topID: UUID, bottomID: UUID, createdAt: Date = Date()) {
        self.id = id
        self.topID = topID
        self.bottomID = bottomID
        self.createdAt = createdAt
    }
}

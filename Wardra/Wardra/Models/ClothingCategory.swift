//
//  ClothingCategory.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
//

enum ClothingCategory: String, CaseIterable, Identifiable, Codable {
    case top = "Top"
    case bottom = "Bottom"

    var id: String { rawValue }
}

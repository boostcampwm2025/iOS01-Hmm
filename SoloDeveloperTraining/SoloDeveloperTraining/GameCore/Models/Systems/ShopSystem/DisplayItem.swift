//
//  DisplayItem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/19/26.
//

import Foundation

struct DisplayItem: Identifiable, Item {
    // MARK: - Item
    var displayTitle: String {
        return item.displayTitle
    }
    var description: String {
        return item.description
    }
    var cost: Cost {
        return item.cost
    }
    var imageName: String {
        return item.imageName
    }
    var category: ItemCategory {
        return item.category
    }

    // MARK: - DisplayItem
    let id = UUID()
    let item: Item
    let isEquipped: Bool?
    let isPurchasable: Bool?
}

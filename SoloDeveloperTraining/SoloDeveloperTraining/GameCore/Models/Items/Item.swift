//
//  Item.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/20/26.
//

import Foundation

protocol Item {
    /// 화면에 표시될 제목
    var displayTitle: String { get }
    var description: String { get }
    var cost: Cost { get }
    var imageName: String { get }
}

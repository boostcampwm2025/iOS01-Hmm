//
//  ShopSystemError.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/19/26.
//

import Foundation

/// 구매 기능 관련 에러
enum PurchasingError: Error {
    /// 골드 부족
    case insufficientGold
    /// 다이아몬드 부족
    case insufficientDiamond
    /// 구매 실패
    case purchaseFailed
}

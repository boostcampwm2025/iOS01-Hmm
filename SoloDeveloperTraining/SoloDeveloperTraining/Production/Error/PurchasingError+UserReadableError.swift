//
//  PurchasingError+UserReadableError.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

extension PurchasingError: UserReadableError {
    var message: String {
        switch self {
        case .insufficientGold: "골드가 부족합니다."
        case .insufficientDiamond: "다이아가 부족합니다."
        case .locked: "해당 항목은 잠겨있습니다."
        case .purchaseFailed: "구매에 실패했습니다."
        }
    }
}

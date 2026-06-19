//
//  EffectLabelData.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/19/26.
//

import Foundation

/// EffectLabel 데이터 모델
struct EffectLabelData: Identifiable {
    let id: UUID
    let position: CGPoint
    let value: Int
}

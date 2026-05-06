//
//  ScenarioPage.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

import Foundation

/// 시나리오의 개별 페이지
struct ScenarioPage {
    /// 페이지 고유 ID
    let id: String
    /// 이미지
    let image: String?
    /// 페이지 텍스트 내용
    let text: String
    /// 페이지 타입
    let pageType: PageType

    init(
        id: String = UUID().uuidString,
        image: String? = nil,
        text: String,
        pageType: PageType
    ) {
        self.id = id
        self.image = image
        self.text = text
        self.pageType = pageType
    }
}

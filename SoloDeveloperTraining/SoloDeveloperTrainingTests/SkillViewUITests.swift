//
//  SoloDeveloperTrainingTests.swift
//  SoloDeveloperTrainingTests
//
//  Created by sunjae on 2/3/26.
//

import XCTest

final class SkillViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // 실패 시 바로 종료
        continueAfterFailure = false
    }

    @MainActor
    func test_스킬_최고레벨도달시_버튼상태가_올바른지() throws {
        let app = XCUIApplication()
        app.launch()
        app.tap()
        app.buttons["스킬"].tap()

        let element = app.images.matching(identifier: "icon_coin_bag").element(
            boundBy: 1
        )
        // 업그레이드 반복 (최고레벨까지)
        var reachedMax = false
        // 충분히 많이 탭한다고 가정
        for _ in 0..<100000 {
            element.tap()
            // 업그레이드 후 상태 확인
            let stateLabel = app.staticTexts.matching(identifier: "Max").element(
                boundBy: 1
            )
            if stateLabel.exists {
                reachedMax = true
                break
            }
        }
        // 검증
        XCTAssertTrue(reachedMax, "스킬이 최고 레벨에 도달해야 합니다")
    }
}

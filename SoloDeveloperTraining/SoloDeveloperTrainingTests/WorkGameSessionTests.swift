//
//  WorkGameSessionTests.swift
//  SoloDeveloperTrainingTests
//
//  Created by Codex on 5/23/26.
//

import Testing
@testable import SoloDeveloperTraining
import SwiftUI

struct WorkGameSessionTests {

    @Test("새 게임 시작 시 세션 상태를 초기화한다")
    func startResetsSessionForNewGame() {
        let session = WorkGameSession()
        session.pendingTab = .shop
        session.isPauseRequested = true
        session.actionGoldDelta = 100
        session.showsExitBonusPopup = true

        session.start()

        #expect(session.isInProgress)
        #expect(session.pendingTab == nil)
        #expect(!session.isPauseRequested)
        #expect(session.actionGoldDelta == 0)
        #expect(!session.showsExitBonusPopup)
    }

    @Test("탭 이동 요청 시 대기 탭과 일시정지 요청을 설정한다")
    func requestTabSwitchStoresPendingTabAndPauseRequest() {
        let session = WorkGameSession()

        session.requestTabSwitch(to: .skill)

        #expect(session.pendingTab == .skill)
        #expect(session.isPauseRequested)
    }

    @Test("일시정지 요청 취소 시 대기 탭을 초기화한다")
    func cancelPauseRequestClearsPendingTab() {
        let session = WorkGameSession()
        session.requestTabSwitch(to: .mission)

        session.cancelPauseRequest()

        #expect(session.pendingTab == nil)
        #expect(!session.isPauseRequested)
    }

    @Test("게임 종료 시 대기 탭을 반환하고 세션 내부 대기 탭은 초기화한다")
    func finishReturnsPendingTabAndClearsIt() {
        let session = WorkGameSession()
        session.start()
        session.requestTabSwitch(to: .shop)

        let pendingTab = session.finish()

        #expect(pendingTab == .shop)
        #expect(!session.isInProgress)
        #expect(session.pendingTab == nil)
    }

    @Test("대기 탭이 없으면 게임 종료 시 nil을 반환한다")
    func finishReturnsNilWithoutPendingTab() {
        let session = WorkGameSession()
        session.start()

        let pendingTab = session.finish()

        #expect(pendingTab == nil)
        #expect(!session.isInProgress)
    }

    @Test("광고를 보지 않고 다른 탭으로 나가는 경우 보너스 팝업만 닫고 게임 상태와 일시정지를 유지한다")
    func closeExitBonusPopupReturnsPendingTabAndKeepsGamePaused() {
        let session = WorkGameSession()
        session.start()
        session.requestTabSwitch(to: .shop)
        session.showsExitBonusPopup = true

        let pendingTab = session.closeExitBonusPopupAndReturnPendingTab()

        #expect(pendingTab == .shop)
        #expect(session.isInProgress)
        #expect(session.isPauseRequested)
        #expect(session.pendingTab == .shop)
        #expect(!session.showsExitBonusPopup)
    }

    @Test("업무 탭에서 광고를 보지 않고 나가는 경우 보너스 팝업을 닫고 대기 탭 없이 반환한다")
    func closeExitBonusPopupReturnsNilWhenPendingTabIsMissing() {
        let session = WorkGameSession()
        session.start()
        session.isPauseRequested = true
        session.showsExitBonusPopup = true

        let pendingTab = session.closeExitBonusPopupAndReturnPendingTab()

        #expect(pendingTab == nil)
        #expect(session.pendingTab == nil)
        #expect(!session.showsExitBonusPopup)
    }

    @Test("게임 콜백을 초기화한다")
    func clearGameCallbacksRemovesCallbacks() {
        let session = WorkGameSession()
        session.resumeGame = {}
        session.exitGame = {}

        session.clearGameCallbacks()

        #expect(session.resumeGame == nil)
        #expect(session.exitGame == nil)
    }

    @Test("세션 바인딩이 세션 상태를 갱신한다")
    func bindingsUpdateSessionState() {
        let session = WorkGameSession()
        var didResume = false

        session.actionGoldDeltaBinding.wrappedValue = 150
        session.exitBonusPopupBinding.wrappedValue = true
        session.exitBonusToastBinding.wrappedValue = true
        session.resumeGameBinding.wrappedValue = { didResume = true }

        #expect(session.actionGoldDelta == 150)
        #expect(session.showsExitBonusPopup)
        #expect(session.showsExitBonusToast)

        session.resumeGame?()
        #expect(didResume)
    }
}

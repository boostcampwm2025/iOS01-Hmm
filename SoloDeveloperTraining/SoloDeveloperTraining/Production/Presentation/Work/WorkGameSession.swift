//
//  WorkGameSession.swift
//  SoloDeveloperTraining
//
//  Created by Codex on 5/22/26.
//

import SwiftUI

@Observable
final class WorkGameSession {
    var isInProgress: Bool = false
    var pendingTab: TabItem?
    var isPauseRequested: Bool = false
    var actionGoldDelta: Int = 0
    var showsExitBonusPopup: Bool = false
    var showsExitBonusToast: Bool = false
    var exitBonusToastMessage: String = ""
    var resumeGame: (() -> Void)?
    var exitGame: (() -> Void)?

    // 게임 시작
    func start() {
        isInProgress = true
        pendingTab = nil
        isPauseRequested = false
        actionGoldDelta = 0
        showsExitBonusPopup = false
    }

    // 게임 종료 후 이동을 원하는 탭을 반환하고, 세션 내부 pending 상태는 초기화
    func finish() -> TabItem? {
        isInProgress = false
        defer { pendingTab = nil }
        return pendingTab
    }

    // 게임 화면에서 다른 탭 전환 시도
    func requestTabSwitch(to tab: TabItem) {
        pendingTab = tab
        isPauseRequested = true
    }

    // 게임 '계속하기'
    func cancelPauseRequest() {
        pendingTab = nil
        isPauseRequested = false
    }

    // 보너스 팝업에서 '그냥 나가기' 선택
    func closeExitBonusPopupAndReturnPendingTab() -> TabItem? {
        showsExitBonusPopup = false
        return pendingTab
    }

    // 클로저 정리
    func clearGameCallbacks() {
        resumeGame = nil
        exitGame = nil
    }
}

extension WorkGameSession {
    var actionGoldDeltaBinding: Binding<Int> {
        Binding(
            get: { self.actionGoldDelta },
            set: { self.actionGoldDelta = $0 }
        )
    }

    var exitBonusPopupBinding: Binding<Bool> {
        Binding(
            get: { self.showsExitBonusPopup },
            set: { self.showsExitBonusPopup = $0 }
        )
    }

    var exitBonusToastBinding: Binding<Bool> {
        Binding(
            get: { self.showsExitBonusToast },
            set: { self.showsExitBonusToast = $0 }
        )
    }

    var resumeGameBinding: Binding<(() -> Void)?> {
        Binding(
            get: { self.resumeGame },
            set: { self.resumeGame = $0 }
        )
    }

    var exitGameBinding: Binding<(() -> Void)?> {
        Binding(
            get: { self.exitGame },
            set: { self.exitGame = $0 }
        )
    }
}

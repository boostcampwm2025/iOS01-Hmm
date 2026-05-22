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

    func start() {
        isInProgress = true
        pendingTab = nil
        isPauseRequested = false
        actionGoldDelta = 0
        showsExitBonusPopup = false
    }

    func finish() -> TabItem? {
        isInProgress = false
        defer { pendingTab = nil }
        return pendingTab
    }

    func requestTabSwitch(to tab: TabItem) {
        pendingTab = tab
        isPauseRequested = true
    }

    func cancelPauseRequest() {
        pendingTab = nil
        isPauseRequested = false
    }

    func resetCallbacks() {
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

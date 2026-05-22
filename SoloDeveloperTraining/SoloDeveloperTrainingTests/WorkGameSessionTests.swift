//
//  WorkGameSessionTests.swift
//  SoloDeveloperTrainingTests
//
//  Created by Codex on 5/23/26.
//

import Testing
@testable import SoloDeveloperTraining

// MARK: - 기존 MainView에 흩어져 있던 상태 로직의 묶음 (Legacy)
private struct LegacyWorkGameState {
    var selectedTab: TabItem = .work
    var targetTab: TabItem = .work
    var isWorkGameInProgress: Bool = false
    var tabSwitchPause: Bool = false
    var gameActionGoldDelta: Int = 0

    var pendingTab: TabItem? {
        tabSwitchPause && targetTab != .work ? targetTab : nil
    }

    mutating func setGameStarted(_ isStarted: Bool) {
        isWorkGameInProgress = isStarted

        guard !isStarted else {
            targetTab = .work
            gameActionGoldDelta = 0
            return
        }

        if targetTab != .work {
            selectedTab = targetTab
            targetTab = .work
        }
    }

    mutating func setTabSwitchPause(_ isPaused: Bool) {
        tabSwitchPause = isPaused
        if !isPaused {
            targetTab = .work
        }
    }

    mutating func handleTabTap(_ newTab: TabItem) {
        guard selectedTab != newTab else { return }

        if isWorkGameInProgress && selectedTab == .work && newTab != .work {
            targetTab = newTab
            tabSwitchPause = true
            return
        }

        selectedTab = newTab
        targetTab = newTab
    }

    mutating func exitWorkGame(shouldReturnToWorkTab: Bool) {
        if shouldReturnToWorkTab {
            targetTab = .work
        }
        setGameStarted(false)
        tabSwitchPause = false
    }
}

// MARK: - 리팩토링 후 WorkGameSession 기반의 상태 로직
private struct CurrentWorkGameState {
    var selectedTab: TabItem = .work
    var session = WorkGameSession()

    mutating func setGameStarted(_ isStarted: Bool) {
        guard !isStarted else {
            session.start()
            return
        }

        if let pendingTab = session.finish() {
            selectedTab = pendingTab
        }
    }

    mutating func setTabSwitchPause(_ isPaused: Bool) {
        if isPaused {
            session.isPauseRequested = true
        } else {
            session.cancelPauseRequest()
        }
    }

    mutating func handleTabTap(_ newTab: TabItem) {
        guard selectedTab != newTab else { return }

        if session.isInProgress && selectedTab == .work && newTab != .work {
            session.requestTabSwitch(to: newTab)
            return
        }

        selectedTab = newTab
    }

    mutating func exitWorkGame(shouldReturnToWorkTab: Bool) {
        if shouldReturnToWorkTab {
            session.pendingTab = nil
        }
        setGameStarted(false)
        session.isPauseRequested = false
        session.clearGameCallbacks()
    }
}

// MARK: - Characterization test
struct WorkGameSessionCharacterizationTests {

    @Test("탭 이동 후 게임 종료 전이가 기존 MainView 상태 전이와 동일하다")
    func tabSwitchExitMatchesLegacyMainViewStateTransition() {
        var legacy = LegacyWorkGameState()
        var current = CurrentWorkGameState()

        legacy.setGameStarted(true)
        current.setGameStarted(true)

        legacy.handleTabTap(.skill)
        current.handleTabTap(.skill)

        legacy.setGameStarted(false)
        current.setGameStarted(false)

        assertEquivalent(legacy, current)
        #expect(current.selectedTab == .skill)
    }

    @Test("탭 이동 요청 취소 전이가 기존 MainView 상태 전이와 동일하다")
    func tabSwitchCancelMatchesLegacyMainViewStateTransition() {
        var legacy = LegacyWorkGameState()
        var current = CurrentWorkGameState()

        legacy.setGameStarted(true)
        current.setGameStarted(true)

        legacy.handleTabTap(.shop)
        current.handleTabTap(.shop)

        legacy.setTabSwitchPause(false)
        current.setTabSwitchPause(false)

        legacy.setGameStarted(false)
        current.setGameStarted(false)

        assertEquivalent(legacy, current)
        #expect(current.selectedTab == .work)
    }

    @Test("종료 보너스 성공 전이가 기존 MainView 상태 전이와 동일하다")
    func exitBonusSuccessMatchesLegacyMainViewStateTransition() {
        var legacy = LegacyWorkGameState()
        var current = CurrentWorkGameState()

        legacy.setGameStarted(true)
        current.setGameStarted(true)

        legacy.handleTabTap(.mission)
        current.handleTabTap(.mission)

        legacy.exitWorkGame(shouldReturnToWorkTab: true)
        current.exitWorkGame(shouldReturnToWorkTab: true)

        assertEquivalent(legacy, current)
        #expect(current.selectedTab == .work)
    }

    @Test("일반 탭 이동 전이가 기존 MainView 상태 전이와 동일하다")
    func normalTabTapMatchesLegacyMainViewStateTransition() {
        var legacy = LegacyWorkGameState()
        var current = CurrentWorkGameState()

        legacy.handleTabTap(.skill)
        current.handleTabTap(.skill)

        legacy.handleTabTap(.shop)
        current.handleTabTap(.shop)

        assertEquivalent(legacy, current)
        #expect(current.selectedTab == .shop)
    }

    private func assertEquivalent(
        _ legacy: LegacyWorkGameState,
        _ current: CurrentWorkGameState
    ) {
        #expect(legacy.selectedTab == current.selectedTab)
        #expect(legacy.isWorkGameInProgress == current.session.isInProgress)
        #expect(legacy.tabSwitchPause == current.session.isPauseRequested)
        #expect(legacy.pendingTab == current.session.pendingTab)
        #expect(legacy.gameActionGoldDelta == current.session.actionGoldDelta)
    }
}

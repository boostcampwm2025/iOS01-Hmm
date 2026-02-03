//
//  ConcurrencyIssueTests.swift
//  SoloDeveloperTrainingTests
//
//  Created by SeoJunYoung on 2/2/26.
//

import Testing
import Foundation
@testable import SoloDeveloperTraining

struct ConcurrencyIssueTests {

    @Test("Wallet Task.detached Concurrent - race condition 재현")
    func walletTaskDetachedRaceCondition() async throws {
        let user = await User(nickname: "test")
        let wallet = await user.wallet
        let iterations = 10000

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<iterations {
                group.addTask {
                    // Task.detached를 사용하여 actor isolation 우회
                    await Task.detached {
                        await wallet.addGold(1)
                    }.value
                }
            }
        }

        let finalGold = await wallet.gold

        #expect(finalGold == iterations)
    }
}

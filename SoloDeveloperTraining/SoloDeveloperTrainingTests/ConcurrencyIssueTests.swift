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

    @Test("Wallet DispatchQueue Concurrent - race condition 재현")
    func walletDispatchQueueRaceCondition() async throws {
        let user = await User(nickname: "test")
        // User actor에서 wallet을 추출 (let 프로퍼티는 nonisolated 접근 가능)
        let wallet = await user.wallet
        let iterations = 10000

        await withCheckedContinuation { continuation in
            let group = DispatchGroup()

            // DispatchQueue.global()을 사용하여 여러 스레드에서 동시 실행
            for _ in 0..<iterations {
                group.enter()
                DispatchQueue.global(qos: .userInitiated).async {
                    wallet.addGold(1)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                continuation.resume()
            }
        }

        let finalGold = await wallet.gold

        #expect(finalGold == iterations)
    }

    @Test("Wallet Multiple Threads - race condition 재현")
    func walletMultipleThreadsRaceCondition() async throws {
        let user = await User(nickname: "test")
        let wallet = await user.wallet
        let iterations = 10000
        let threadCount = 10

        await withCheckedContinuation { continuation in
            let group = DispatchGroup()

            for _ in 0..<threadCount {
                group.enter()
                DispatchQueue.global(qos: .userInitiated).async {
                    for _ in 0..<(iterations / threadCount) {
                        // 각 스레드에서 반복적으로 gold 추가
                        wallet.addGold(1)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                continuation.resume()
            }
        }

        let finalGold = await wallet.gold

        #expect(finalGold == iterations)
    }

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

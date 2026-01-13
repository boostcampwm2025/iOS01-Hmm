//
//  DodgeGameCore.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import Foundation
import SwiftUI

struct FallingItem: Identifiable {
    let id = UUID()
    let type: DropItem.DropItemType
    var position: CGPoint
    let size: CGSize = CGSize(width: 24, height: 24)

    mutating func updatePosition(by offset: CGFloat) {
        position.y += offset
    }
}

@Observable
final class DodgeGameCore {
    // 게임 설정
    private let updateInterval: TimeInterval = 1.0 / 120.0  // 120fps
    private let spawnInterval: TimeInterval = 0.5           // 0.5초마다 생성
    private let fallSpeed: CGFloat = 1.5                    // 속도 (120fps 기준)
    private let screenWidth: CGFloat = 300                  // 게임 영역 너비
    private let screenHeight: CGFloat = 400                 // 게임 영역 높이
    private let playerSize: CGSize = CGSize(width: 40, height: 40)

    // 게임 상태
    var fallingItems: [FallingItem] = []
    private var spawnTimer: Timer?
    private var updateTimer: Timer?
    var isRunning: Bool = false

    // 충돌 콜백
    var onCollision: ((DropItem.DropItemType) -> Void)?

    // 플레이어 위치 참조 (MotionSystem의 characterX를 사용)
    var playerX: CGFloat = 0

    init() {}

    deinit {
        stop()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        // 낙하물 생성 타이머
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [weak self] _ in
            self?.spawnItem()
        }

        // 낙하물 업데이트 타이머 (120fps)
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.updateItems()
        }
    }

    func stop() {
        isRunning = false
        spawnTimer?.invalidate()
        spawnTimer = nil
        updateTimer?.invalidate()
        updateTimer = nil
        fallingItems.removeAll()
    }
}

private extension DodgeGameCore {
    func spawnItem() {
        // 랜덤 타입 생성 (smallGold: 50%, largeGold: 30%, bug: 20%)
        let randomValue = Int.random(in: 0..<100)
        let type: DropItem.DropItemType
        if randomValue < 50 {
            type = .smallGold
        } else if randomValue < 80 {
            type = .largeGold
        } else {
            type = .bug
        }

        // 랜덤 X 위치 생성
        let randomX = CGFloat.random(in: -screenWidth/2...screenWidth/2)
        let item = FallingItem(
            type: type,
            position: CGPoint(x: randomX, y: -screenHeight/2)
        )
        fallingItems.append(item)
    }

    func updateItems() {
        // 아이템 위치 업데이트
        for index in fallingItems.indices {
            fallingItems[index].updatePosition(by: fallSpeed)
        }

        // 충돌 감지
        checkCollisions()

        // 화면 밖으로 나간 아이템 제거
        fallingItems.removeAll { item in
            item.position.y > screenHeight/2 + 50
        }
    }

    func checkCollisions() {
        var collidedIndices: [Int] = []

        for (index, item) in fallingItems.enumerated() {
            // 플레이어 영역 계산
            let playerRect = CGRect(
                x: playerX - playerSize.width / 2,
                y: screenHeight/2 - 100 - playerSize.height / 2,
                width: playerSize.width,
                height: playerSize.height
            )

            // 아이템 영역 계산
            let itemRect = CGRect(
                x: item.position.x - item.size.width / 2,
                y: item.position.y - item.size.height / 2,
                width: item.size.width,
                height: item.size.height
            )

            // 충돌 확인
            if playerRect.intersects(itemRect) {
                collidedIndices.append(index)
                onCollision?(item.type)
            }
        }

        // 충돌한 아이템 제거 (역순으로 제거)
        for index in collidedIndices.reversed() {
            fallingItems.remove(at: index)
        }
    }
}

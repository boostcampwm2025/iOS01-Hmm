//
//  DodgeGameCore.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import Foundation
import SwiftUI

private enum Constant {
    static let itemRemovalOffset: CGFloat = 50
}

@Observable
final class DodgeGameCore {
    // MARK: - 게임 설정
    /// 게임 업데이트 주사율 (120fps)
    private let updateInterval: TimeInterval = 1.0 / 120.0
    /// 낙하물 생성 간격 (초)
    private let spawnInterval: TimeInterval = 0.5
    /// 낙하 속도 (120fps 기준)
    private let fallSpeed: CGFloat = 1.5
    /// 플레이어 크기
    private let playerSize: CGSize = CGSize(width: 40, height: 40)

    // MARK: - 게임 상태
    /// 현재 화면에 떨어지고 있는 아이템 목록
    var fallingItems: [FallingItem] = []
    /// 게임 실행 여부
    var isRunning: Bool = false

    /// 낙하물 생성 타이머
    private var spawnTimer: Timer?
    /// 게임 업데이트 타이머
    private var updateTimer: Timer?

    // MARK: - Public Properties
    /// 충돌 발생 시 호출되는 콜백
    var onCollision: ((DropItem.DropItemType) -> Void)?
    /// 플레이어의 X 위치 (MotionSystem에서 동기화)
    var playerX: CGFloat = 0
    /// 게임 영역 너비
    var screenWidth: CGFloat
    /// 게임 영역 높이
    var screenHeight: CGFloat

    init(screenWidth: CGFloat, screenHeight: CGFloat) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }

    deinit {
        stop()
    }

    /// 게임 시작 (낙하물 생성 및 업데이트 타이머 활성화)
    func start() {
        guard !isRunning else { return }
        isRunning = true

        // 낙하물 생성 타이머 (0.5초 간격)
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [weak self] _ in
            self?.spawnItem()
        }

        // 낙하물 업데이트 타이머 (120fps)
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.updateItems()
        }
    }

    /// 게임 중지 (모든 타이머 정지 및 낙하물 제거)
    func stop() {
        isRunning = false
        spawnTimer?.invalidate()
        spawnTimer = nil
        updateTimer?.invalidate()
        updateTimer = nil
        fallingItems.removeAll()
    }
}

// MARK: - Private Methods
private extension DodgeGameCore {
    /// 새로운 낙하물 생성
    /// - 생성 확률: smallGold 50%, largeGold 30%, bug 20%
    func spawnItem() {
        // 랜덤 타입 생성
        let randomValue = Int.random(in: 0..<100)
        let type: DropItem.DropItemType
        if randomValue < 50 {
            type = .smallGold
        } else if randomValue < 80 {
            type = .largeGold
        } else {
            type = .bug
        }

        // 랜덤 X 위치 생성 (게임 영역 내)
        let randomX = CGFloat.random(in: -screenWidth/2...screenWidth/2)
        let item = FallingItem(
            type: type,
            position: CGPoint(x: randomX, y: -screenHeight/2)
        )
        fallingItems.append(item)
    }

    /// 모든 낙하물 위치 업데이트 및 충돌 감지
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
    
    func updateItem() {
        var indicesToRemove: [Int] = []
        let removalThreshold = screenHeight/2 + Constant.itemRemovalOffset
        
        // 위치 업데이트 및 제거 대상 수집
        for index in fallingItems.indices {
            fallingItems[index].updatePosition(by: fallSpeed)
            
            if fallingItems[index].position.y > removalThreshold {
                indicesToRemove.append(index)
            }
        }
        
        // 충돌 감지 (제거 전에 먼저 체크)
        checkCollisions()
        
        // 역순으로 제거
        for index in indicesToRemove.reversed() {
            fallingItems.remove(at: index)
        }
    }

    /// 플레이어와 낙하물 간의 충돌 감지
    func checkCollisions() {
        var collidedIndices: [Int] = []

        // 플레이어 Y 위치 계산 (화면 하단에서 25%)
        let playerYOffset = screenHeight * 0.25

        for (index, item) in fallingItems.enumerated() {
            // 플레이어 영역 계산
            let playerRect = CGRect(
                x: playerX - playerSize.width / 2,
                y: screenHeight/2 - playerYOffset - playerSize.height / 2,
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

        // 충돌한 아이템 제거 (역순으로 제거하여 인덱스 오류 방지)
        for index in collidedIndices.reversed() {
            fallingItems.remove(at: index)
        }
    }
}

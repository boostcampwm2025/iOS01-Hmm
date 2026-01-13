//
//  DodgeGameCore.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import Foundation
import SwiftUI

struct FallingItem: Identifiable {
    /// 고유 식별자
    let id = UUID()
    /// 아이템 타입 (smallGold, largeGold, bug)
    let type: DropItem.DropItemType
    /// 화면 상의 위치 (중심점 기준)
    var position: CGPoint
    /// 아이템 크기
    let size: CGSize = CGSize(width: 24, height: 24)

    /// 아이템 위치를 업데이트
    /// - Parameter offset: Y축 이동 오프셋
    mutating func updatePosition(by offset: CGFloat) {
        position.y += offset
    }
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
    /// 게임 영역 너비 (동적으로 설정 가능)
    var screenWidth: CGFloat = 300
    /// 게임 영역 높이 (동적으로 설정 가능)
    var screenHeight: CGFloat = 400
    /// 플레이어 크기
    private let playerSize: CGSize = CGSize(width: 40, height: 40)

    // MARK: - 게임 상태
    /// 현재 화면에 떨어지고 있는 아이템 목록
    var fallingItems: [FallingItem] = []
    /// 낙하물 생성 타이머
    private var spawnTimer: Timer?
    /// 게임 업데이트 타이머
    private var updateTimer: Timer?
    /// 게임 실행 여부
    var isRunning: Bool = false

    // MARK: - Public Properties
    /// 충돌 발생 시 호출되는 콜백
    var onCollision: ((DropItem.DropItemType) -> Void)?
    /// 플레이어의 X 위치 (MotionSystem에서 동기화)
    var playerX: CGFloat = 0

    init() {}

    deinit {
        stop()
    }

    /// 게임 영역 크기 설정
    /// - Parameters:
    ///   - width: 게임 영역 너비
    ///   - height: 게임 영역 높이
    func configure(width: CGFloat, height: CGFloat) {
        self.screenWidth = width
        self.screenHeight = height
    }

    /// 게임을 시작하고 타이머를 활성화
    /// - 낙하물 생성 타이머 (0.5초 간격)
    /// - 게임 업데이트 타이머 (120fps)
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

    /// 게임을 중지하고 모든 타이머와 낙하물을 제거
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
    /// 새로운 낙하물을 랜덤하게 생성하여 추가
    /// - 생성 확률: smallGold 50%, largeGold 30%, bug 20%
    /// - X 위치는 게임 영역 내에서 랜덤
    /// - 초기 Y 위치는 화면 상단
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

    /// 모든 낙하물의 위치를 업데이트하고 충돌을 감지
    /// - 낙하 속도만큼 Y 위치 증가
    /// - 충돌 감지 수행
    /// - 화면 밖으로 나간 아이템 제거
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

    /// 플레이어와 낙하물 간의 충돌을 감지
    /// - CGRect의 intersects를 사용하여 충돌 판정
    /// - 충돌 발생 시 onCollision 콜백 호출
    /// - 충돌한 아이템은 즉시 제거
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

        // 충돌한 아이템 제거 (역순으로 제거)
        for index in collidedIndices.reversed() {
            fallingItems.remove(at: index)
        }
    }
}

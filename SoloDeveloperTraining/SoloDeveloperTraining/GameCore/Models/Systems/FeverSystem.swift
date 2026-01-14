//
//  FeverSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

protocol FeverState {
    var feverStage: Int { get }
    var feverPercent: Double { get }
    var feverMultiplier: Double { get }
}

@Observable
final class FeverSystem: FeverState {

    // MARK: - Properties
    /// 피버 감소 주기 (초 단위)
    private let decreaseInterval: TimeInterval
    /// 피버 감소 퍼센트 (주기당)
    private let decreasePercentPerTick: Double
    /// 현재 피버 단계 (0: 일반, 1~3: 피버 단계)
    private(set) var feverStage: Int = 0
    /// 현재 피버 퍼센트 (0 ~ 300)
    private(set) var feverPercent: Double = 0.0 {
        didSet {
            updateFeverStage()
        }
    }
    /// 피버 감소 타이머
    private var decreaseTimer: Timer?
    /// 피버 시스템 실행 중 여부
    private(set) var isRunning: Bool = false
    /// 피버 단계별 배수
    var feverMultiplier: Double {
        switch feverStage {
        case 0: return 1.0  // 일반
        case 1: return 1.2  // 피버 1단계
        case 2: return 1.5  // 피버 2단계
        case 3: return 2.0  // 피버 3단계 (MAX)
        default: return 1.0
        }
    }

    // MARK: - Initialization
    init(decreaseInterval: TimeInterval, decreasePercentPerTick: Double) {
        self.decreaseInterval = decreaseInterval
        self.decreasePercentPerTick = decreasePercentPerTick
    }

    deinit {
        stop()
    }

    // MARK: - Public Methods
    /// 피버 획득
    /// - Parameter amount: 획득할 피버량
    func gainFever(_ amount: Double) {
        let sumPercent = feverPercent + amount
        feverPercent = min(400, max(0, sumPercent))
    }

    /// 피버 시스템 시작
    func start() {
        guard !isRunning else { return }

        isRunning = true
        decreaseTimer = Timer.scheduledTimer(
            withTimeInterval: decreaseInterval,
            repeats: true
        ) { [weak self] _ in
            self?.decreaseFever()
        }
    }

    /// 피버 시스템 종료
    func stop() {
        isRunning = false
        decreaseTimer?.invalidate()
        decreaseTimer = nil
    }

    // MARK: - Private Methods

    /// 피버 감소 (매 주기마다 호출)
    private func decreaseFever() {
        guard feverPercent > 0 else { return }
        if feverPercent - decreasePercentPerTick < 0 {
            feverPercent = 0
        } else {
            feverPercent -= decreasePercentPerTick
        }
    }

    /// 피버 단계 업데이트
    private func updateFeverStage() {
        let newStage: Int

        switch feverPercent {
        case 0..<100:
            newStage = 0  // 일반
        case 100..<200:
            newStage = 1  // 피버 1단계
        case 200..<300:
            newStage = 2  // 피버 2단계
        case 300...:
            newStage = 3  // 피버 3단계 (MAX)
        default:
            newStage = 0
        }

        if newStage != feverStage {
            feverStage = newStage
        }
    }
}

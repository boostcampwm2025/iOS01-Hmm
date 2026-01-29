//
//  SoundType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import Foundation

enum SoundType: String {
    // MARK: - 공통
    case success
    case failure
    /// 전체 버튼 클릭음 (딸깍, 짧)
    case buttonTap

    // MARK: - BGM
    /// 잔잔
    case bgm

    // MARK: - 언어 맞추기
    /// 맞았을 때 (쓰로틀 x)
    case languageCorrect
    /// 틀렸을 때 (쓰로틀 x)
    case languageWrong

    // MARK: - 버그 피하기
    /// 코인 먹는 소리
    case coinCollect
    /// 버그 맞는 소리 (연속음)
    case bugHit

    // MARK: - 데이터 쌓기
    /// 블록 쌓기: 툭
    case blockStack
    /// 블록 떨굼 (물리엔진에 맞게)
    case blockDrop
    /// 폭탄 쌓기: 펑
    case bombStack
    /// 폭탄 떨굼
    case bombDrop

    // MARK: - 퀴즈
    /// 끝나기 3초 전 째깍
    case countdownTick

    // MARK: - 아이템 소비
    /// 커피/박하스 클릭 시
    case itemConsume

    // MARK: - 장비 강화
    /// 강화 성공 (팝업 뜰 때)
    case upgradeSuccess
    /// 강화 실패 (팝업 뜰 때)
    case upgradeFailure

    // MARK: - 미션
    /// 미션 획득 시 짜잔
    case missionAcquired

    /// wav 우선, 없으면 mp3 로드 (AVAudioPlayer 모두 지원)
    var url: URL? {
        Bundle.main.url(forResource: rawValue, withExtension: "wav")
            ?? Bundle.main.url(forResource: rawValue, withExtension: "mp3")
    }
}

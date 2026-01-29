//
//  SoundType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import Foundation

enum SoundType: String {
    /// 전체 버튼 클릭음
    case buttonTap

    // MARK: - BGM
    case bgm

    // MARK: - 언어 맞추기
    /// 맞았을 때
    case languageCorrect
    /// 틀렸을 때
    case languageWrong

    // MARK: - 버그 피하기
    /// 코인 먹는 소리
    case coinCollect
    /// 버그 맞는 소리
    case bugHit

    // MARK: - 데이터 쌓기
    /// 블록 쌓기
    case blockStack
    /// 블록 떨굼
    case blockDrop
    /// 폭탄 쌓기
    case bombStack

    // MARK: - 퀴즈
    /// 끝나기 3초 전 째깍
    case countdownTick
    /// 퀴즈 시간 초과
    case quizTimeOver
    /// 퀴즈 정답
    case quizCorrect
    /// 퀴즈 오답
    case quizWrong

    // MARK: - 아이템 소비
    /// 커피/박하스 클릭 시
    case itemConsume

    // MARK: - 장비 강화
    /// 강화 성공 (팝업 뜰 때)
    case upgradeSuccess
    /// 강화 실패 (팝업 뜰 때)
    case upgradeFailure

    // MARK: - 미션
    /// 미션 획득 시
    case missionAcquired

    /// 탭게임 탭 시
    case tapGameTyping

    /// wav 우선, 없으면 mp3 로드
    var url: URL? {
        Bundle.main.url(forResource: rawValue, withExtension: "wav")
    }
}

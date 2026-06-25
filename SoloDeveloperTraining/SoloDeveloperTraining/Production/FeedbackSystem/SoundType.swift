//
//  SoundType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import Foundation

enum SoundType: String {
    /// 전체 버튼 클릭음
    case click

    // MARK: - BGM
    case main

    // MARK: - 언어 맞추기
    /// 맞았을 때
    case normal
    /// 틀렸을 때
    case error

    // MARK: - 퀴즈
    /// 맞았을 때
    case correct
    /// 틀렸을 때
    case wrong
    /// 끝나기 3초 전 째깍
    case count
    /// 퀴즈 시간 초과
    case over

    // MARK: - 버그 피하기
    /// 코인 먹는 소리
    case coin
    /// 버그 맞는 소리
    case hit

    // MARK: - 데이터 쌓기
    /// 블록 쌓기
    case stack
    /// 블록 떨굼
    case drop
    /// 폭탄 쌓기
    case pop

    // MARK: - 아이템 소비
    /// 커피/박하스 클릭 시
    case drink

    // MARK: - 장비 강화
    /// 강화 성공 (팝업 뜰 때)
    case success
    /// 강화 실패 (팝업 뜰 때)
    case failure

    // MARK: - 미션
    /// 미션 획득 시
    case mission

    /// 탭게임 탭 시
    case typing

    /// wav 우선, 없으면 mp3 로드
    var url: URL? {
        Bundle.main.url(forResource: rawValue, withExtension: "wav")
    }
}

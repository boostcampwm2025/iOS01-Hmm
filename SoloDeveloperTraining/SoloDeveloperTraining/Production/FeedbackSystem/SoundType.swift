//
//  SoundType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import Foundation

enum SoundType: String {
    // MARK: - 01. 배경음
    /// 스플래시, 튜토리얼
    case splash
    /// 메인/공통
    case main
    /// 시나리오 배경음
    case scenario
    /// 엔딩 카드 배경음
    case ending
    /// 환생 시나리오 배경음
    case rebirth

    // MARK: - 02. 레벨업
    case levelUp

    // MARK: - 03. 일반
    /// 버튼 클릭음
    case click

    // MARK: - 04. 업무 - 코드짜기
    case typing

    // MARK: - 04. 업무 - 언어 맞추기
    /// 정답일 때
    case normal
    /// 오답일 때
    case error

    // MARK: - 04. 업무 - 버그피하기
    /// 코인 수집 시
    case coin
    /// 버그에 맞을 때
    case hit

    // MARK: - 04. 업무 - 데이터 쌓기
    /// 블록을 올바르게 쌓을 때
    case stack
    /// 블록이 떨어질 때 (미스)
    case drop
    /// 폭탄 블록 쌓을 때
    case pop

    // MARK: - 04. 업무 - 공통
    /// 아이템(커피/박하스) 소비 시
    case drink

    // MARK: - 05. 상점 - 아이템
    /// 강화 성공
    case success
    /// 강화 실패
    case failure

    // MARK: - 06. 퀴즈
    /// 정답일 때
    case correct
    /// 오답일 때
    case wrong
    /// 종료 3초 전 카운트다운
    case count
    /// 시간 초과 시
    case over

    // MARK: - 07. 미션
    /// 미션 보상 수령 시
    case mission

    /// wav 우선, 없으면 mp3 로드
    var url: URL? {
        Bundle.main.url(forResource: rawValue, withExtension: "wav")
    }
}

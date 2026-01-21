//
//  MissionConstants.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/20/26.
//

import Foundation

/// 미션 관련 상수 정의
enum MissionConstants {
    // MARK: - 코드짜기 (탭)
    enum CodeTap {
        static let id1 = 1, id2 = 2, id3 = 3
        static let target1 = 1_000, target2 = 10_000, target3 = 100_000
        static let title1 = "손풀기", title2 = "근육맨", title3 = "신의 손가락"
        static let description1 = "탭 1,000회 달성"
        static let description2 = "탭 10,000회 달성"
        static let description3 = "탭 100,000회 달성"
        static let reward1 = Cost(gold: 1_000)
        static let reward2 = Cost(diamond: 10)
        static let reward3 = Cost(gold: 10_000, diamond: 20)
    }

    // MARK: - 언어맞추기 (맞춘 횟수)
    enum LanguageMatch {
        static let id1 = 4, id2 = 5, id3 = 6
        static let target1 = 500, target2 = 5_000, target3 = 50_000
        static let title1 = "초보 탐색가", title2 = "패턴 분석가", title3 = "미래 예측가"
        static let description1 = "정답 500회 달성"
        static let description2 = "정답 5,000회 달성"
        static let description3 = "정답 50,000회 달성"
        static let reward1 = Cost(diamond: 5)
        static let reward2 = Cost(gold: 5_000)
        static let reward3 = Cost(gold: 50_000, diamond: 30)
    }

    // MARK: - 버그피하기 (골드 획득)
    enum BugDodge {
        static let id1 = 7, id2 = 8, id3 = 9
        static let target1 = 300, target2 = 3_000, target3 = 30_000
        static let title1 = "황금 수집가", title2 = "골드 마스터", title3 = "골드 청소기"
        static let description1 = "골드 300회 획득"
        static let description2 = "골드 3,000회 획득"
        static let description3 = "골드 30,000회 획득"
        static let reward1 = Cost(gold: 2_000)
        static let reward2 = Cost(diamond: 15)
        static let reward3 = Cost(gold: 20_000, diamond: 25)
    }

    // MARK: - 물건쌓기
    enum StackItem {
        static let id1 = 10, id2 = 11, id3 = 12
        static let target1 = 100, target2 = 1_000, target3 = 10_000
        static let title1 = "데이터 수집가", title2 = "데이터 전문가", title3 = "데이터 마스터"
        static let description1 = "물건 100회 쌓기"
        static let description2 = "물건 1,000회 쌓기"
        static let description3 = "물건 10,000회 쌓기"
        static let reward1 = Cost(diamond: 8)
        static let reward2 = Cost(gold: 8_000)
        static let reward3 = Cost(gold: 80_000, diamond: 40)
    }

    // MARK: - 플레이타임
    enum PlayTime {
        static let id1 = 13, id2 = 14, id3 = 15
        static let targetHours1 = 1, targetHours2 = 10, targetHours3 = 100
        static let title1 = "판교의 등대", title2 = "야근 적응자", title3 = "서버의 등대"
        static let description1 = "총 플레이 시간 1시간"
        static let description2 = "총 플레이 시간 10시간"
        static let description3 = "총 플레이 시간 100시간"
        static let reward1 = Cost(gold: 500)
        static let reward2 = Cost(diamond: 12)
        static let reward3 = Cost(gold: 100_000, diamond: 50)
    }

    // MARK: - 커피
    enum Coffee {
        static let id1 = 16, id2 = 17, id3 = 18
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "커피 중독자", title2 = "커피 전문가", title3 = "커피 학살자"
        static let description1 = "커피 10회 사용"
        static let description2 = "커피 100회 사용"
        static let description3 = "커피 1,000회 사용"
        static let reward1 = Cost(gold: 1_500)
        static let reward2 = Cost(diamond: 10)
        static let reward3 = Cost(gold: 15_000, diamond: 18)
    }

    // MARK: - 박하스
    enum EnergyDrink {
        static let id1 = 19, id2 = 20, id3 = 21
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "박하스 중독자", title2 = "박하스 전문가", title3 = "박하스 학살자"
        static let description1 = "박하스 10회 사용"
        static let description2 = "박하스 100회 사용"
        static let description3 = "박하스 1,000회 사용"
        static let reward1 = Cost(diamond: 7)
        static let reward2 = Cost(gold: 7_000)
        static let reward3 = Cost(gold: 70_000, diamond: 35)
    }

    // MARK: - 언어맞추기 (연속 성공)
    enum LanguageConsecutive {
        static let id1 = 22, id2 = 23, id3 = 24
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "다중 언어 초급", title2 = "다중 언어 중급", title3 = "다중 언어 고급"
        static let description1 = "연속 정답 10회"
        static let description2 = "연속 정답 100회"
        static let description3 = "연속 정답 1,000회"
        static let reward1 = Cost(gold: 3_000)
        static let reward2 = Cost(diamond: 20)
        static let reward3 = Cost(gold: 30_000, diamond: 40)
    }

    // MARK: - 버그피하기 (연속 성공)
    enum BugDodgeConsecutive {
        static let id1 = 25, id2 = 26, id3 = 27
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "기초적 안정성", title2 = "검증된 안정성", title3 = "완벽한 안정성"
        static let description1 = "연속 성공 10회"
        static let description2 = "연속 성공 100회"
        static let description3 = "연속 성공 1,000회"
        static let reward1 = Cost(diamond: 12)
        static let reward2 = Cost(gold: 12_000)
        static let reward3 = Cost(gold: 120_000, diamond: 60)
    }

    // MARK: - 데이터 쌓기 (연속 성공)
    enum StackConsecutive {
        static let id1 = 28, id2 = 29, id3 = 30
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "KB 업로더", title2 = "MB 업로더", title3 = "GB 업로더"
        static let description1 = "연속 성공 10회"
        static let description2 = "연속 성공 100회"
        static let description3 = "연속 성공 1,000회"
        static let reward1 = Cost(gold: 4_000)
        static let reward2 = Cost(diamond: 18)
        static let reward3 = Cost(gold: 40_000, diamond: 45)
    }

    // MARK: - 커리어
    enum Career {
        static let id = 31
        static let title = "나는야 개발자"
        static let description = "하찮은 개발자 달성"
        static let reward = Cost(gold: 50_000, diamond: 100)
    }

    // MARK: - 튜토리얼
    enum Tutorial {
        static let id = 32
        static let title = "주니어 개발자"
        static let description = "튜토리얼 완료"
        static let reward = Cost(gold: 10_000, diamond: 10)
    }
}

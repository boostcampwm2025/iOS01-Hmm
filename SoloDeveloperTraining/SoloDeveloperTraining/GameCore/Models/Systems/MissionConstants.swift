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
        static let title1 = "초보의 손가락", title2 = "장인의 손가락", title3 = "신의 손가락"
        static let description1 = "코드짜기 탭\n1,000회"
        static let description2 = "코드짜기 탭\n10,000회"
        static let description3 = "코드짜기 탭\n100,000회"
        static let reward1 = Cost(gold: 5_000)
        static let reward2 = Cost(diamond: 10)
        static let reward3 = Cost(gold: 50_000, diamond: 20)
    }

    // MARK: - 언어맞추기 (맞춘 횟수)
    enum LanguageMatch {
        static let id1 = 4, id2 = 5, id3 = 6
        static let target1 = 500, target2 = 5_000, target3 = 50_000
        static let title1 = "초보 탐색가", title2 = "패턴 분석가", title3 = "미래 예측가"
        static let description1 = "언어 맞추기 정답\n500회"
        static let description2 = "언어 맞추기 정답\n5,000회"
        static let description3 = "언어 맞추기 정답\n50,000회"
        static let reward1 = Cost(diamond: 5)
        static let reward2 = Cost(gold: 225_000)
        static let reward3 = Cost(gold: 2_250_000, diamond: 30)
    }

    // MARK: - 버그피하기 (골드 획득)
    enum BugDodge {
        static let id1 = 7, id2 = 8, id3 = 9
        static let target1 = 300, target2 = 3_000, target3 = 30_000
        static let title1 = "황금 수집가", title2 = "골드 마스터", title3 = "골드 청소기"
        static let description1 = "버그 피하기 골드\n300개 획득"
        static let description2 = "버그 피하기 골드\n3,000개 획득"
        static let description3 = "버그 피하기 골드\n30,000개 획득"
        static let reward1 = Cost(gold: 174_000_000)
        static let reward2 = Cost(diamond: 15)
        static let reward3 = Cost(gold: 1_740_000_000, diamond: 25)
    }

    // MARK: - 데이터쌓기
    enum StackItem {
        static let id1 = 10, id2 = 11, id3 = 12
        static let target1 = 100, target2 = 1_000, target3 = 10_000
        static let title1 = "데이터 수집가", title2 = "데이터 전문가", title3 = "데이터 마스터"
        static let description1 = "데이터 쌓기 성공\n100회"
        static let description2 = "데이터 쌓기 성공\n1,000회"
        static let description3 = "데이터 쌓기 성공\n10,000회"
        static let reward1 = Cost(diamond: 8)
        static let reward2 = Cost(gold: 18_000_000_000)
        static let reward3 = Cost(gold: 180_000_000_000, diamond: 40)
    }

    // MARK: - 플레이타임
    enum PlayTime {
        static let id1 = 13, id2 = 14, id3 = 15
        static let targetHours1 = 1, targetHours2 = 10, targetHours3 = 100
        static let title1 = "판교의 등대", title2 = "야근 적응자", title3 = "서버의 등대"
        static let description1 = "총 플레이 시간\n1시간"
        static let description2 = "총 플레이 시간\n10시간"
        static let description3 = "총 플레이 시간\n100시간"
        static let reward1 = Cost(diamond: 50)
        static let reward2 = Cost(diamond: 120)
        static let reward3 = Cost(diamond: 500)
    }

    // MARK: - 커피
    enum Coffee {
        static let id1 = 16, id2 = 17, id3 = 18
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "커피 중독자", title2 = "커피 전문가", title3 = "커피 학살자"
        static let description1 = "커피 사용\n10회"
        static let description2 = "커피 사용\n100회"
        static let description3 = "커피 사용\n1,000회"
        static let reward1 = Cost(gold: 5_000)
        static let reward2 = Cost(diamond: 10)
        static let reward3 = Cost(gold: 50_000, diamond: 18)
    }

    // MARK: - 바카스
    enum EnergyDrink {
        static let id1 = 19, id2 = 20, id3 = 21
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "바카스 중독자", title2 = "바카스 전문가", title3 = "바카스 학살자"
        static let description1 = "바카스 사용\n10회"
        static let description2 = "바카스 사용\n100회"
        static let description3 = "바카스 사용\n1,000회"
        static let reward1 = Cost(diamond: 7)
        static let reward2 = Cost(gold: 225_000)
        static let reward3 = Cost(gold: 2_250_000, diamond: 35)
    }

    // MARK: - 언어맞추기 (연속 성공)
    enum LanguageConsecutive {
        static let id1 = 22, id2 = 23, id3 = 24
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "다중 언어 초급", title2 = "다중 언어 중급", title3 = "다중 언어 고급"
        static let description1 = "언어 맞추기 정답\n연속 10회"
        static let description2 = "언어 맞추기 정답\n연속 100회"
        static let description3 = "언어 맞추기 정답\n연속 1,000회"
        static let reward1 = Cost(gold: 135_000)
        static let reward2 = Cost(diamond: 20)
        static let reward3 = Cost(gold: 1_350_000, diamond: 40)
    }

    // MARK: - 버그피하기 (연속 성공)
    enum BugDodgeConsecutive {
        static let id1 = 25, id2 = 26, id3 = 27
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "기초적 안정성", title2 = "검증된 안정성", title3 = "완벽한 안정성"
        static let description1 = "버그 피하기 성공\n연속 10회"
        static let description2 = "버그 피하기 성공\n연속 100회"
        static let description3 = "버그 피하기 성공\n연속 1,000회"
        static let reward1 = Cost(diamond: 12)
        static let reward2 = Cost(gold: 1_044_000_000)
        static let reward3 = Cost(gold: 10_440_000_000, diamond: 60)
    }

    // MARK: - 데이터 쌓기 (연속 성공)
    enum StackConsecutive {
        static let id1 = 28, id2 = 29, id3 = 30
        static let target1 = 10, target2 = 100, target3 = 1_000
        static let title1 = "KB 업로더", title2 = "MB 업로더", title3 = "GB 업로더"
        static let description1 = "데이터 쌓기 성공\n연속 10회"
        static let description2 = "데이터 쌓기 성공\n연속 100회"
        static let description3 = "데이터 쌓기 성공\n연속 1,000회"
        static let reward1 = Cost(gold: 9_000_000_000)
        static let reward2 = Cost(diamond: 18)
        static let reward3 = Cost(gold: 90_000_000_000, diamond: 45)
    }

    // MARK: - 커리어
    enum Career {
        static let id = 31
        static let title = "나는야 개발자"
        static let description = "레벨 달성\n하찮은 개발자"
        static let reward = Cost(gold: 2_500_000, diamond: 100)
    }

    // MARK: - 튜토리얼
    enum Tutorial {
        static let id = 32
        static let title = "주니어 개발자"
        static let description = "튜토리얼\n완료"
        static let reward = Cost(gold: 50_000, diamond: 10)
    }
}

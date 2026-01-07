//
//  Career.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum Career: String, CaseIterable {
    case unemployed = "백수"
    case laptopOwner = "노트북 보유자"
    case aspiringDeveloper = "개발자 지망생"
    case juniorDeveloper = "하찮은 개발자"
    case normalDeveloper = "아무튼 개발자"
    case nightOwlDeveloper = "밤 새는 개발자"
    case skilledDeveloper = "유능한 개발자"
    case famousDeveloper = "유명한 개발자"
    case allRounderDeveloper = "올라운더 개발자"
    case worldClassDeveloper = "월드클래스 개발자"
    
    var description: String {
        switch self {
        case .unemployed:
            return "아직 아무것도 시작하지 않았지만, 시간은 가장 많다"
        case .laptopOwner:
            return "별다방 입장권 획득"
        case .aspiringDeveloper:
            return "헬로 월드(Hello World) 장인"
        case .juniorDeveloper:
            return "에러는 많고 자신감은 적다"
        case .normalDeveloper:
            return "이유는 몰라도 코드는 돌아간다"
        case .nightOwlDeveloper:
            return "해 뜨는게 퇴근 신호"
        case .skilledDeveloper:
            return "복붙의 신"
        case .famousDeveloper:
            return "개발자들의 연예인"
        case .allRounderDeveloper:
            return "맡다 보니 전부 다 하게 됐다"
        case .worldClassDeveloper:
            return "0과 1로 대화 가능"
        }
    }
    
    /// 다음 단계로 업그레이드하기 위해 필요한 누적 재산
    var requiredWealth: Int {
        switch self {
        case .unemployed:
            return 0
        case .laptopOwner:
            return 1_000
        case .aspiringDeveloper:
            return 1_500
        case .juniorDeveloper:
            return 10_000
        case .normalDeveloper:
            return 50_000
        case .nightOwlDeveloper:
            return 200_000
        case .skilledDeveloper:
            return 1_000_000
        case .famousDeveloper:
            return 5_000_000
        case .allRounderDeveloper:
            return 20_000_000
        case .worldClassDeveloper:
            return 100_000_000
        }
    }
    
    /// 다음 Career 단계
    var nextCareer: Career? {
        guard let currentIndex = Career.allCases.firstIndex(of: self),
              currentIndex < Career.allCases.count - 1 else {
            return nil
        }
        return Career.allCases[currentIndex + 1]
    }
    
    /// 현재 누적재산으로 업그레이드 가능한지 확인
    func canUpgrade(currentWealth: Int) -> Bool {
        guard let next = nextCareer else { return false }
        return currentWealth >= next.requiredWealth
    }
}

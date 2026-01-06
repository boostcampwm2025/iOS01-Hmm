//
//  Career.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum Career: Int, CaseIterable {
    case unemployed = 0
    case laptopOwner = 1_000
    case aspiringDev = 1_500
    case juniorDev = 10_000
    case normalDev = 50_000
    case nightOwlDev = 200_000
    case skilledDev = 1_000_000
    case famousDev = 5_000_000
    case allRounderDev = 20_000_000
    case worldClassDev = 100_000_000
    
    var displayTitle: String {
        switch self {
        case .unemployed: return "백수"
        case .laptopOwner: return "노트북 보유자"
        case .aspiringDev: return "개발자 지망생"
        case .juniorDev: return "하찮은 개발자"
        case .normalDev: return "아무튼 개발자"
        case .nightOwlDev: return "밤 새는 개발자"
        case .skilledDev: return "유능한 개발자"
        case .famousDev: return "유명한 개발자"
        case .allRounderDev: return "올라운더 개발자"
        case .worldClassDev: return "월드클래스 개발자"
        }
    }
    
    /// 필요 누적 재산 (rawValue가 바로 필요 재산)
    var requiredMoney: Int {
        return self.rawValue
    }
    
    /// 현재 누적 재산으로 커리어 판단
    static func from(totalEarned: Int) -> Career {
        return Career.allCases.reversed().first { career in
            totalEarned >= career.rawValue
        } ?? .unemployed
    }
    
    /// 다음 커리어
    var next: Career? {
        guard let currentIndex = Career.allCases.firstIndex(of: self),
              currentIndex < Career.allCases.count - 1 else {
            return nil
        }
        return Career.allCases[currentIndex + 1]
    }
    
    /// 다음 커리어까지 필요한 재산
    func moneyToNext(currentTotal: Int) -> Int? {
        guard let nextCareer = self.next else { return nil }
        return max(0, nextCareer.requiredMoney - currentTotal)
    }
}

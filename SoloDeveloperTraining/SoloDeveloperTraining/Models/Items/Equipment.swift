//
//  Equipment.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 장비 아이템 클래스
final class Equipment {
    /// 장비 타입
    var type: EquipmentType
    /// 장비 등급
    var tier: EquipmentTier

    /// 화면에 표시될 제목
    var displayTitle: String {
        return tier.displayTitle + " " + type.displayTitle
    }
    
    /// 업그레이드 가능 여부
    var canUpgrade: Bool {
        return tier != .nationalTreasure
    }
    
    /// 초 당 획득 골드
    var goldPerSecond: Double {
        switch type {
        case .keyboard:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        case .mouse:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        case .monitor:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        case .chair:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        }
    }
    
    
    /// 업그레이드 비용
    var upgradeCost: Cost {
        switch tier {
        case .broken:
            return Cost(gold: 50_000)
        case .cheap:
            return Cost(gold: 100_000)
        case .vintage:
            return Cost(gold: 200_000)
        case .decent:
            return Cost(gold: 500_000)
        case .premium:
            return Cost(gold: 1_000_000)
        case .diamond:
            return Cost(gold: 2_000_000)
        case .limited:
            return Cost(gold: 5_000_000)
        case .nationalTreasure:
            return Cost(gold: 999_999_999_999)
        }
    }
    
    /// 업그레이드 성공 확률 (0.0 ~ 1.0)
    var upgradeSuccessRate: Double {
        switch tier {
        case .broken:
            return 1.0
        case .cheap:
            return 0.8
        case .vintage:
            return 0.6
        case .decent:
            return 0.4
        case .premium:
            return 0.3
        case .diamond:
            return 0.2
        case .limited:
            return 0.1
        case .nationalTreasure:
            return 0.0
        }
    }

    /// 장비 초기화
    init(type: EquipmentType, tier: EquipmentTier) {
        self.type = type
        self.tier = tier
    }

    /// 강화 확률에 따라 업그레이드
    func upgraded() {
        guard canUpgrade else { return }
        
        let randomValue = Double.random(in: 0...1)
        
        if randomValue <= upgradeSuccessRate {
            self.tier = EquipmentTier(rawValue: tier.rawValue + 1) ?? .nationalTreasure
        }
    }
}

/// 장비 종류
enum EquipmentType {
    /// 키보드
    case keyboard
    /// 마우스
    case mouse
    /// 모니터
    case monitor
    /// 의자
    case chair

    /// 화면에 표시될 제목
    var displayTitle: String {
        switch self {
        case .keyboard:
            return "키보드"
        case .mouse:
            return "마우스"
        case .monitor:
            return "모니터"
        case .chair:
            return "의자"
        }
    }
}

/// 장비 등급
enum EquipmentTier: Int {
    /// 고장난
    case broken = 0
    /// 싸구려
    case cheap = 1
    /// 빈티지
    case vintage = 2
    /// 쓸만한
    case decent = 3
    /// 고급
    case premium = 4
    /// 다이아
    case diamond = 5
    /// 한정판
    case limited = 6
    /// 국보급
    case nationalTreasure = 7

    /// 화면에 표시될 제목
    var displayTitle: String {
        switch self {
        case .broken: "고장난"
        case .cheap: "싸구려"
        case .vintage: "빈티지"
        case .decent: "쓸만한"
        case .premium: "고오급"
        case .diamond: "다이아"
        case .limited: "한정판"
        case .nationalTreasure: "국보급"
        }
    }
}

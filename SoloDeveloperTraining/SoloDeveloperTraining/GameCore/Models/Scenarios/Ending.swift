//
//  Ending.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/1/26.
//

/// 최종 엔딩 종류
enum EndingType: String, Codable, CaseIterable {
    case aceDeveloper
    case startupCEO
    case techInfluencer
    case geniusHacker
    case digitalNomad
    case darkWebAgent

    var title: String {
        switch self {
        case .aceDeveloper: return "유니콘 에이스"
        case .startupCEO: return "Series A 대표"
        case .techInfluencer: return "개발 유튜버"
        case .geniusHacker: return "전설의 해커"
        case .digitalNomad: return "글로벌 워커"
        case .darkWebAgent: return "다크웹 블랙 요원"
        }
    }

    var career: String {
        switch self {
        case .aceDeveloper: return "에이스 개발자"
        case .startupCEO: return "스타트업 대표"
        case .techInfluencer: return "테크 인플루언서"
        case .geniusHacker: return "천재 해커"
        case .digitalNomad: return "디지털 노마드"
        case .darkWebAgent: return "다크웹 요원"
        }
    }

    var description: String {
        switch self {
        case .aceDeveloper: return "연봉 100억. 스톡옵션. 야근도 행복하다."
        case .startupCEO: return "엑싯이 목표! 인생은 한방이다."
        case .techInfluencer: return "유튜브 구독자 100만. 강의 매출 연 10억."
        case .geniusHacker: return "이름 없이, 흔적 없이. 그러나 전설로 남다."
        case .digitalNomad: return "전 세계 해변이 나의 사무실, 코드와 자유뿐."
        case .darkWebAgent: return "내 기록은 삭제됐다. 이 게임도 기억하지 마라"
        }
    }

    var kakaoMessageTemplateID: String {
        switch self {
        case .aceDeveloper: return "133206"
        case .startupCEO: return "133205"
        case .techInfluencer: return "133204"
        case .geniusHacker: return "133208"
        case .digitalNomad: return "133207"
        case .darkWebAgent: return "133203"
        }
    }

    var webThumbnailImageName: String {
        switch self {
        case .aceDeveloper: return "ace_developer"
        case .startupCEO: return "startup_ceo"
        case .techInfluencer: return "tech_influencer"
        case .geniusHacker: return "genius_hacker"
        case .digitalNomad: return "digital_nomad"
        case .darkWebAgent: return "darkweb_agent"
        }
    }
}

/// 최종 엔딩 정보
struct Ending: Codable, Hashable {
    let id: String
    let type: EndingType

    var kakaoMessageTemplateID: String { type.kakaoMessageTemplateID }

    init(id: String, type: EndingType) {
        self.id = id
        self.type = type
    }
}

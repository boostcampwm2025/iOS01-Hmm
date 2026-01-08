//
//  Housing.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//


enum Housing {
    case street
    case semiBasement
    case rooftop
    case villa
    case apartment
    case house
    case pentHouse

    var imageName: String {
        switch self {
        case .street: return "background_street"
        case .semiBasement: return "background_semiBasement"
        case .rooftop: return "background_rooftop"
        case .villa: return "background_villa"
        case .apartment: return "background_apartment"
        case .house: return "background_house"
        case .pentHouse: return "background_pentHouse"
        }
    }
}

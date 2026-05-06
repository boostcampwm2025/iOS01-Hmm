//
//  AdUnit.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//

import UIKit
import GoogleMobileAds

protocol AdUnit {
    var adUnitID: String { get }
    var isReady: Bool { get }
    func load() async throws
    func show()
}

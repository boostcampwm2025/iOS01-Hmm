//
//  AdUnit.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//

protocol AdUnit {
    var isReady: Bool { get }
    @MainActor func load() async throws
    @MainActor func show()
}

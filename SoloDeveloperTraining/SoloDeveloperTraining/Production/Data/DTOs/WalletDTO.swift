//
//  WalletDTO.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-26.
//

import Foundation

struct WalletDTO: Codable {
    let gold: Int
    let diamond: Int

    init(from wallet: Wallet) {
        self.gold = wallet.gold
        self.diamond = wallet.diamond
    }

    func toWallet() -> Wallet {
        Wallet(gold: gold, diamond: diamond)
    }
}

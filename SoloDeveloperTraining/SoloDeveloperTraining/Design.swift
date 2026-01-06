//
//  Design.swift
//  1412412323
//
//  Created by 최범수 on 2026-01-06.
//

import Foundation

actor User {
    let id: UUID
    let nickname: String
    let career: Career
    let wallet: Wallet
    let inventory: Inventory
    let record: Record
    let achievements: [Achievement]
    let skills: [Skill]

    init(id: UUID = UUID(), nickname: String, career: Career, wallet: Wallet, inventory: Inventory, record: Record, achievements: [Achievement] = [], skills: [Skill] = []) {
        self.id = id
        self.nickname = nickname
        self.career = career
        self.wallet = wallet
        self.inventory = inventory
        self.record = record
        self.achievements = achievements
        self.skills = skills
    }
}

actor Wallet {
    private(set) var gold: Int
    private(set) var diamond: Int

    init(gold: Int = 0, diamond: Int = 0) {
        self.gold = gold
        self.diamond = diamond
    }

    func addGold(_ amount: Int) {
        guard amount > 0 else { return }
        gold += amount
    }
}

actor Inventory {
    let equipment: [Equipment]
    let consumable: [Consumable]
    let housing: Housing

    init(equipment: [Equipment] = [], consumable: [Consumable] = [], housing: Housing) {
        self.equipment = equipment
        self.consumable = consumable
        self.housing = housing
    }
}

class TapGame {
    let user: User
    let calculator: Calculator
    let feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {}
    func endGame() {}

    private func actionDidOccur() async {
        let goldGained = calculator.calculateGoldGained()
        await user.wallet.addGold(goldGained)
    }
}

class LanguageGame {
    let user: User
    let calculator: Calculator
    let feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {}
    func endGame() {}

    func actionDidOccur() { }
}

class DodgeGame {
    let user: User
    let calculator: Calculator
    let feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {}
    func endGame() {}

    func actionDidOccur() { }
}

class StackGame {
    let user: User
    let calculator: Calculator
    let feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {}
    func endGame() {}

    func actionDidOccur() { }
}

class Shop {
    func upgrade(skill: Skill, wallet: Wallet) {}
    func upgrade(equipment: Equipment, wallet: Wallet) -> Bool { return false }
    func buyConsumable(item: Consumable, wallet: Wallet, inventory: Inventory) {}
    func buyHousing(item: Housing, wallet: Wallet, inventory: Inventory) {}
}

class QuizGame {
    let user: User
    let quizs: [Quiz]

    init(user: User, quizs: [Quiz]) {
        self.user = user
        self.quizs = quizs
    }

    func startGame() {}
    func selectAnswer(quiz: Quiz, answerIndex: Int) -> Bool { return false }
}

class AchievementSystem {
    let allAchievements: [Achievement]

    init(allAchievements: [Achievement]) {
        self.allAchievements = allAchievements
    }

    func claimAchievement(record: Record, achievement: Achievement) {
    }
}

class CarriorSystem {

}

class Record {}
class Career {}
class Achievement {}
class Skill {}
class Equipment {}
class Consumable {}
class Housing {}
class Calculator {
    func calculateGoldGained() -> Int { 1 }
}
class FeverSystem {}
class Achievements {}
class Quiz {}


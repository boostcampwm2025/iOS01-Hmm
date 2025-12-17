//
//  Models.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

struct TapWorkSystem {
    let user: User
    let feverSystem: FeverSystem = .init()
    
    func tap() {
        Task {
            let moneyPer = await calculateMoneyPer()
            await user.wallet.money.earn(moneyPer)
        }
    }
    
    func calculateMoneyPer() async -> Double {
//        await user.skillSet.currentSkillLevels["웹 개발 초급"]
        return 1
    }
}


struct FeverSystem {
    
}

//struct Policy {
//    let skillPolicy: [String : Int] = [
//        "웹 개발 초급"
//    ]
//}

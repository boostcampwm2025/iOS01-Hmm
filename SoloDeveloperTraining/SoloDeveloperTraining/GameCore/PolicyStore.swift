//
//  PolicyStore.swift
//  SoloDeveloperTraining
//

import Foundation
@preconcurrency import FirebaseFirestore

enum PolicyStoreError: LocalizedError {
    case noActiveVersion(environment: String)

    var errorDescription: String? {
        switch self {
        case .noActiveVersion(let env):
            return "'\(env)' 환경에 배포된 정책 버전이 없습니다. 관리자 앱에서 배포해 주세요."
        }
    }
}

protocol PolicyStoreProtocol: AnyObject {
    var current: PolicyDTO { get }
    func initialize() async throws
}

var policyStore: any PolicyStoreProtocol = PolicyStore()

final class PolicyStore: PolicyStoreProtocol {
    var current: PolicyDTO = .defaultValues

    init() {}

    /// 환경에 맞는 정책을 Firestore에서 로드합니다. 실패 시 throw합니다.
    func initialize() async throws {
        let env = resolveEnvironment()
        let store = Firestore.firestore()

        let envDoc = try await store.collection(env).document("current").getDocument()
        guard let version = envDoc.data()?["version"] as? Int else {
            throw PolicyStoreError.noActiveVersion(environment: env)
        }

        let dataRef = store.collection("versions").document("v\(version)").collection("Data")
        async let career     = dataRef.document("career").getDocument(as: CareerPolicyDTO.self)
        async let fever      = dataRef.document("fever").getDocument(as: FeverPolicyDTO.self)
        async let game       = dataRef.document("game").getDocument(as: GamePolicyDTO.self)
        async let skill      = dataRef.document("skill").getDocument(as: SkillPolicyDTO.self)
        async let consumable = dataRef.document("consumable").getDocument(as: ConsumablePolicyDTO.self)
        async let equipment  = dataRef.document("equipment").getDocument(as: EquipmentPolicyDTO.self)
        async let housing    = dataRef.document("housing").getDocument(as: HousingPolicyDTO.self)
        async let system     = dataRef.document("system").getDocument(as: SystemPolicyDTO.self)

        current = try await PolicyDTO(
            version: "v\(version)",
            career: career, fever: fever, game: game, skill: skill,
            consumable: consumable, equipment: equipment, housing: housing, system: system
        )
    }

    private func resolveEnvironment() -> String {
        #if DEV_BUILD
        return "test"
        #else
        let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        return isTestFlight ? "test" : "live"
        #endif
    }
}

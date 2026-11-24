// 실행하려면 xcodebuild 환경 변수에 TEST_RUNNER_RUN_POLICY_BENCHMARK=1을 설정한다.
import Foundation
import Testing
@preconcurrency import FirebaseFirestore
@testable import SoloDeveloperTraining

@MainActor
struct PolicyFetchBenchmarkTests {
    private typealias Read = @MainActor () async throws -> Void

    @Test(.enabled(if: ProcessInfo.processInfo.environment["RUN_POLICY_BENCHMARK"] == "1"))
    func 정책_문서의_순차_조회와_동시_조회_시간을_비교한다() async throws {
        let store = Firestore.firestore()
        let active = try await store.document("test/current").getDocument(source: .server)
        let version = try #require(active.data()?["version"] as? Int)
        let collection = store.collection("versions/v\(version)/Data")
        for source in [FirestoreSource.server, .cache] {
            let reads = makeReads(in: collection, source: source)
            let label = source == .server ? "server" : "cache"
            // 서버 조회로 연결을 예열하고 캐시를 채운다. 캐시 조건에서는 측정 전에 8개 문서를 모두 읽을 수 있는지 확인한다.
            try await fetch(reads, concurrently: false)
            for pair in 1...30 {
                let concurrentFirst = pair.isMultiple(of: 2)
                for concurrent in [concurrentFirst, !concurrentFirst] {
                    let mode = concurrent ? "concurrent" : "sequential"
                    let sample = "POLICY v=\(version) source=\(label) pair=\(pair) mode=\(mode)"
                    let clock = ContinuousClock()
                    let start = clock.now
                    do {
                        try await fetch(reads, concurrently: concurrent)
                        let elapsed = start.duration(to: clock.now).components
                        let milliseconds = Double(elapsed.seconds) * 1000 + Double(elapsed.attoseconds) / 1e15
                        print("\(sample) ms=\(milliseconds)")
                    } catch {
                        print("\(sample) failed=\(error.localizedDescription)")
                        Issue.record("\(sample) failed: \(error)")
                    }
                }
            }
        }
    }

    private func makeReads(in data: CollectionReference, source: FirestoreSource) -> [Read] {
        func read<T: Decodable>(_ name: String, as type: T.Type) -> Read {
            { _ = try await data.document(name).getDocument(as: type, source: source) }
        }
        return [
            read("career", as: CareerPolicyDTO.self), read("fever", as: FeverPolicyDTO.self),
            read("game", as: GamePolicyDTO.self), read("skill", as: SkillPolicyDTO.self),
            read("consumable", as: ConsumablePolicyDTO.self), read("equipment", as: EquipmentPolicyDTO.self),
            read("housing", as: HousingPolicyDTO.self), read("system", as: SystemPolicyDTO.self)
        ]
    }

    private func fetch(_ reads: [Read], concurrently: Bool) async throws {
        guard concurrently else {
            for read in reads {
                try await read()
            }
            return
        }
        async let career: Void = reads[0]()
        async let fever: Void = reads[1]()
        async let game: Void = reads[2]()
        async let skill: Void = reads[3]()
        async let consumable: Void = reads[4]()
        async let equipment: Void = reads[5]()
        async let housing: Void = reads[6]()
        async let system: Void = reads[7]()
        _ = try await (career, fever, game, skill, consumable, equipment, housing, system)
    }
}

//
//  ScenarioRepository.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

/// 시나리오 데이터 저장소 프로토콜
protocol ScenarioRepository {
    /// 특정 커리어의 시나리오 가져오기
    func fetchScenario(for career: Career) async throws -> Scenario?

    /// 모든 시나리오 목록 가져오기
    func fetchAllScenario() async throws -> [Scenario]

    /// 선택 조합으로 최종 엔딩 계산
    func calculateEnding(
        evt01: ChoiceResult,
        evt02: ChoiceResult,
        evt03: ChoiceResult,
        evt04: ChoiceResult
    ) -> Ending
}

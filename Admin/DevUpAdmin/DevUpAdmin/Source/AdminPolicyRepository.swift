import Foundation

protocol AdminPolicyRepository {
    /// versions 컬렉션에서 가장 최신 버전을 가져옵니다.
    func fetchLatestVersion() async throws -> (meta: PolicyVersionMeta, policy: PolicyDTO, formulas: [String: String])?

    /// versions 컬렉션의 모든 버전 목록을 가져옵니다 (배포 상태 포함).
    func fetchVersionList() async throws -> [PolicyVersionMeta]

    /// 특정 버전의 정책 데이터와 수식 맵을 가져옵니다.
    func fetchVersion(_ version: Int) async throws -> (policy: PolicyDTO, formulas: [String: String])

    /// 새 버전으로 저장하고 새 버전 번호를 반환합니다.
    func saveVersion(fields: [PolicyField], modifiedBy: String, baseVersion: Int?, changes: [FieldChangeRecord]) async throws -> Int

    /// test/live 에 현재 배포 중인 버전 번호를 가져옵니다.
    func fetchDeployedVersionNumbers() async throws -> (test: Int?, live: Int?)

    /// 특정 버전을 test 또는 live 환경에 배포하고 배포 기록을 남깁니다.
    func deploy(version: Int, to env: PolicyEnvironment, deployedBy: String) async throws

    // MARK: - 편집 락

    /// 편집 락 획득을 시도합니다. 성공하면 true, 다른 세션이 락을 보유 중이면 false를 반환합니다.
    func acquireLock(username: String, sessionId: String) async throws -> Bool

    /// 락을 해제합니다. 본인 세션 ID가 일치할 때만 삭제합니다.
    func releaseLock(sessionId: String) async throws

    /// 락의 lastHeartbeat를 현재 시각으로 갱신합니다.
    func heartbeat(sessionId: String) async throws

    /// 현재 유효한 락 정보를 반환합니다. 만료(60초 초과)된 경우 nil을 반환합니다.
    func fetchLock() async throws -> (lockedBy: String, sessionId: String)?
}

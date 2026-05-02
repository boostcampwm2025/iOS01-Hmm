import Foundation

protocol AdminPolicyRepository {
    /// 특정 환경의 최신(latest) 정책과 버전 메타를 가져옵니다.
    func fetchLatest(env: PolicyEnvironment) async throws -> (meta: PolicyVersionMeta, policy: PolicyDTO)?

    /// 특정 환경의 모든 버전 목록을 가져옵니다.
    func fetchVersionList(env: PolicyEnvironment) async throws -> [PolicyVersionMeta]

    /// 특정 버전의 정책을 가져옵니다.
    func fetchPolicy(env: PolicyEnvironment, version: Int) async throws -> PolicyDTO

    /// 정책을 저장합니다. 새 버전 문서 생성 + latest 동시 갱신.
    func savePolicy(env: PolicyEnvironment, policy: PolicyDTO, modifiedBy: String) async throws
}

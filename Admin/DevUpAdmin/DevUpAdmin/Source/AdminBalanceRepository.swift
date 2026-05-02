import Foundation

protocol AdminPolicyRepository {
    /// versions 컬렉션에서 가장 최신 버전을 가져옵니다.
    func fetchLatestVersion() async throws -> (meta: PolicyVersionMeta, policy: PolicyDTO)?

    /// versions 컬렉션의 모든 버전 목록을 가져옵니다 (배포 상태 포함).
    func fetchVersionList() async throws -> [PolicyVersionMeta]

    /// 특정 버전의 정책 데이터를 가져옵니다.
    func fetchVersion(_ version: Int) async throws -> PolicyDTO

    /// 새 버전으로 저장하고 새 버전 번호를 반환합니다.
    func saveVersion(policy: PolicyDTO, modifiedBy: String) async throws -> Int

    /// test/live 에 현재 배포 중인 버전 번호를 가져옵니다.
    func fetchDeployedVersionNumbers() async throws -> (test: Int?, live: Int?)

    /// 특정 버전을 test 또는 live 환경에 배포합니다.
    func deploy(version: Int, to env: PolicyEnvironment) async throws
}

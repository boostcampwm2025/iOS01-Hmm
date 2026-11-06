import Foundation

/// 로컬 지갑에 반영한 초대 보상의 ID를 저장해 중복 반영을 방지한다.
final class InviteRewardGrantStorage: @unchecked Sendable {
    private enum Key {
        static let grantIds = "inviteRewardGrantIds"
    }

    private static let lock = NSLock()
    private let storage: UserDefaultsStorage

    init(storage: UserDefaultsStorage = UserDefaultsStorage()) {
        self.storage = storage
    }

    func contains(_ grantId: String) -> Bool {
        Self.lock.withLock {
            Set(storage.stringArray(key: Key.grantIds) ?? []).contains(grantId)
        }
    }

    func record(_ grantId: String) {
        Self.lock.withLock {
            var ids = Set(storage.stringArray(key: Key.grantIds) ?? [])
            ids.insert(grantId)
            storage.set(ids.sorted(), forKey: Key.grantIds)
        }
    }
}

//
//  Inventory.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/18/25.
//

/// 아이템 인벤토리
final class Inventory {
    /// 보유한 아이템과 개수 [아이템 이름: 개수]
    private(set) var items: [String: Int] = [:]

    /// 특정 아이템을 추가합니다.
    /// - Parameters:
    ///   - item: 추가할 아이템
    ///   - count: 추가할 개수 (기본값: 1)
    func add(item: ConsumableItem, count: Int = 1) {
        let currentCount = items[item.name] ?? 0
        items[item.name] = currentCount + count
    }

    /// 특정 아이템을 사용합니다.
    /// - Parameter item: 사용할 아이템
    /// - Returns: 사용 성공 시 `true`, 아이템이 없는 경우 `false`
    @discardableResult
    func use(item: ConsumableItem) -> Bool {
        guard let currentCount = items[item.name], currentCount > 0 else {
            return false
        }

        items[item.name] = currentCount - 1
        return true
    }

    /// 특정 아이템의 보유 개수를 반환합니다.
    /// - Parameter item: 확인할 아이템
    /// - Returns: 보유 개수
    func count(of item: ConsumableItem) -> Int {
        items[item.name] ?? 0
    }
}

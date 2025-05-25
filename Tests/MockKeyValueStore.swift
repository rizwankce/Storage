import Foundation
import SwiftStorage

final class MockKeyValueStore: KeyValueStorable {
    private var storage: [String: Any] = [:]
    private(set) var synchronizeCallCount = 0
    private(set) var setCallCount = 0
    private(set) var removeCallCount = 0
    
    func set(_ value: Any?, forKey key: String) {
        setCallCount += 1
        storage[key] = value
    }
    
    func data(forKey key: String) -> Data? {
        return storage[key] as? Data
    }
    
    func removeObject(forKey key: String) {
        removeCallCount += 1
        storage.removeValue(forKey: key)
    }
    
    func synchronize() -> Bool {
        synchronizeCallCount += 1
        return true
    }
    
    func reset() {
        storage.removeAll()
        synchronizeCallCount = 0
        setCallCount = 0
        removeCallCount = 0
    }
}

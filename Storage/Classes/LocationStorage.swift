import Foundation
import CoreLocation

public final class LocationStorage {
    private let storage: Storage<CodableLocation>

    public init(storageType: StorageType, filename: String) {
        self.storage = Storage<CodableLocation>(storageType: storageType, filename: filename)
    }

    public func save(_ location: CLLocation) {
        let codableLocation = CodableLocation(location: location)
        storage.save(codableLocation)
    }

    public var storedValue: CLLocation? {
        return storage.storedValue?.location
    }

    public func clear() {
        storage.clear()
    }
}

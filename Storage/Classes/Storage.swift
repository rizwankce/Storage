import Foundation
import CoreLocation

public final class Storage<T> where T: Codable {
    private let type: StorageType
    private let filename: String

    public init(storageType: StorageType, filename: String) {
        self.type = storageType
        self.filename = filename
        createFolderIfNotExists()
    }

    public func save(_ object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
        } catch let e {
            print("ERROR: \(e)")
        }
    }

    public var storedValue: T? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: data)
        } catch let e {
            print("ERROR: \(e)")
            return nil
        }
    }

    private var folder: URL {
        return type.folder
    }

    private var fileURL: URL {
        return folder.appendingPathComponent(filename)
    }

    private func createFolderIfNotExists() {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: folder.path, isDirectory: &isDir) {
            if isDir.boolValue {
                return
            }

            try? FileManager.default.removeItem(at: folder)
        }
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
    }

    private func clearStorage() {
        try? FileManager.default.removeItem(at: type.folder)
    }
}

extension Storage where T == CLLocation {
    public func saveLocation(_ location: CLLocation) {
        let locationData = LocationData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy: location.verticalAccuracy, timestamp: location.timestamp)
        do {
            let data = try JSONEncoder().encode(locationData)
            try data.write(to: fileURL)
        } catch let e {
            print("ERROR: \(e)")
        }
    }

    public var storedLocation: CLLocation? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let locationData = try JSONDecoder().decode(LocationData.self, from: data)
            return CLLocation(coordinate: CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude), altitude: locationData.altitude, horizontalAccuracy: locationData.horizontalAccuracy, verticalAccuracy: locationData.verticalAccuracy, timestamp: locationData.timestamp)
        } catch let e {
            print("ERROR: \(e)")
            return nil
        }
    }

    private struct LocationData: Codable {
        let latitude: Double
        let longitude: Double
        let altitude: Double
        let horizontalAccuracy: Double
        let verticalAccuracy: Double
        let timestamp: Date
    }
}

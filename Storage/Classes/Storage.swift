import Foundation

/// Protocol defining key-value store operations
public protocol KeyValueStorable: AnyObject {
    func set(_ value: Any?, forKey key: String)
    func data(forKey key: String) -> Data?
    func removeObject(forKey key: String)
    func synchronize() -> Bool
}

#if canImport(Darwin)
extension NSUbiquitousKeyValueStore: KeyValueStorable {}
#endif

/// A class that provides a simple way to store and retrieve Codable objects.
/// The `Storage` class supports different storage types such as cache, document, and user defaults.
/// 
/// - Generic T: The type of object to store; must conform to `Codable`.
public final class Storage<T> where T: Codable {
    private let type: StorageType
    private let filename: String
    private let ubiquitousStore: KeyValueStorable?

    /// Initializes a new instance of `Storage` with the specified storage type and filename.
    ///
    /// - Parameters:
    ///   - storageType: The type of storage to use (cache, document, or user defaults).
    ///   - filename: The name of the file to store the data.
    ///   - ubiquitousStore: Optional KeyValueStorable instance for `.ubiquitousKeyValueStore` type.
#if canImport(Darwin)
    /// Defaults to `NSUbiquitousKeyValueStore.default` on Darwin platforms.
    public init(storageType: StorageType, filename: String, ubiquitousStore: KeyValueStorable? = NSUbiquitousKeyValueStore.default) {
        self.ubiquitousStore = ubiquitousStore
        self.type = storageType
        self.filename = filename
        createFolderIfNotExists()
    }
#else
    /// Defaults to `nil` on non-Darwin platforms.
    public init(storageType: StorageType, filename: String, ubiquitousStore: KeyValueStorable? = nil) {
        self.ubiquitousStore = ubiquitousStore
        self.type = storageType
        self.filename = filename
        createFolderIfNotExists()
    }
#endif

    /// Saves the given object to the specified storage type.
    ///
    /// - Parameter object: The object to save.
    public func save(_ object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            switch type {
            case .cache, .document:
                // Ensure the directory exists in case it was removed by `clear()`
                createFolderIfNotExists()
                try data.write(to: fileURL)
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: type.userDefaultsKey + ".\(filename)")
            case .ubiquitousKeyValueStore:
                ubiquitousStore?.set(data, forKey: filename)
                ubiquitousStore?.synchronize()
            }
        } catch let e {
            print("ERROR: Saving data: \(e)")
        }
    }

    /// Retrieves the stored object from the specified storage type.
    ///
    /// - Returns: The stored object, or `nil` if no object is found.
    public var storedValue: T? {
        switch type {
        case .cache, .document:
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                return nil
            }
            do {
                let data = try Data(contentsOf: fileURL)
                let jsonDecoder = JSONDecoder()
                return try jsonDecoder.decode(T.self, from: data)
            } catch let e {
                print("ERROR: Decoding data for cache/document: \(e)")
                return nil
            }
        case .userDefaults:
            guard let data = UserDefaults.standard.data(forKey: type.userDefaultsKey + ".\(filename)") else {
                return nil
            }
            do {
                let jsonDecoder = JSONDecoder()
                return try jsonDecoder.decode(T.self, from: data)
            } catch let e {
                print("ERROR: Decoding data for userDefaults: \(e)")
                return nil
            }
        case .ubiquitousKeyValueStore:
            guard let store = ubiquitousStore,
                  let data = store.data(forKey: filename) else {
                return nil
            }
            do {
                let jsonDecoder = JSONDecoder()
                return try jsonDecoder.decode(T.self, from: data)
            } catch let e {
                print("ERROR: Decoding data for ubiquitousKeyValueStore: \(e)")
                return nil
            }
        }
    }

    /// The URL of the folder where the data is stored.
    private var folder: URL {
        return type.folder
    }

    /// The URL of the file where the data is stored.
    private var fileURL: URL {
        return folder.appendingPathComponent(filename)
    }

    /// Creates the storage folder if it doesn't exist.
    private func createFolderIfNotExists() {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: folder.path, isDirectory: &isDir) {
            if isDir.boolValue {
                return
            }

            try? FileManager.default.removeItem(at: folder)
        }
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
    }

    /// Clears the stored data from the specified storage type.
    public func clear() {
        switch type {
            case .cache, .document:
                try? FileManager.default.removeItem(at: type.folder)
            case .userDefaults:
                UserDefaults.standard.removeObject(forKey: type.userDefaultsKey + ".\(filename)")
            case .ubiquitousKeyValueStore:
                ubiquitousStore?.removeObject(forKey: filename)
                ubiquitousStore?.synchronize()
        }
    }
}

import Foundation

/// A class that provides a simple way to store and retrieve Codable objects.
/// The `Storage` class supports different storage types such as cache, document, and user defaults.
/// 
/// - Generic T: The type of object to store; must conform to `Codable`.
public final class Storage<T> where T: Codable {
    private let type: StorageType
    private let filename: String

    /// Initializes a new instance of `Storage` with the specified storage type and filename.
    ///
    /// - Parameters:
    ///   - storageType: The type of storage to use (cache, document, or user defaults).
    ///   - filename: The name of the file to store the data.
    public init(storageType: StorageType, filename: String) {
        self.type = storageType
        self.filename = filename
        createFolderIfNotExists()
    }

    /// Saves the given object to the specified storage type.
    ///
    /// - Parameter object: The object to save.
    public func save(_ object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            switch type {
            case .cache, .document:
                createFolderIfNotExists()
                try data.write(to: fileURL)
        case .userDefaults:
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            }
        } catch let e {
            print("ERROR: \(e)")
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
                print("ERROR: \(e)")
                return nil
            }
        case .userDefaults:
            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
                return nil
            }
            do {
                let jsonDecoder = JSONDecoder()
                return try jsonDecoder.decode(T.self, from: data)
            } catch let e {
                print("ERROR: \(e)")
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

    /// The key used for storing data in UserDefaults for this storage instance.
    private var userDefaultsKey: String {
        return "\(type.userDefaultsKey).\(filename)"
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
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
    }

    /// Clears the stored data from the specified storage type.
    public func clear() {
        switch type {
        case .cache, .document:
            try? FileManager.default.removeItem(at: fileURL)
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        }
    }
}

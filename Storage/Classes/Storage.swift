import Foundation

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
            switch type {
            case .cache, .document:
                try data.write(to: fileURL)
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: type.userDefaultsKey)
            }
        } catch let e {
            print("ERROR: \(e)")
        }
    }

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
            guard let data = UserDefaults.standard.data(forKey: type.userDefaultsKey) else {
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

    public func clear() {
        switch type {
            case .cache, .document:
                try? FileManager.default.removeItem(at: type.folder)
            case .userDefaults:
                UserDefaults.standard.removeObject(forKey: type.userDefaultsKey)
        }
    }
}

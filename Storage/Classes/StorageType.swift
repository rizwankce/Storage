import Foundation

public enum StorageType {
    case cache
    case document
    case userDefaults

    public var searchPathDirectory: FileManager.SearchPathDirectory {
        switch self {
        case .cache: return .cachesDirectory
        case .document: return .documentDirectory
        case .userDefaults: fatalError("UserDefaults does not have a search path directory")
        }
    }

    public var folder: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, .userDomainMask, true).first else {
            fatalError("Cannot find the path directory for storage")
        }
        let subfolder = "com.rizwankce.storage"
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }

    public var userDefaultsKey: String {
        return "com.rizwankce.storage.\(self)"
    }
}

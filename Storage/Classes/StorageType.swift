import Foundation

/// An enumeration representing different types of storage options.
/// The `StorageType` enum provides cases for cache, document, and user defaults storage.
public enum StorageType {
    /// Cache storage type, which stores data in the cache directory.
    case cache
    /// Document storage type, which stores data in the document directory.
    case document
    /// User defaults storage type, which stores data in the user defaults.
    case userDefaults

    /// The search path directory associated with each storage type.
    /// This property determines the appropriate `FileManager.SearchPathDirectory` for each case.
    public var searchPathDirectory: FileManager.SearchPathDirectory {
        switch self {
            case .cache: return .cachesDirectory
            case .document: return .documentDirectory
            case .userDefaults: return .cachesDirectory
        }
    }

    /// The folder URL associated with each storage type.
    /// This property constructs the folder URL for each storage type.
    public var folder: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, .userDomainMask, true).first else {
            fatalError("Cannot find the path directory for storage")
        }
        let subfolder = "com.rizwankce.storage"
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }

    /// The user defaults key associated with each storage type.
    /// This property generates a unique key for storing data in `UserDefaults`.
    public var userDefaultsKey: String {
        return "com.rizwankce.storage.\(self)"
    }
}

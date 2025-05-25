import Foundation

/// An enumeration representing different types of storage options.
/// The `StorageType` enum provides cases for cache, document, and user defaults storage.
public enum StorageType {
    /// `cache` storage type, which stores data in the cache directory.
    case cache
    /// `document` storage type, which stores data in the document directory.
    case document
    /// `userDefaults` storage type, which stores data in the user defaults.
    case userDefaults
    /// `ubiquitousKeyValueStore` storage type, which stores data in iCloud key-value store.
    case ubiquitousKeyValueStore

    /// The search path directory associated with each storage type.
    /// This property determines the appropriate `FileManager.SearchPathDirectory` for each case.
    public var searchPathDirectory: FileManager.SearchPathDirectory {
        switch self {
            case .cache: return .cachesDirectory
            case .document: return .documentDirectory
            case .userDefaults: return .cachesDirectory
            case .ubiquitousKeyValueStore: return .cachesDirectory // Or consider a more specific handling if needed
        }
    }

    /// The folder URL associated with each storage type.
    /// This property constructs the folder URL for each storage type.
    /// - Note: This property will call `fatalError` if the directory lookup fails,
    ///         as a missing path is considered a precondition failure.
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

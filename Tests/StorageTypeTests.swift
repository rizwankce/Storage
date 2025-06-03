import XCTest
import SwiftStorage

class StorageTypeTests: XCTestCase {
    func testCacheDirectory() {
        let storageType = StorageType.cache
        let folder = storageType.folder
        let expected = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        XCTAssertTrue(folder.path.hasPrefix(expected), "Cache directory should be inside the system caches directory")
    }

    func testDocumentDirectory() {
        let storageType = StorageType.document
        let folder = storageType.folder
        let expected = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        XCTAssertTrue(folder.path.hasPrefix(expected), "Document directory should be inside the system documents directory")
    }
}

import XCTest
import SwiftStorage

class StorageTypeTests: XCTestCase {
    func testCacheDirectory() {
        let storageType = StorageType.cache
        let folder = storageType.folder
        let path = folder.path
        XCTAssertTrue(path.contains("Caches") || path.contains(".cache"), "Cache directory path should contain 'Caches' on Darwin or '.cache' on Linux")
    }

    func testDocumentDirectory() {
        let storageType = StorageType.document
        let folder = storageType.folder
        let expected = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        XCTAssertTrue(folder.path.hasPrefix(expected), "Document directory should be inside the system documents directory")
    }
}

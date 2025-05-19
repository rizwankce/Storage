import XCTest
import SwiftStorage

class StorageTypeTests: XCTestCase {
    func testCacheDirectory() {
        let storageType = StorageType.cache
        let folder = storageType.folder
        XCTAssertTrue(folder.path.contains("Caches"), "Cache directory path should contain 'Caches'")
    }

    func testDocumentDirectory() {
        let storageType = StorageType.document
        let folder = storageType.folder
        XCTAssertTrue(folder.path.contains("Documents"), "Document directory path should contain 'Documents'")
    }
}

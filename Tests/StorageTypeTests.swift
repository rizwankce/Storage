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
        XCTAssertTrue(folder.path.contains("Documents"), "Document directory path should contain 'Documents'")
    }
}

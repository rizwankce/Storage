import XCTest
import SwiftStorage

class StorageTypeTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        let fileManager = FileManager.default
        let storageTypes: [StorageType] = [.cache, .document]
        for storageType in storageTypes {
            let folder = storageType.folder
            if fileManager.fileExists(atPath: folder.path) {
                try? fileManager.removeItem(at: folder)
            }
        }
    }

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

    func testFolderCreation() {
        let storageType = StorageType.document
        let folder = storageType.folder
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let exists = fileManager.fileExists(atPath: folder.path, isDirectory: &isDir)
        XCTAssertTrue(exists && isDir.boolValue, "Folder should be created and be a directory")
    }
}

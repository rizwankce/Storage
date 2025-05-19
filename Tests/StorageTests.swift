import XCTest
import SwiftStorage

class StorageTests: XCTestCase {

    func testSaveAndRetrieve() {
        let storage = Storage<[String]>(storageType: .document, filename: "test.json")
        
        let testData = ["item1", "item2", "item3"]
        storage.save(testData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, testData, "Stored and retrieved data should be equal")
    }

    func testRetrieveNonExistentFile() {
        let storage = Storage<[String]>(storageType: .document, filename: "nonexistent.json")
        let retrievedData = storage.storedValue
        XCTAssertNil(retrievedData, "Retrieving a non-existent file should return nil")
    }

    func testOverwriteData() {
        let storage = Storage<[String]>(storageType: .document, filename: "test.json")
        let initialData = ["item1", "item2"]
        storage.save(initialData)

        let newData = ["item3", "item4"]
        storage.save(newData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, newData, "Stored and retrieved data should be equal after overwrite")
    }

    func testSaveAndRetrieveUserDefaults() {
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "testUserDefaults")
        
        let testData = ["item1", "item2", "item3"]
        storage.save(testData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, testData, "Stored and retrieved data should be equal for user defaults")
    }

    func testRetrieveNonExistentUserDefaults() {
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "nonexistentUserDefaults")
        let retrievedData = storage.storedValue
        XCTAssertNil(retrievedData, "Retrieving non-existent data from user defaults should return nil")
    }

    func testOverwriteUserDefaultsData() {
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "testUserDefaults")
        let initialData = ["item1", "item2"]
        storage.save(initialData)

        let newData = ["item3", "item4"]
        storage.save(newData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, newData, "Stored and retrieved data should be equal after overwrite in user defaults")
    }
}

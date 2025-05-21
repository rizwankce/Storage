import XCTest
import SwiftStorage

// Define a Codable and Equatable struct for testing
private struct TestData: Codable, Equatable {
    let id: Int
    let name: String
}

class StorageTests: XCTestCase {

    override func tearDown() {
        // Clean up NSUbiquitousKeyValueStore after each test that might use it.
        // This is to ensure a clean state for subsequent tests, as these values can persist.
        // Note: This is a blanket cleanup. More targeted cleanup is done within tests using storage.clear().
        // However, some tests might interact with NSUbiquitousKeyValueStore directly or leave residues if assertions fail before cleanup.
        // For robust tests, ensure each test cleans up its own keys.
        // This is a more aggressive cleanup for safety.
        let store = NSUbiquitousKeyValueStore.default
        store.dictionaryRepresentation.keys.forEach { key in
            store.removeObject(forKey: key)
        }
        store.synchronize() // Ensure changes are written
        super.tearDown()
    }

    func testSaveAndRetrieve() {
        let storage = Storage<[String]>(storageType: .document, filename: "test.json")
        
        let testData = ["item1", "item2", "item3"]
        storage.save(testData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, testData, "Stored and retrieved data should be equal")
        storage.clear()
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
        storage.clear()
    }

    func testSaveAndRetrieveUserDefaults() {
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "testUserDefaults")
        
        let testData = ["item1", "item2", "item3"]
        storage.save(testData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, testData, "Stored and retrieved data should be equal for user defaults")
        storage.clear()
    }

    func testRetrieveNonExistentUserDefaults() {
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "nonexistentUserDefaults")
        let retrievedData = storage.storedValue
        XCTAssertNil(retrievedData, "Retrieving non-existent data from user defaults should return nil")
        storage.clear()
    }

    func testOverwriteUserDefaultsData() {
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "testUserDefaults")
        let initialData = ["item1", "item2"]
        storage.save(initialData)

        let newData = ["item3", "item4"]
        storage.save(newData)

        let retrievedData = storage.storedValue
        XCTAssertEqual(retrievedData, newData, "Stored and retrieved data should be equal after overwrite in user defaults")
        storage.clear()
    }

    // MARK: - Ubiquitous Key-Value Store Tests

    func testSaveAndRetrieveUbiquitous() {
        let filename = "testUbiquitous.json"
        let storage = Storage<TestData>(storageType: .ubiquitousKeyValueStore, filename: filename)
        let testObject = TestData(id: 1, name: "Ubiquitous Test")

        // Clear any potential leftover data from a previous failed run
        NSUbiquitousKeyValueStore.default.removeObject(forKey: filename)
        NSUbiquitousKeyValueStore.default.synchronize()

        storage.save(testObject)
        // NSUbiquitousKeyValueStore can be eventually consistent. For testing, synchronize might help.
        NSUbiquitousKeyValueStore.default.synchronize()

        let retrievedObject = storage.storedValue
        XCTAssertNotNil(retrievedObject, "Retrieved object should not be nil for ubiquitous store.")
        XCTAssertEqual(retrievedObject, testObject, "Stored and retrieved object should be equal for ubiquitous store.")

        storage.clear() // This should remove the key
        NSUbiquitousKeyValueStore.default.synchronize() // Ensure clear operation is synchronized
        XCTAssertNil(NSUbiquitousKeyValueStore.default.object(forKey: filename), "Value should be cleared from NSUbiquitousKeyValueStore.")
    }

    func testRetrieveNonExistentUbiquitous() {
        let filename = "nonExistentUbiquitous.json"
        // Ensure the key is not present before the test
        NSUbiquitousKeyValueStore.default.removeObject(forKey: filename)
        NSUbiquitousKeyValueStore.default.synchronize()

        let storage = Storage<TestData>(storageType: .ubiquitousKeyValueStore, filename: filename)
        let retrievedObject = storage.storedValue

        XCTAssertNil(retrievedObject, "Retrieving a non-existent object from ubiquitous store should return nil.")
    }

    func testClearUbiquitous() {
        let filename = "clearTestUbiquitous.json"
        let storage = Storage<TestData>(storageType: .ubiquitousKeyValueStore, filename: filename)
        let testObject = TestData(id: 2, name: "Clear Test Ubiquitous")

        // Clear any potential leftover data
        NSUbiquitousKeyValueStore.default.removeObject(forKey: filename)
        NSUbiquitousKeyValueStore.default.synchronize()

        storage.save(testObject)
        NSUbiquitousKeyValueStore.default.synchronize() // Ensure save is synchronized

        // Verify it's there before clearing
        XCTAssertNotNil(storage.storedValue, "Value should exist before clearing.")

        storage.clear()
        NSUbiquitousKeyValueStore.default.synchronize() // Ensure clear is synchronized

        let retrievedObject = storage.storedValue
        XCTAssertNil(retrievedObject, "Retrieved object should be nil after clearing from ubiquitous store.")
        XCTAssertNil(NSUbiquitousKeyValueStore.default.object(forKey: filename), "Value should be cleared from NSUbiquitousKeyValueStore directly.")
    }
}

import XCTest
import SwiftStorage

// Define a Codable and Equatable struct for testing
private struct TestData: Codable, Equatable {
    let id: Int
    let name: String
}

class StorageTests: XCTestCase {

    private var mockStore: MockKeyValueStore!
    
    override func setUp() {
        super.setUp()
        mockStore = MockKeyValueStore()
    }
    
    override func tearDown() {
        mockStore = nil
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

    func testSaveAfterClearDocument() {
        let filename = "clearThenSave.json"
        let storage = Storage<[String]>(storageType: .document, filename: filename)

        // Save initial data
        storage.save(["first"])
        XCTAssertEqual(storage.storedValue, ["first"], "Initial data should be saved")

        // Clear the storage
        storage.clear()

        // Save new data after clearing
        let newData = ["second", "third"]
        storage.save(newData)

        // Verify the new data can be retrieved
        let retrieved = storage.storedValue
        XCTAssertEqual(retrieved, newData, "Data saved after clear should be retrievable")

        // Cleanup created storage
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
        let storage = Storage<[String]>(storageType: .userDefaults, filename: "overwriteTestUserDefaults")
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
        let storage = Storage<TestData>(storageType: .ubiquitousKeyValueStore, filename: filename, ubiquitousStore: mockStore)
        let testObject = TestData(id: 1, name: "Ubiquitous Test")

        storage.save(testObject)
        XCTAssertEqual(mockStore.setCallCount, 1, "Set should be called once")
        XCTAssertEqual(mockStore.synchronizeCallCount, 1, "Synchronize should be called once")

        let retrievedObject = storage.storedValue
        XCTAssertNotNil(retrievedObject, "Retrieved object should not be nil for ubiquitous store")
        XCTAssertEqual(retrievedObject, testObject, "Stored and retrieved object should be equal for ubiquitous store")

        storage.clear()
        XCTAssertEqual(mockStore.removeCallCount, 1, "Remove should be called once")
        XCTAssertEqual(mockStore.synchronizeCallCount, 2, "Synchronize should be called twice")
        XCTAssertNil(storage.storedValue, "Value should be cleared from store")
    }

    func testRetrieveNonExistentUbiquitous() {
        let filename = "nonExistentUbiquitous.json"
        let storage = Storage<TestData>(storageType: .ubiquitousKeyValueStore, filename: filename, ubiquitousStore: mockStore)
        
        let retrievedObject = storage.storedValue
        XCTAssertNil(retrievedObject, "Retrieving a non-existent object from ubiquitous store should return nil")
    }

    func testClearUbiquitous() {
        let filename = "clearTestUbiquitous.json"
        let storage = Storage<TestData>(storageType: .ubiquitousKeyValueStore, filename: filename, ubiquitousStore: mockStore)
        let testObject = TestData(id: 2, name: "Clear Test Ubiquitous")

        storage.save(testObject)
        XCTAssertEqual(mockStore.setCallCount, 1, "Set should be called once")
        XCTAssertEqual(mockStore.synchronizeCallCount, 1, "Synchronize should be called once")

        // Verify it's there before clearing
        XCTAssertNotNil(storage.storedValue, "Value should exist before clearing")

        storage.clear()
        XCTAssertEqual(mockStore.removeCallCount, 1, "Remove should be called once")
        XCTAssertEqual(mockStore.synchronizeCallCount, 2, "Synchronize should be called twice")

        let retrievedObject = storage.storedValue
        XCTAssertNil(retrievedObject, "Retrieved object should be nil after clearing from ubiquitous store")
    }
}

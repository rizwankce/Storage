import XCTest
@testable import SwiftStorage // Use @testable to access internal types if LocationStorage or CodableLocation are internal

// Define CodableLocation struct if it's not globally available or part of SwiftStorage module
// Assuming it's not, let's define it here for the test.
// If it IS part of SwiftStorage, this definition would conflict if not properly namespaced or if SwiftStorage makes it public.
// Given the context, it's safer to assume it might be needed here.
struct CodableLocation: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let description: String

    static func == (lhs: CodableLocation, rhs: CodableLocation) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.description == rhs.description
    }
}

class LocationStorageTests: XCTestCase {

    let testLocation1 = CodableLocation(latitude: 34.0522, longitude: -118.2437, description: "Los Angeles")
    let testLocationKey1 = "testLocationUserDefaults1"
    let testLocationKey2 = "testLocationUserDefaults2"

    override func setUp() {
        super.setUp()
        // Clean up UserDefaults before each test for the specific keys used in these tests
        // This ensures a clean slate and avoids interference between tests.
        // The fix in Storage.swift now uses "type.userDefaultsKey + . + filename"
        let userDefaultsKeyPrefix = "com.rizwankce.storage.userDefaults"
        UserDefaults.standard.removeObject(forKey: "\(userDefaultsKeyPrefix).\(testLocationKey1)")
        UserDefaults.standard.removeObject(forKey: "\(userDefaultsKeyPrefix).\(testLocationKey2)")
        UserDefaults.standard.synchronize() // Ensure removal is processed
    }

    override func tearDown() {
        // Clean up UserDefaults after each test for the specific keys
        let userDefaultsKeyPrefix = "com.rizwankce.storage.userDefaults"
        UserDefaults.standard.removeObject(forKey: "\(userDefaultsKeyPrefix).\(testLocationKey1)")
        UserDefaults.standard.removeObject(forKey: "\(userDefaultsKeyPrefix).\(testLocationKey2)")
        UserDefaults.standard.synchronize() // Ensure removal is processed
        super.tearDown()
    }

    func testSaveAndRetrieveLocation_userDefaults() {
        let storage = Storage<CodableLocation>(storageType: .userDefaults, filename: testLocationKey1)

        // Save the location
        storage.save(testLocation1)

        // Retrieve the location
        let retrievedLocation = storage.storedValue

        // Assertions
        XCTAssertNotNil(retrievedLocation, "Retrieved location should not be nil from UserDefaults.")
        XCTAssertEqual(retrievedLocation, testLocation1, "Retrieved location should match the original saved location in UserDefaults.")
        
        // Clean up for this specific test (optional if tearDown is comprehensive, but good for clarity)
        storage.clear()
    }

    func testClearLocation_userDefaults() {
        let storage = Storage<CodableLocation>(storageType: .userDefaults, filename: testLocationKey2)

        // Save the location
        storage.save(testLocation1)

        // Assert that the value is present before clearing
        // This addresses the "XCTAssertNotNil failed - UserDefaults should not be nil before clearing"
        let valueBeforeClearing = storage.storedValue
        XCTAssertNotNil(valueBeforeClearing, "Location should be present in UserDefaults before clearing.")

        // Clear the storage
        storage.clear()

        // Assert that the value is nil after clearing
        let valueAfterClearing = storage.storedValue
        XCTAssertNil(valueAfterClearing, "Location should be nil in UserDefaults after clearing.")
    }
    
    func testRetrieveNonExistentLocation_userDefaults() {
        // This key should not have any data due to setUp
        let storage = Storage<CodableLocation>(storageType: .userDefaults, filename: "nonExistentLocationKey")
        
        let retrievedLocation = storage.storedValue
        XCTAssertNil(retrievedLocation, "Retrieving a non-existent location from UserDefaults should return nil.")
    }
}

import XCTest
import CoreLocation
@testable import Storage

class LocationStorageTests: XCTestCase {

    var cacheLocationStorage: LocationStorage!
    var documentLocationStorage: LocationStorage!
    var userDefaultsLocationStorage: LocationStorage!

    let sampleLocation = CLLocation(
        latitude: 37.334803,
        longitude: -122.008965,
        altitude: 10.0,
        horizontalAccuracy: 5.0,
        verticalAccuracy: 5.0,
        course: 90.0,
        speed: 2.0,
        timestamp: Date(timeIntervalSince1970: 1678886400) // March 15, 2023
    )

    override func setUp() {
        super.setUp()
        // Use unique filenames for each storage type to avoid collisions
        cacheLocationStorage = LocationStorage(storageType: .cache, filename: "testCacheLocation.json")
        documentLocationStorage = LocationStorage(storageType: .document, filename: "testDocumentLocation.json")
        userDefaultsLocationStorage = LocationStorage(storageType: .userDefaults, filename: "testUserDefaultsLocationKey")

        // Clear any existing data before each test
        cacheLocationStorage.clear()
        documentLocationStorage.clear()
        userDefaultsLocationStorage.clear()
    }

    override func tearDown() {
        cacheLocationStorage.clear()
        documentLocationStorage.clear()
        userDefaultsLocationStorage.clear()

        cacheLocationStorage = nil
        documentLocationStorage = nil
        userDefaultsLocationStorage = nil
        super.tearDown()
    }

    // MARK: - Save and Retrieve Tests

    func testSaveAndRetrieveLocation_cache() {
        cacheLocationStorage.save(sampleLocation)
        let retrievedLocation = cacheLocationStorage.storedValue

        XCTAssertNotNil(retrievedLocation)
        assertEqualLocations(retrievedLocation, sampleLocation)

        cacheLocationStorage.clear()
        XCTAssertNil(cacheLocationStorage.storedValue, "Cache should be nil after clearing.")
    }

    func testSaveAndRetrieveLocation_document() {
        documentLocationStorage.save(sampleLocation)
        let retrievedLocation = documentLocationStorage.storedValue

        XCTAssertNotNil(retrievedLocation)
        assertEqualLocations(retrievedLocation, sampleLocation)

        documentLocationStorage.clear()
        XCTAssertNil(documentLocationStorage.storedValue, "Document should be nil after clearing.")
    }

    func testSaveAndRetrieveLocation_userDefaults() {
        userDefaultsLocationStorage.save(sampleLocation)
        let retrievedLocation = userDefaultsLocationStorage.storedValue

        XCTAssertNotNil(retrievedLocation)
        assertEqualLocations(retrievedLocation, sampleLocation)

        userDefaultsLocationStorage.clear()
        XCTAssertNil(userDefaultsLocationStorage.storedValue, "UserDefaults should be nil after clearing.")
    }

    // MARK: - Clear Tests

    func testClearLocation_cache() {
        cacheLocationStorage.save(sampleLocation)
        XCTAssertNotNil(cacheLocationStorage.storedValue, "Cache should not be nil before clearing.")
        
        cacheLocationStorage.clear()
        XCTAssertNil(cacheLocationStorage.storedValue, "Cache should be nil after clearing.")
    }

    func testClearLocation_document() {
        documentLocationStorage.save(sampleLocation)
        XCTAssertNotNil(documentLocationStorage.storedValue, "Document should not be nil before clearing.")

        documentLocationStorage.clear()
        XCTAssertNil(documentLocationStorage.storedValue, "Document should be nil after clearing.")
    }

    func testClearLocation_userDefaults() {
        userDefaultsLocationStorage.save(sampleLocation)
        XCTAssertNotNil(userDefaultsLocationStorage.storedValue, "UserDefaults should not be nil before clearing.")

        userDefaultsLocationStorage.clear()
        XCTAssertNil(userDefaultsLocationStorage.storedValue, "UserDefaults should be nil after clearing.")
    }

    // MARK: - Helper
    
    private func assertEqualLocations(_ loc1: CLLocation?, _ loc2: CLLocation?, file: StaticString = #file, line: UInt = #line) {
        guard let loc1 = loc1, let loc2 = loc2 else {
            XCTFail("One or both locations are nil.", file: file, line: line)
            return
        }

        XCTAssertEqual(loc1.coordinate.latitude, loc2.coordinate.latitude, accuracy: 0.00001, "Latitude should match", file: file, line: line)
        XCTAssertEqual(loc1.coordinate.longitude, loc2.coordinate.longitude, accuracy: 0.00001, "Longitude should match", file: file, line: line)
        XCTAssertEqual(loc1.altitude, loc2.altitude, accuracy: 0.00001, "Altitude should match", file: file, line: line)
        XCTAssertEqual(loc1.horizontalAccuracy, loc2.horizontalAccuracy, accuracy: 0.00001, "Horizontal Accuracy should match", file: file, line: line)
        XCTAssertEqual(loc1.verticalAccuracy, loc2.verticalAccuracy, accuracy: 0.00001, "Vertical Accuracy should match", file: file, line: line)
        // Course and Speed might not be present in all CLLocation objects, or can be -1 if invalid.
        // For this test, sampleLocation provides them.
        XCTAssertEqual(loc1.course, loc2.course, accuracy: 0.00001, "Course should match", file: file, line: line)
        XCTAssertEqual(loc1.speed, loc2.speed, accuracy: 0.00001, "Speed should match", file: file, line: line)
        // Timestamps can have sub-second differences when written and read. Comparing with tolerance.
        XCTAssertEqual(loc1.timestamp.timeIntervalSince1970, loc2.timestamp.timeIntervalSince1970, accuracy: 0.001, "Timestamp should match", file: file, line: line)
    }
}

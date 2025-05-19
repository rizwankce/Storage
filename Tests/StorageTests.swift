import XCTest
import SwiftStorage
import CoreLocation

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

    func testSaveAndRetrieveLocation() {
        let storage = Storage<CLLocation>(storageType: .document, filename: "location.json")
        
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        storage.saveLocation(testLocation)

        let retrievedLocation = storage.storedLocation
        XCTAssertEqual(retrievedLocation?.coordinate.latitude, testLocation.coordinate.latitude, "Stored and retrieved latitude should be equal")
        XCTAssertEqual(retrievedLocation?.coordinate.longitude, testLocation.coordinate.longitude, "Stored and retrieved longitude should be equal")
    }

    func testRetrieveNonExistentLocation() {
        let storage = Storage<CLLocation>(storageType: .document, filename: "nonexistent_location.json")
        let retrievedLocation = storage.storedLocation
        XCTAssertNil(retrievedLocation, "Retrieving a non-existent location should return nil")
    }
}

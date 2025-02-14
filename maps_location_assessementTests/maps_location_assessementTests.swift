//
//  maps_location_assessementTests.swift
//  maps_location_assessementTests
//
//  Created by DavidOnoh on 2/12/25.
//

import XCTest
import CoreLocation
@testable import maps_location_assessement

final class MapViewModelTests: XCTestCase {
    func testUpdateMapRegion() {
        // Given: A MapViewModel instance and a test coordinate
        let viewModel = MapViewModel()
        let testCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        
        // When: Calling updateMapRegion
        viewModel.updateMapRegion(to: testCoordinate)
        
        // Then: The region should be updated 
        XCTAssertEqual(viewModel.usersLocation.center.latitude, testCoordinate.latitude, accuracy: 0.0001)
        XCTAssertEqual(viewModel.usersLocation.center.longitude, testCoordinate.longitude, accuracy: 0.0001)
        XCTAssertEqual(viewModel.usersLocation.span.latitudeDelta, 0.01, accuracy: 0.0001)
        XCTAssertEqual(viewModel.usersLocation.span.longitudeDelta, 0.01, accuracy: 0.0001)
    }
    
    func testRecenterMap() {
            let viewModel = MapViewModel()
            let testCoordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060) // New York City
            let mockLocationManager = MockLocationManager(testCoordinate: testCoordinate)

            
            viewModel.userLocationManager = mockLocationManager

            // When: Calling recenterMap
            viewModel.recenterMap()

        
            XCTAssertEqual(viewModel.usersLocation.center.latitude, testCoordinate.latitude, accuracy: 0.0001)
            XCTAssertEqual(viewModel.usersLocation.center.longitude, testCoordinate.longitude, accuracy: 0.0001)
            XCTAssertEqual(viewModel.usersLocation.span.latitudeDelta, MapDetails.userDefaultSpan.latitudeDelta, accuracy: 0.0001)
            XCTAssertEqual(viewModel.usersLocation.span.longitudeDelta, MapDetails.userDefaultSpan.longitudeDelta, accuracy: 0.0001)
        }

}


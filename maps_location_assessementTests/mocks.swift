//
//  mocks.swift
//  maps_location_assessementTests
//
//  Created by DavidOnoh on 2/14/25.
//

import Foundation
import MapKit

class MockLocationManager: CLLocationManager {
    private let testLocation: CLLocation

    init(testCoordinate: CLLocationCoordinate2D) {
        self.testLocation = CLLocation(latitude: testCoordinate.latitude, longitude: testCoordinate.longitude)
        super.init()
    }

    override var location: CLLocation? {
        return testLocation
    }
}

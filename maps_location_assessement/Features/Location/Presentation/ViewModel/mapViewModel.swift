//
//  mapViewModel.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/12/25.
//
@preconcurrency
import MapKit

enum MapDetails{
    static let beginLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    static let  userDefaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

//we making the mapviewModel conform to CLLocationMangerDelegate to make the viewModel listen to  all updates
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var search: String = ""
    @Published var usersLocation = MKCoordinateRegion(
        center: MapDetails.beginLocation,
        span: MapDetails.userDefaultSpan
        )
    
    var userLocationManager : CLLocationManager?
    @Published var results = [MKMapItem]()
    
    func checkIfLocationisAvailable(){
        if CLLocationManager.locationServicesEnabled() {
            userLocationManager = CLLocationManager()
            userLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
            userLocationManager!.delegate = self
        }else{
            print("Location services is disabeled")
        }
    }
    
   private func checkIfUserHasGrantedLocationPermission(){
        guard let locationManger = userLocationManager else {return}
        
        switch locationManger.authorizationStatus{
            
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
        print("Locations is sorta restricted")
        case .denied:
            print("Locations is Denied")
        case .authorizedAlways,.authorizedWhenInUse:
            usersLocation = MKCoordinateRegion(center: locationManger.location!.coordinate,
            span: MapDetails.userDefaultSpan)
            break
        
        @unknown default:
            break
        }
        
    }
    
    func searchForNearByPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        request.region = usersLocation
        
        do {
            let response = try await MKLocalSearch(request: request).start()
            let places = response.mapItems  // Extract data before moving to main thread
            
            DispatchQueue.main.async { [places] in
                self.results = places
                
                // Move camera to the first result, if available
                if let firstPlace = places.first {
                    self.updateMapRegion(to: firstPlace.placemark.coordinate)
                }
            }
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }

    func updateMapRegion(to coordinate: CLLocationCoordinate2D) {
            usersLocation = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoom in on location
            )
        }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkIfUserHasGrantedLocationPermission()
    }
    
    func recenterMap() {
        guard let location = userLocationManager?.location else { return }
        DispatchQueue.main.async {
            self.usersLocation = MKCoordinateRegion(
                center: location.coordinate,
                span: MapDetails.userDefaultSpan
            )
        }
    }
    
    
}

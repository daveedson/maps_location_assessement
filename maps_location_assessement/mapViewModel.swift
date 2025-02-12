//
//  mapViewModel.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/12/25.
//

import MapKit

enum MapDetails{
    static let beginLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    static let  userDefaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

//we making the mapviewModel conform to CLLocationMangerDelegate to make the viewModel listen to  all updates
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var usersLocation = MKCoordinateRegion(
        center: MapDetails.beginLocation,
        span: MapDetails.userDefaultSpan
        )
   
    var userLocationManager : CLLocationManager?
    
    func checkIfLocationisAvailable(){
        if CLLocationManager.locationServicesEnabled(){
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkIfUserHasGrantedLocationPermission()
    }
    
}

//
//  MapView.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/12/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    let location =  CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        
    var body: some View {
        
        ZStack (alignment: .top){
            Map(coordinateRegion: $mapViewModel.usersLocation, showsUserLocation: true).ignoresSafeArea(.all)
                .accentColor(Color(.systemGreen))
                .onAppear{
                    mapViewModel.checkIfLocationisAvailable()
                }
            TextField("Search near by places", text: $mapViewModel.search, onCommit: {
                  mapViewModel.searchForNearByPlaces()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
        }
    }
}

#Preview {
    MapView()
}

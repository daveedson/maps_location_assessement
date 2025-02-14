//
//  CoreDataManager.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/14/25.
//



import Foundation
import MapKit
import CoreData

class LocationDetailViewModel: ObservableObject {
    @Published var location: MKMapItem?
    @Published var lookAround: MKLookAroundScene?
    @Published var isFavorite: Bool = false

    init(location: MKMapItem?) {
        self.location = location
        self.isFavorite = location != nil ? CoreDataManager.shared.isFavorite(location: location!) : false
        fetchLookAroundPreview()
    }

    func fetchLookAroundPreview() {
        guard let location else { return }
        lookAround = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: location)
            lookAround = try? await request.scene
        }
    }

    func toggleFavorite() {
        guard let location else { return }

        if isFavorite {
            CoreDataManager.shared.removeFavorite(location: location)
        } else {
            CoreDataManager.shared.saveFavorite(location: location)
        }

        isFavorite.toggle()
    }
}


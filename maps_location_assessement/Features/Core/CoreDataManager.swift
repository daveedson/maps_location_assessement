//
//  CoreDataManager.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/14/25.
//

import Foundation

import CoreData
import MapKit

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "LocationModel") // Ensure this matches your .xcdatamodeld file
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

 
    func saveFavorite(location: MKMapItem) {
        let favorite = FavoriteLocation(context: context)
        favorite.id = UUID()
        favorite.name = location.placemark.name ?? "Unknown"
        favorite.address = location.placemark.title ?? "No Address"
        favorite.latitude = location.placemark.coordinate.latitude
        favorite.longitude = location.placemark.coordinate.longitude

        do {
            try context.save()
            print("Place saved as favorite!")
        } catch {
            print("Error  occured saving location: \(error.localizedDescription)")
        }
    }

    // Fetch Favorite Locations
    func fetchFavorites() -> [FavoriteLocation] {
        let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return []
        }
    }

    // Check if Location is Already Favorited
    func isFavorite(location: MKMapItem) -> Bool {
        let favorites = fetchFavorites()
        return favorites.contains { $0.name == location.placemark.name }
    }

    // Remove Favorite
    func removeFavorite(location: MKMapItem) {
        let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", location.placemark.name ?? "")

        do {
            let results = try context.fetch(request)
            for item in results {
                context.delete(item)
            }
            try context.save()
            print("Location removed from favorites!")
        } catch {
            print("Error removing favorite: \(error.localizedDescription)")
        }
    }
}

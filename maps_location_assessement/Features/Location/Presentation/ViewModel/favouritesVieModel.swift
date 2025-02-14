//
//  favouritesVieModel.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/14/25.
//


import Foundation
import CoreData

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteLocation] = []

    init() {
        fetchFavorites()
    }

    func fetchFavorites() {
        let request: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()

        do {
            favorites = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
        }
    }

    func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let favoriteToDelete = favorites[index]
            CoreDataManager.shared.context.delete(favoriteToDelete)
        }

        do {
            try CoreDataManager.shared.context.save()
            favorites.remove(atOffsets: offsets)
        } catch {
            print("Error deleting favorite: \(error.localizedDescription)")
        }
    }
}

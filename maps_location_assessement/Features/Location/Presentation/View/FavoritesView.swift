//
//  FavoritesView.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/14/25.
//

import SwiftUI
import MapKit

struct FavoritesView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if favoritesViewModel.favorites.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .padding()
                        Text("No Favorite Places")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(favoritesViewModel.favorites, id: \.id) { favorite in
                            NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                                FavoriteRow(favorite: favorite)
                            }
                        }
                        .onDelete(perform: favoritesViewModel.deleteFavorite)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Favorite Spots")
            .onAppear {
                favoritesViewModel.fetchFavorites()
            }
        }
    }
}

// MARK: - Row View for Favorite Locations
struct FavoriteRow: View {
    let favorite: FavoriteLocation

    var body: some View {
        HStack {
            MapSnapshotView(latitude: favorite.latitude, longitude: favorite.longitude)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .shadow(radius: 3)

            VStack(alignment: .leading) {
                Text(favorite.name ?? "Unknown Place")
                    .font(.headline)
                Text(favorite.address ?? "No Address")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(5)
    }
}

// MARK: - Favorite Location Detail View
struct FavoriteDetailView: View {
    let favorite: FavoriteLocation

    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: favorite.latitude, longitude: favorite.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )))
            .frame(height: 300)
            .cornerRadius(12)
            .padding()

            Text(favorite.name ?? "Unknown Place")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Text(favorite.address ?? "No Address")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}

// MARK: - Map Snapshot View for Small Map Preview
struct MapSnapshotView: View {
    let latitude: Double
    let longitude: Double

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }
}

#Preview {
    FavoritesView()
}



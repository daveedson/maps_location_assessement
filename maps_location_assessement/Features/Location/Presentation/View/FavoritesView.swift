//
//  FavoritesView.swift
//  maps_location_assessement
//
//  Created by DavidOnoh on 2/14/25.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack {
            Text("Favorite Spots")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Here you can display saved favorite spots.")
                .font(.body)
                .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    FavoritesView()
}


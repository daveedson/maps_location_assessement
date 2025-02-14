import SwiftUI
import MapKit

extension MKMapItem: @retroactive Identifiable {
    public var id: String {
        return UUID().uuidString
    }
}

struct MapView: View {
    @ObservedObject var mapViewModel = MapViewModel()
    @State private var selectedLocation: MKMapItem?

    var body: some View {
        ZStack(alignment: .top) {
            Map(
                coordinateRegion: $mapViewModel.usersLocation,
                showsUserLocation: true,
                annotationItems: mapViewModel.results
            ) { item in
                MapAnnotation(coordinate: item.placemark.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .onTapGesture {
                                selectedLocation = item
                            }
                        Text(item.placemark.name ?? "Unknown")
                            .font(.caption)
                            .padding(5)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(5)
                    }
                }
            }
            .ignoresSafeArea(.all)
            .accentColor(Color(.systemGreen))
            .onAppear {
                mapViewModel.checkIfLocationisAvailable()
            }

            VStack {
                TextField("Search nearby places", text: $mapViewModel.search)
                    .onSubmit(of: .text) {
                        Task {
                            await mapViewModel.searchForNearByPlaces()
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        mapViewModel.recenterMap()
                    }) {
                        Image(systemName: "location.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $selectedLocation) { location in
            LocationDetailView(locationDetailviewModel: LocationDetailViewModel(location: location))
        }
        .presentationDetents([.height(550)])
    }
}

#Preview {
    MapView()
}

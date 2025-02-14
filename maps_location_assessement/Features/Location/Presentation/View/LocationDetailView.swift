import SwiftUI
import MapKit

struct LocationDetailView: View {
    @ObservedObject var locationDetailviewModel = LocationDetailViewModel()

    var body: some View {
        VStack {
            if let location = locationDetailviewModel.location {
                Text(location.placemark.name ?? "Unknown Place")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if let address = location.placemark.title {
                    Text(address)
                        .font(.body)
                        .padding(.horizontal)
                }

                if let scene = locationDetailviewModel.lookAround {
                    if #available(iOS 17.0, *) {
                        LookAroundPreview(initialScene: scene)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding()
                    }
                } else {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView("No preview available", systemImage: "eye.slash")
                    }
                }
            } else {
                Text("No location selected")
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear {
            locationDetailviewModel.fetchLookAroundPreview()
        }
        .onChange(of: locationDetailviewModel.location) { _ in
            locationDetailviewModel.fetchLookAroundPreview()
        }
        .padding()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    LocationDetailView(locationDetailviewModel: LocationDetailViewModel(location: nil))
}

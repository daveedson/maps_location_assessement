import SwiftUI
import MapKit

class LocationDetailViewModel: ObservableObject {
    @Published var location: MKMapItem?
    @Published var lookAround: MKLookAroundScene?

    init(location: MKMapItem? = nil) { 
        self.location = location
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
}

//
//  ContentView.swift
//  BucketList
//
//  Created by 임지성 on 6/14/24.
//

import LocalAuthentication // Face ID
import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var locations = [Location]()
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    // position은 탭된 '화면'의 positioyssn
                    // coordinate는 그걸 지도 상의 좌표로 변환시켜줌
                    // local은 화면 전체가 아니라 'Map뷰' 내에서의 좌표를 뜻함
                    let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                    locations.append(newLocation)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

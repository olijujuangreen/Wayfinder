//
//  WFMap.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import MapKit
import Models
import SwiftUI

public struct WFMap: View {
	@Binding var cameraPosition: MapCameraPosition
	@Binding var mapSelection: MKMapItem?

	private let results: [SearchResult]

	public init(
		cameraPosition: Binding<MapCameraPosition>,
		mapSelection: Binding<MKMapItem?>,
		results: [SearchResult]
	) {
		_cameraPosition = cameraPosition
		_mapSelection = mapSelection
		self.results = results
	}

	public var body: some View {
		Map(position: $cameraPosition, selection: $mapSelection) {
			LocationAnnotation(coordinate: .init(latitude: 25.7602, longitude: -80.1959))
			SearchResultContent(results: results)
		}
	}
}

private extension MKCoordinateRegion {
	static let previewRegion = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 33.7490, longitude: -84.3880),
		span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
	)
}

#Preview {
	WFMap(
		cameraPosition: .constant(.region(.previewRegion)),
		mapSelection: .constant(nil),
		results: [],
	)
}



//
//  WFMap.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import MapKit
import Models
import SwiftUI

/// A Wayfinder map component that highlights the user's location and search results.
public struct WFMap: View {
	@Binding var cameraPosition: MapCameraPosition
	@Binding var mapSelection: MKMapItem?

	private let results: [SearchResult]
	private let userLocation: CLLocationCoordinate2D?

	/// Creates a Wayfinder map component.
	///
	/// - Parameters:
	///   - cameraPosition: Binding describing the current camera configuration.
	///   - mapSelection: Binding to the selected map item.
	///   - results: Search results to render on the map.
	///   - location: The caller's resolved coordinate. Provide a value to display
	///     the user's location annotation on the map.
	public init(
		cameraPosition: Binding<MapCameraPosition>,
		mapSelection: Binding<MKMapItem?>,
		results: [SearchResult],
		location: CLLocationCoordinate2D? = nil
	) {
		_cameraPosition = cameraPosition
		_mapSelection = mapSelection
		self.results = results
		self.userLocation = location
	}

	public var body: some View {
		Map(position: $cameraPosition, selection: $mapSelection) {
			if let userLocation {
				LocationAnnotation(coordinate: userLocation)
			}
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
		location: .init(latitude: 25.7602, longitude: -80.1959)
	)
}



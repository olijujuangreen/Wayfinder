//
//  LocationAnnotation.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import MapKit
import SwiftUI

struct LocationAnnotation: MapContent {
	private static let identifier: String = "LocationAnnotation"
	private let coordinate: CLLocationCoordinate2D

	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}

	var body: some MapContent {
		Annotation(
			LocationAnnotation.identifier,
			coordinate: coordinate,
			content: marker
		)
    }

	@ViewBuilder
	private func marker() -> some View {
		LocationMarker()
	}
}

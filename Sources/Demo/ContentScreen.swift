//
//  ContentScreen.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import Interface
import MapKit
import Models
import SwiftUI

extension MKCoordinateRegion {
	enum RegionRange {
		case close
		case standard
		case far

		var distance: CLLocationDistance {
			switch self {
			case .close:    500
			case .standard: 10_000
			case .far:      20_000
			}
		}
	}

	static func region(
		for location: CLLocationCoordinate2D,
		range: RegionRange = .standard
	) -> MKCoordinateRegion {
		MKCoordinateRegion(
			center: location,
			latitudinalMeters: range.distance,
			longitudinalMeters: range.distance
		)
	}
}

@MainActor
/// Demonstrates how to provide a resolved user coordinate when presenting `WFMap`.
struct ContentScreen {
	private let location: CLLocationCoordinate2D
	private let region: MKCoordinateRegion

	@State private var cameraPosition: MapCameraPosition
	@State private var searchText: String = ""
	@State private var results: [SearchResult] = []
	@State private var mapSelection: MKMapItem?
	@State private var isSheePresented: Bool = false

	init(location: CLLocationCoordinate2D) {
		let region = MKCoordinateRegion.region(for: location)

		self.location = location
		self.region = region
		_cameraPosition = State(initialValue: .region(region))
	}

	private func locationDetailSheet() -> some View {
		LocationDetails(
			mapSelection: $mapSelection,
			isSheetPresented: $isSheePresented
		)
		.presentationDetents([.height(340)])
		.presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
		.presentationCornerRadius(12)
	}

	private func mapControlsContent() -> some View {
		Group {
			MapCompass()
			MapPitchToggle()
			MapUserLocationButton()
		}
	}

	private func searchField() -> some View {
		TextField("Search...", text: $searchText)
			.font(.subheadline)
			.padding(12)
			.glassEffect()
			.padding(.horizontal)
	}

	private func submitSearch() {
		Task {
			let request = MKLocalSearch.Request()
			request.naturalLanguageQuery = searchText
			request.region = region

			let response = try? await MKLocalSearch(request: request).start()
			results = (response?.mapItems ?? []).map { SearchResult(item: $0) }
		}
	}

	private func mapSelectionDidChange
	<MapItem: Equatable>(with oldValue: MapItem?, newValue: MapItem?) {
		isSheePresented = newValue != nil
	}
}

extension ContentScreen: View {
	var body: some View {
		WFMap(
			cameraPosition: $cameraPosition,
			mapSelection: $mapSelection,
			results: results,
			location: location
		)
		.safeAreaInset(edge: .bottom, content: searchField)
		.onChange(of: mapSelection, mapSelectionDidChange)
		.sheet(isPresented: $isSheePresented, content: locationDetailSheet)
		.onSubmit(of: .text, submitSearch)
		.mapControls(mapControlsContent)
	}
}

#Preview {
	ContentScreen(location: .init(latitude: 33.7490, longitude: -84.3880))
}

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

extension CLLocationCoordinate2D {
	static var userLocation: CLLocationCoordinate2D {
		.init(latitude: 33.7490, longitude: -84.3880) // ATL hoe
	}
}

extension MKCoordinateRegion {
	static var userRegion: MKCoordinateRegion {
		.init(
			center: .userLocation,
			latitudinalMeters: 10_000,
			longitudinalMeters: 10_000
		)
	}
}

@MainActor
struct ContentScreen {
	@State private var cameraPosition: MapCameraPosition = .region(.userRegion)
	@State private var searchText: String = ""
	@State private var results: [SearchResult] = []
	@State private var mapSelection: MKMapItem?
	@State private var isSheePresented: Bool = false

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
			request.region = .userRegion

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
			results: results
		)
		.safeAreaInset(edge: .bottom, content: searchField)
		.onChange(of: mapSelection, mapSelectionDidChange)
		.sheet(isPresented: $isSheePresented, content: locationDetailSheet)
		.onSubmit(of: .text, submitSearch)
		.mapControls(mapControlsContent)
	}
}

#Preview {
	ContentScreen()
}

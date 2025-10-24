//
//  NavigationScreen+View.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import SwiftUI
import MapKit

@MainActor
extension NavigationScreen: View {
	public var body: some View {
		ZStack(alignment: .bottom) {
			mapView
			instructionOverlay
			errorBanner
		}
		.ignoresSafeArea()
		.task(start)
		.toolbar(.hidden, for: .navigationBar)
	}
}

// MARK: - Subviews
private extension NavigationScreen {
	@ViewBuilder
	var mapView: some View {
		Map(position: $cameraPosition) {
			if let route = coordinator.route {
				MapPolyline(route)
					.stroke(.blue, lineWidth: 6)
			}

			Marker("Destination", coordinate: destination.location.coordinate)
		}
		.mapStyle(.standard)
	}

	var instructionOverlay: some View {
		VStack(spacing: 8) {
			if let step = coordinator.currentStep {
				Text(step.instructions.isEmpty ? "Proceed to route" : step.instructions)
					.font(.title3.weight(.semibold))
					.multilineTextAlignment(.center)
					.padding(.horizontal)
					.frame(maxWidth: .infinity)
					.frame(height: 70)
					.background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
					.shadow(radius: 4)
			}

			Button("End Navigation", action: stop)
				.buttonStyle(.glassProminent)
				.padding(.bottom)
		}
		.padding(.horizontal)
	}

	@ViewBuilder
	var errorBanner: some View {
		if let error = coordinator.error {
			Text(error.localizedDescription)
				.font(.headline.weight(.semibold))
				.foregroundStyle(.white)
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity)
				.background(.red.gradient)
				.transition(.move(edge: .top).combined(with: .opacity))
		}
	}
}

#Preview {
	let coordinate = CLLocationCoordinate2D(latitude: 33.7488, longitude: -84.3881)
	let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
	let address = MKAddress(fullAddress: "Atlanta, Georgia", shortAddress: "Atlanta")

	let mapItem = MKMapItem(location: location, address: address)
	mapItem.name = "Atlanta City Center"

	return NavigationScreen(destination: mapItem)
}


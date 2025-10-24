//
//  LocationDetails+View.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import Contacts
import MapKit
import SwiftUI

@MainActor
extension LocationDetails: View {
	public var body: some View {
		VStack {
			header
			lookAroundView
			actionsView
		}
		.padding(.horizontal, 8)
		.onAppear(perform: fetchLookaroundPreview)
		.onChange(of: mapSelection) { _, _ in fetchLookaroundPreview() }
	}

	private var header: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(name)
					.font(.title2.weight(.semibold))

				Text(title)
					.font(.footnote)
					.foregroundStyle(.secondary)
					.lineLimit(2)
					.padding(.trailing)
			}

			Button(action: dismissSheet) {
				Image(systemName: "xmark.circle.fill")
					.font(.title2)
					.foregroundStyle(.separator)
			}
			.buttonStyle(.plain)
		}
	}

	@ViewBuilder
	private var lookAroundView: some View {
		if let lookAroundScene {
			LookAroundPreview(initialScene: lookAroundScene)
				.frame(height: 200)
				.clipShape(.rect(cornerRadius: 8))
				.padding()
		} else {
			ContentUnavailableView("No Preview available", image: "eye.slash")
		}
	}

	private var actionsView: some View {
		HStack(spacing: 50) {
			Button(action: {}) {
				Text("Directions")
					.font(.title2)
			}
			.buttonStyle(.glass)

			Button(action: {}) {
				Text("Navigate")
					.font(.title2)
			}
			.buttonStyle(.glassProminent)
		}
		.padding(.horizontal)
	}

	func dismissSheet() {
		isSheetPresented.toggle()
		mapSelection = nil
	}
}

import MapKit

#Preview {
	let coordinate = CLLocationCoordinate2D(latitude: 33.7488, longitude: -84.3881)
	let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
	let address = MKAddress(
		fullAddress: "123 Peachtree St NE, Atlanta, GA 30303, United States",
		shortAddress: "123 Peachtree St NE"
	)
	let mockMapItem = MKMapItem(location: location, address: address)
	mockMapItem.name = "Atlanta City Center"

	return LocationDetails(
		mapSelection: .constant(mockMapItem),
		isSheetPresented: .constant(true)
	)
}

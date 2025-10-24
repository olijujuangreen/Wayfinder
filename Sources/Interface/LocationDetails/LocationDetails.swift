//
//  File.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

@preconcurrency import MapKit
import SwiftUI

@MainActor
public struct LocationDetails {
	@Binding var mapSelection: MKMapItem?
	@Binding var isSheetPresented: Bool

	@State var lookAroundScene: MKLookAroundScene?

	var name: String { mapSelection?.name ?? "" }
	var title: String { mapSelection?.address?.fullAddress ?? "" }

	public init(mapSelection: Binding<MKMapItem?>, isSheetPresented: Binding<Bool>) {
		_mapSelection = mapSelection
		_isSheetPresented = isSheetPresented
	}

	func fetchLookaroundPreview() {
		if let mapSelection {
			lookAroundScene = nil
			print("Called")

			Task {
				let request = MKLookAroundSceneRequest(mapItem: mapSelection)
				lookAroundScene = try? await request.scene
				print("Successfully fetched scene")
			}
		}
	}
}

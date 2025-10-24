//
//  NavigationScreen.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import MapKit
import Core
import SwiftUI

@MainActor
public struct NavigationScreen {
	let destination: MKMapItem

	@State var cameraPosition: MapCameraPosition = .automatic
	@State var coordinator = NavigationCoordinator()

	public init(destination: MKMapItem) {
		self.destination = destination
	}

	func start() {
		Task { await coordinator.startNavigation(to: destination) }
	}

	func stop() {
		coordinator.stopNavigation()
	}
}

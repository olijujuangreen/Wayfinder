//
//  NavigationCoordinator.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import Observation
import MapKit
import CoreLocation
import AVFoundation

@MainActor
@Observable
public final class NavigationCoordinator {
	public private(set) var route: MKRoute?
	public private(set) var currentStep: MKRoute.Step?
	public private(set) var progress: Double = 0
	public private(set) var error: NavigationError?

	private let synthesizer = AVSpeechSynthesizer()
	private var stepIndex = 0
	private var isActive = false

	public init() {}

	// MARK: - Navigation Lifecycle

	public func startNavigation(to destination: MKMapItem) async {
		do {
			let route = try await calculateRoute(to: destination)
			self.route = route
			stepIndex = 0
			currentStep = route.steps.first
			isActive = true
			speakInstruction()
			try await trackProgress(for: route)
		} catch {
			handle(error)
		}
	}

	public func stopNavigation() {
		isActive = false
		synthesizer.stopSpeaking(at: .immediate)
		route = nil
		currentStep = nil
		progress = 0
		stepIndex = 0
	}

	private func calculateRoute(to destination: MKMapItem) async throws -> MKRoute {
		let source = MKMapItem.forCurrentLocation()
		let request = MKDirections.Request()
		request.source = source
		request.destination = destination
		request.transportType = .automobile

		let response = try await MKDirections(request: request).calculate()
		guard let route = response.routes.first else {
			throw NavigationError.noRouteFound
		}
		return route
	}

	private func trackProgress(for route: MKRoute) async throws {
		do {
			for try await update in CLLocationUpdate.liveUpdates() {
				guard isActive, let user = update.location else { continue }
				updateProgress(for: user, along: route)
				advanceStepIfNeeded(for: user, on: route)
			}
		} catch {
			throw NavigationError.locationUnavailable
		}
	}

	private func updateProgress(for user: CLLocation, along route: MKRoute) {
		let destination = CLLocation(
			latitude: route.polyline.coordinate.latitude,
			longitude: route.polyline.coordinate.longitude
		)
		progress = user.distance(from: destination)
	}

	private func advanceStepIfNeeded(for user: CLLocation, on route: MKRoute) {
		guard stepIndex < route.steps.count else { return }

		let step = route.steps[stepIndex]
		let target = CLLocation(
			latitude: step.polyline.coordinate.latitude,
			longitude: step.polyline.coordinate.longitude
		)

		if user.distance(from: target) < 20 {
			stepIndex += 1
			currentStep = route.steps[safe: stepIndex]
			speakInstruction()
		}
	}

	private func speakInstruction() {
		guard let instruction = currentStep?.instructions, !instruction.isEmpty else { return }
		let utterance = AVSpeechUtterance(string: instruction)
		utterance.voice = .init(language: "en-US")
		synthesizer.speak(utterance)
	}

	private func handle(_ error: Error) {
		switch error {
		case let navigationError as NavigationError: self.error = navigationError
		case let clError as CLError where clError.code == .denied: self.error = .permissionDenied
		default: self.error = .unknown(error)
		}

		stopNavigation()
	}
}


private extension Array {
	subscript(safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

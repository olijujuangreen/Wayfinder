//
//  NavigationError.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import Foundation

public enum NavigationError: LocalizedError, Equatable {
	case permissionDenied
	case locationUnavailable
	case noRouteFound
	case unknown(Error)

	public var errorDescription: String? {
		switch self {
		case .permissionDenied: "Location permission was denied."
		case .locationUnavailable: "Location updates are unavailable."
		case .noRouteFound: "No route could be calculated for the given destination."
		case .unknown(let error): "An unexpected error occurred: \(error.localizedDescription)"
		}
	}

	public static func == (lhs: NavigationError, rhs: NavigationError) -> Bool {
		switch (lhs, rhs) {
		case (.permissionDenied, .permissionDenied),
			 (.locationUnavailable, .locationUnavailable),
			 (.noRouteFound, .noRouteFound): true
		case (.unknown, .unknown): true
		default: false
		}
	}
}

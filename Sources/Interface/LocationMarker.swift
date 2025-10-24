//
//  LocationMarker.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import SwiftUI

public struct LocationMarker: View {
	public enum Style {
		case standard(Size)
		case focused(Size)
		case minimal

		var configuration: Configuration {
			switch self {
			case .standard(let size):
				Configuration(
					rings: [
						(.blue.opacity(0.25), size.outerDiameter),
						(.white, 20),
						(.blue, 12)
					]
				)

			case .focused(let size):
				Configuration(
					rings: [
						(.blue.opacity(0.50), size.outerDiameter + 20),
						(.white, 24),
						(.blue, 14)
					]
				)

			case .minimal:
				Configuration(rings: [(.blue, 14)])
			}
		}
	}

	public enum Size {
		case small
		case medium
		case large

		var outerDiameter: CGFloat {
			switch self {
			case .small: 60
			case .medium: 100
			case .large: 140
			}
		}
	}

	struct Configuration {
		let rings: [(color: Color, diameter: CGFloat)]
	}

	private let style: Style

	public init(_ style: Style = .standard(.medium)) {
		self.style = style
	}

	public var body: some View {
		ZStack {
			ForEach(Array(style.configuration.rings.enumerated()), id: \.offset) { _, ring in
				Circle()
					.frame(width: ring.diameter, height: ring.diameter)
					.foregroundStyle(ring.color)
			}
		}
	}
}

#Preview("Standard - Small") {
	LocationMarker(.standard(.small))
}

#Preview("Standard - Medium") {
	LocationMarker(.standard(.medium))
}

#Preview("Standard - Large") {
	LocationMarker(.standard(.large))
}

#Preview("Focused - Small") {
	LocationMarker(.focused(.small))
}

#Preview("Focused - Medium") {
	LocationMarker(.focused(.medium))
}

#Preview("Focused - Large") {
	LocationMarker(.focused(.large))
}

#Preview("Minimal") {
	LocationMarker(.minimal)
}

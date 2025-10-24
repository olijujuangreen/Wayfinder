//
//  SearchResultContent.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import MapKit
import Models
import SwiftUI

struct SearchResultContent: MapContent {
	private let results: [SearchResult]

	init(results: [SearchResult]) {
		self.results = results
	}

	var body: some MapContent {
		ForEach(results) { result in
			marker(for: result.item)
		}
    }

	private func marker(for item: MKMapItem) -> some MapContent {
		let title = item.name ?? item.address?.shortAddress ?? "Unknown"
		return Marker(title, coordinate: item.location.coordinate).tag(item)
	}
}

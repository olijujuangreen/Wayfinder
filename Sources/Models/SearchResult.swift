//
//  SearchResult.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import Foundation
import MapKit

public struct SearchResult: Identifiable, Hashable {
	public let id = UUID()
	public let item: MKMapItem

	public init(item: MKMapItem) {
		self.item = item
	}
}

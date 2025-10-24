//
//  SearchField.swift
//  Wayfinder
//
//  Created by Olijujuan Green on 10/24/25.
//

import SwiftUI

struct SearchField: View {
	@Binding var searchText: String
	private let placeholder: LocalizedStringKey

	init(searchText: Binding<String>, placeholder: LocalizedStringKey = "Search") {
		_searchText = searchText
		self.placeholder = placeholder
	}

    var body: some View {
		TextField(placeholder, text: $searchText)
			.font(.subheadline)
			.padding(12)
			.glassEffect()
    }
}

#Preview {
	@Previewable @State var searchText: String = ""
	SearchField(searchText: $searchText)
}

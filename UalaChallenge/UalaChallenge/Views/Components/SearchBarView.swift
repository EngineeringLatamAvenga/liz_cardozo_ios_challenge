//
//  SearchBarView.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        TextField("Search...", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

#Preview {
    SearchBarView(text: .constant("Hello Search Bar"))
}

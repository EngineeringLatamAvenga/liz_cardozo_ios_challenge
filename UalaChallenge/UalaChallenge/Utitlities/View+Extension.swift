//
//  View+Extension.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 28/01/2025.
//

import SwiftUI

extension View {
    func commonOverlay(isLoading: Bool) -> some View {
        self.overlay(
            Group {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView()
                          
                    }
                    .transition(.opacity)
                }
            }
        )
    }
}

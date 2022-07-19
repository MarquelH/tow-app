//
//  ClearButtonModifier.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/16/22.
//

import Foundation
import SwiftUI
import Combine

public struct ClearButton: ViewModifier {
    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.secondary)
                .opacity(text == "" ? 0 : 1)
                .onTapGesture { self.text = "" } // onTapGesture or plainStyle button
        }
    }
}

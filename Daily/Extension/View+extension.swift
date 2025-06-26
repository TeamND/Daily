//
//  View+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI

// MARK: - Frame Modifier
extension View {
    func vTop() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    func vCenter() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    func vBottom() -> some View {
        self.frame(maxHeight: .infinity, alignment: .bottom)
    }
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func getFrame(in coordinateSpace: CoordinateSpace = .named("goalView"), returnFunc: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { returnFunc(geo.frame(in: coordinateSpace)) }
                    .onChange(of: geo.frame(in: coordinateSpace)) { returnFunc($1) }
            }
        )
    }
}

// MARK: - Keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


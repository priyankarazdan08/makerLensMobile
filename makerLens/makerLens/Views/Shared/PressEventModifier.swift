//
//  PressEventModifier.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/1/25.
//


import SwiftUI

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onPress()
                }
                .onEnded { _ in
                    onRelease()
                }
        )
    }
}



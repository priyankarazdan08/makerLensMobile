//
//  ContentView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseService.shared)
}

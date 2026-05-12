//
//  ContentView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = TravelAppState()
    @StateObject private var tabCoordinator = TabCoordinator()

    var body: some View {
        Group {
            if appState.hasSeenOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .environmentObject(appState)
        .environmentObject(tabCoordinator)
    }
}

#Preview {
    ContentView()
}

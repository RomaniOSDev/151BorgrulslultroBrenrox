//
//  ExploreRootView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct ExploreRootView: View {
    @EnvironmentObject private var appState: TravelAppState

    var body: some View {
        NavigationStack {
            ActivitySelectionView()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color.appAccent)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        .accessibilityLabel(Text("Settings"))
                    }
                }
        }
        .tint(Color.appPrimary)
    }
}

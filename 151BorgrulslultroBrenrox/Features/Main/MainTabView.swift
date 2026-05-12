//
//  MainTabView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

enum MainTab: Int, CaseIterable, Identifiable {
    case home = 0
    case explore = 1
    case collections = 2
    case journeys = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .collections: return "Collections"
        case .journeys: return "Journeys"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .explore: return "globe.europe.africa.fill"
        case .collections: return "square.grid.2x2.fill"
        case .journeys: return "point.topleft.down.curvedto.point.bottomright.up"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator
    @State private var selection: MainTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selection {
                case .home:
                    HomeView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.28)))
                case .explore:
                    ExploreRootView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.28)))
                case .collections:
                    CollectionsView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.28)))
                case .journeys:
                    JourneysView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.28)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 72)

            VStack(spacing: 0) {
                Divider().overlay(Color.appTextSecondary.opacity(0.25))
                HStack {
                    ForEach(MainTab.allCases) { tab in
                        Button {
                            withAnimation(.easeInOut(duration: 0.28)) {
                                selection = tab
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: tab.systemImage)
                                    .font(.system(size: 20, weight: .bold))
                                Text(tab.title)
                                    .font(.caption2.weight(.bold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .overlay(alignment: .bottom) {
                                if selection == tab {
                                    Capsule()
                                        .fill(Color.appPrimary)
                                        .frame(height: 3)
                                        .padding(.horizontal, 18)
                                        .transition(.opacity)
                                }
                            }
                        }
                        .accessibilityLabel(Text(tab.title))
                        .foregroundStyle(selection == tab ? Color.appPrimary : Color.appTextSecondary)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appSurface.opacity(0.99),
                                Color.appSurface.opacity(0.82)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.appTextPrimary.opacity(0.09), lineWidth: 1)
                    }
                    .shadow(color: Color.appTextPrimary.opacity(0.1), radius: 14, x: 0, y: 5)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 6)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onChange(of: tabCoordinator.focusTab) { tab in
            guard let tab else { return }
            withAnimation(.easeInOut(duration: 0.28)) {
                selection = tab
            }
            DispatchQueue.main.async {
                tabCoordinator.focusTab = nil
            }
        }
    }
}

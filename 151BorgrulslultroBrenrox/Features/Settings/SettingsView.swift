//
//  SettingsView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI
import UIKit
import StoreKit

struct SettingsView: View {
    @EnvironmentObject private var appState: TravelAppState
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(spacing: 0) {
                    legalRow(title: "Rate us", symbol: "star.fill") {
                        rateApp()
                    }
                    Divider().opacity(0.25)
                    legalRow(title: "Privacy Policy", symbol: "hand.raised.fill") {
                        openPolicy(AppExternalLink.privacyPolicy)
                    }
                    Divider().opacity(0.25)
                    legalRow(title: "Terms of Use", symbol: "doc.text.fill") {
                        openPolicy(AppExternalLink.termsOfUse)
                    }
                }
                .padding(.vertical, 4)
                .appDepthSurface(cornerRadius: 16, shadow: .soft)

                Text("Insights")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                VStack(alignment: .leading, spacing: 12) {
                    statRow(title: "Total stars", value: "\(appState.totalStars)")
                    statRow(title: "Exploration streak", value: "\(appState.culturalStreak)")
                    statRow(title: "Mapped anchors", value: "\(appState.mappedLocations)")
                    statRow(title: "Cartographer stages cleared", value: "\(appState.cartographerStagesCleared)")
                    statRow(title: "Silhouette lattices cleared", value: "\(appState.silhouetteStagesCleared)")
                    statRow(title: "Field notes saved", value: "\(appState.journalEntries.count)")
                    statRow(title: "Weekly trio steps (this week)", value: "\(appState.routeOfWeekCompletedSteps)/3")
                    statRow(title: "Logged sessions", value: "\(appState.sessionLog.count)")
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .appDepthSurface(cornerRadius: 16, shadow: .soft)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Accolades")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    if appState.activeAchievements.isEmpty {
                        Text("Complete routes to reveal accolades tied to your data.")
                            .font(.footnote)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(3)
                            .minimumScaleFactor(0.7)
                    } else {
                        ForEach(appState.activeAchievements, id: \.self) { item in
                            Text(item.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color.appAccent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .appDepthSurface(cornerRadius: 16, shadow: .soft)

                Button {
                    showResetConfirm = true
                } label: {
                    Text("Reset All Progress")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .appDepthSurface(cornerRadius: 14, shadow: .soft, stroke: Color.appAccent.opacity(0.45))
                }
            }
            .padding(16)
        }
        .appDepthScrollBackdrop()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
        .alert("Reset all progress?", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                appState.resetAllProgress()
                dismiss()
            }
        } message: {
            Text("This clears stars, routes, habits, packing, and onboarding status on this device.")
        }
    }

    private func openPolicy(_ link: AppExternalLink) {
        if let url = URL(string: link.rawValue) {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    private func legalRow(title: String, symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: symbol)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 28, alignment: .center)
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary.opacity(0.7))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer()
            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

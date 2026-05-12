//
//  ActivityResultView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct ActivityOutcome: Identifiable, Equatable {
    let id: String
    let headline: String
    let detail: String
    let stars: Int
    let preview: String
    let cultureTip: String?
}

struct ActivityResultView: View {
    let outcome: ActivityOutcome
    var onReplay: () -> Void
    var onNextCollection: () -> Void

    @State private var bannerOffset: CGFloat = -140
    @State private var starScales: [CGFloat] = [0.2, 0.2, 0.2]

    var body: some View {
        ZStack {
            AppDepthStyle.screenBackdrop
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    Text("Summary ready")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appTextSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(Color.appSurface.opacity(0.9))
                        )
                        .offset(y: bannerOffset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.45)) {
                                bannerOffset = 0
                            }
                        }

                    Text(outcome.headline)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)

                    Text(outcome.detail)
                        .font(.body)
                        .foregroundStyle(Color.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .minimumScaleFactor(0.7)

                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < outcome.stars ? "star.fill" : "star")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(index < outcome.stars ? Color.appAccent : Color.appTextSecondary.opacity(0.35))
                                .scaleEffect(index < starScales.count ? starScales[index] : 1)
                                .onAppear {
                                    animateStars()
                                }
                        }
                    }
                    .padding(.vertical, 8)

                    if let tip = outcome.cultureTip {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cultural note")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color.appTextSecondary)
                            Text(tip)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Color.appTextPrimary)
                                .lineLimit(8)
                                .minimumScaleFactor(0.7)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .appDepthSurface(cornerRadius: 16, shadow: .soft)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming focus")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Color.appTextSecondary)
                        Text(outcome.preview)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(4)
                            .minimumScaleFactor(0.7)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appDepthSurface(cornerRadius: 16, shadow: .soft)

                    Button(action: onReplay) {
                        Text("Replay")
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .buttonStyle(AppPrimaryButtonStyle())

                    Button(action: onNextCollection) {
                        Text("Next Collection")
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .buttonStyle(AppSecondaryButtonStyle())
                }
                .padding(16)
            }
        }
    }

    private func animateStars() {
        for index in 0..<min(outcome.stars, 3) {
            withAnimation(
                Animation.spring(response: 0.48, dampingFraction: 0.62)
                    .delay(Double(index) * 0.08)
            ) {
                if index < starScales.count {
                    starScales[index] = 1.05
                }
            }
            withAnimation(
                Animation.easeInOut(duration: 0.35)
                    .delay(Double(index) * 0.08 + 0.05)
            ) {
                if index < starScales.count {
                    starScales[index] = 1
                }
            }
        }
    }
}

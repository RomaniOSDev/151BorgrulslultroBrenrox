//
//  OnboardingView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: TravelAppState
    @State private var page = 0
    @State private var iconPulse = false

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeBottom = geometry.safeAreaInsets.bottom
            let safeTop = geometry.safeAreaInsets.top

            TabView(selection: $page) {
                onboardingPageOne(containerSize: size, safeTop: safeTop, safeBottom: safeBottom)
                    .tag(0)
                onboardingPageTwo(containerSize: size, safeTop: safeTop, safeBottom: safeBottom)
                    .tag(1)
                onboardingPageThree(containerSize: size, safeTop: safeTop, safeBottom: safeBottom)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(width: size.width, height: size.height)
            .animation(.easeInOut(duration: 0.35), value: page)
        }
        .ignoresSafeArea()
        .background(AppDepthStyle.screenBackdrop.ignoresSafeArea())
    }

    private func onboardingPageOne(containerSize: CGSize, safeTop: CGFloat, safeBottom: CGFloat) -> some View {
        let illustrationHeight = max(232, containerSize.height * 0.36)
        return VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: max(12, safeTop))

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: false)) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    let shift = CGFloat(sin(t * 0.55)) * 9
                    urbanDiorama(width: w, height: h, parallax: shift)
                }
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            .frame(height: illustrationHeight)
            .padding(10)
            .appDepthSurface(cornerRadius: 24, shadow: .lifted)

            Spacer(minLength: 14)

            copyCard(
                step: 1,
                total: 3,
                symbol: "point.topleft.down.curvedto.point.bottomright.up",
                title: "Chart living layers",
                caption: "Skylines, markets, and paths stack into a personal atlas—short sessions, clear depth."
            )

            Spacer(minLength: 12)

            continueButton {
                withAnimation(.easeInOut(duration: 0.35)) {
                    page = 1
                }
            }
            .padding(.bottom, max(16, safeBottom + 8))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func urbanDiorama(width: CGFloat, height: CGFloat, parallax: CGFloat) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appSurface.opacity(0.5),
                    Color.appPrimary.opacity(0.12),
                    Color.appAccent.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Path { p in
                p.move(to: CGPoint(x: 0, y: height * 0.72))
                p.addLine(to: CGPoint(x: width, y: height * 0.72))
            }
            .stroke(Color.appAccent.opacity(0.4), lineWidth: 3)

            ForEach(0..<6, id: \.self) { i in
                let baseX = width * (0.12 + CGFloat(i) * 0.14)
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.appPrimary.opacity(0.35 + Double(i) * 0.05))
                    .frame(width: 22 + CGFloat(i % 3) * 6, height: 40 + CGFloat(i % 2) * 18)
                    .offset(x: baseX + parallax * (0.2 + CGFloat(i) * 0.05) - width * 0.5,
                            y: height * 0.36 - CGFloat(i) * 6)
            }

            Path { p in
                p.move(to: CGPoint(x: width * 0.2 + parallax, y: height * 0.28))
                p.addLine(to: CGPoint(x: width * 0.45 + parallax * 0.6, y: height * 0.18))
                p.addLine(to: CGPoint(x: width * 0.7 + parallax * 0.3, y: height * 0.26))
            }
            .stroke(Color.appAccent, style: StrokeStyle(lineWidth: 2, lineJoin: .round))

            Circle()
                .fill(Color.appAccent.opacity(0.28))
                .frame(width: height * 0.22, height: height * 0.22)
                .offset(x: width * 0.25 + parallax * 0.4, y: -height * 0.08)

            Image(systemName: "sun.max.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.appAccent.opacity(0.55))
                .offset(x: width * 0.32, y: -height * 0.28)
        }
        .frame(width: width, height: height)
    }

    private func onboardingPageTwo(containerSize: CGSize, safeTop: CGFloat, safeBottom: CGFloat) -> some View {
        let illustrationHeight = max(232, containerSize.height * 0.36)
        return VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: max(12, safeTop))

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                historicMapLayer(width: w, height: h)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            .frame(height: illustrationHeight)
            .padding(10)
            .appDepthSurface(cornerRadius: 24, shadow: .lifted)

            Spacer(minLength: 14)

            copyCard(
                step: 2,
                total: 3,
                symbol: "map.fill",
                title: "Follow hidden threads",
                caption: "Lattice stories and weekly habits snap into one rhythm—Home keeps the pulse visible."
            )

            Spacer(minLength: 12)

            continueButton {
                withAnimation(.easeInOut(duration: 0.35)) {
                    page = 2
                }
            }
            .padding(.bottom, max(16, safeBottom + 8))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func historicMapLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appSurface.opacity(0.55),
                    Color.appAccent.opacity(0.1),
                    Color.appSurface.opacity(0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ForEach(0..<10, id: \.self) { r in
                Path { p in
                    let y = height * (0.1 + CGFloat(r) * 0.08)
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: width, y: y))
                }
                .stroke(Color.appTextSecondary.opacity(0.12), lineWidth: 1)
            }
            ForEach(0..<8, id: \.self) { c in
                Path { p in
                    let x = width * (0.08 + CGFloat(c) * 0.11)
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x, y: height))
                }
                .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
            }

            Path { p in
                p.move(to: CGPoint(x: width * 0.12, y: height * 0.72))
                p.addQuadCurve(
                    to: CGPoint(x: width * 0.88, y: height * 0.3),
                    control: CGPoint(x: width * 0.55, y: height * 0.9)
                )
                p.addQuadCurve(
                    to: CGPoint(x: width * 0.78, y: height * 0.18),
                    control: CGPoint(x: width * 0.95, y: height * 0.12)
                )
            }
            .stroke(Color.appAccent.opacity(0.55), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .strokeBorder(Color.appPrimary.opacity(0.45), lineWidth: 2)
                    .background(Circle().fill(Color.appSurface.opacity(0.4)))
                    .frame(width: 16, height: 16)
                    .offset(
                        x: width * (0.2 + CGFloat(i) * 0.14) - width * 0.5,
                        y: height * (0.35 + CGFloat(i % 2) * 0.12) - height * 0.5
                    )
            }

            Image(systemName: "location.fill")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color.appPrimary.opacity(0.65))
                .offset(x: width * 0.08, y: -height * 0.22)
        }
    }

    private func onboardingPageThree(containerSize: CGSize, safeTop: CGFloat, safeBottom: CGFloat) -> some View {
        let iconsHeight = max(200, containerSize.height * 0.3)
        return VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: max(12, safeTop))

            ZStack {
                LinearGradient(
                    colors: [
                        Color.appPrimary.opacity(0.22),
                        Color.appSurface.opacity(0.88),
                        Color.appAccent.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                HStack(spacing: 22) {
                    culturalIcon(symbol: "triangle.fill", rotation: iconPulse ? 12 : -6)
                    culturalIcon(symbol: "diamond.fill", rotation: iconPulse ? -10 : 8)
                    culturalIcon(symbol: "circle.grid.3x3.fill", rotation: iconPulse ? 6 : -4)
                }
                .padding(28)
            }
            .frame(height: iconsHeight)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.appAccent.opacity(0.35), Color.appTextPrimary.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.appTextPrimary.opacity(0.1), radius: 16, x: 0, y: 7)
            .padding(10)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    iconPulse.toggle()
                }
            }

            Spacer(minLength: 14)

            copyCard(
                step: 3,
                total: 3,
                symbol: "sparkles",
                title: "Open your studio",
                caption: "Home for momentum, Explore for the three labs—tap Continue and start in one flow."
            )

            Spacer(minLength: 12)

            continueButton {
                withAnimation(.easeInOut) {
                    appState.markOnboardingFinished()
                }
            }
            .padding(.bottom, max(16, safeBottom + 8))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func copyCard(step: Int, total: Int, symbol: String, title: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: symbol)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.appPrimary.opacity(0.2))
                    )
                Text("Step \(step) of \(total)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(Color.appTextSecondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer(minLength: 0)
            }

            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.75)

            Text(caption)
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(4)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 22, shadow: .soft)
    }

    private func continueButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text("Continue")
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .buttonStyle(AppPrimaryButtonStyle())
        .padding(.horizontal, 0)
        .frame(minHeight: 44)
    }

    private func culturalIcon(symbol: String, rotation: Double) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 40, weight: .bold))
            .foregroundStyle(Color.appAccent)
            .rotationEffect(.degrees(rotation))
            .frame(width: 64, height: 64)
            .background(
                Circle()
                    .fill(Color.appBackground.opacity(0.35))
            )
            .accessibilityHidden(true)
    }
}

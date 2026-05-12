//
//  CultureCartographerView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct CultureCartographerView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator
    @Environment(\.dismiss) private var dismiss

    @StateObject private var model: CultureCartographerViewModel
    @State private var outcome: ActivityOutcome?

    init(stageIndex: Int) {
        _model = StateObject(wrappedValue: CultureCartographerViewModel(stageIndex: stageIndex))
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Culture Cartographer")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("Drag between glowing anchors in ascending order before the timer fades.")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)

                    Picker("Pace", selection: $model.pace) {
                        ForEach(CultureCartographerViewModel.Pace.allCases) { pace in
                            Text(pace.title).tag(pace)
                        }
                    }
                    .pickerStyle(.segmented)
                    .disabled(model.phase != .idle && model.phase != .running)

                    HStack {
                        Label {
                            Text("Timer")
                                .foregroundStyle(Color.appTextSecondary)
                        } icon: {
                            Image(systemName: "hourglass")
                                .foregroundStyle(Color.appAccent)
                        }
                        Spacer()
                        Text(timeString(from: model.secondsRemaining))
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .padding(.horizontal, 4)

                    GeometryReader { geo in
                        let size = geo.size
                        ZStack {
                            cartographerCanvas(for: size)
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            model.updateDrag(location: value.location, canvasSize: size)
                                        }
                                        .onEnded { value in
                                            model.finalizeDrag(at: value.location, in: size)
                                        }
                                )
                        }
                    }
                    .frame(height: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color.appTextPrimary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.appTextPrimary.opacity(0.07), radius: 12, x: 0, y: 5)

                    HStack {
                        Label("Segments", systemImage: "point.connected.to.point.curvepath")
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                        Text("\(model.segmentsCompleted)/\(model.requiredSegments)")
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    HStack {
                        Label("Corrections", systemImage: "arrow.triangle.2.circlepath")
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                        Text("\(model.wrongMoves)")
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
                .padding(16)
            }
            .appDepthScrollBackdrop()

            if let outcome {
                ActivityResultView(
                    outcome: outcome,
                    onReplay: {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                            self.outcome = nil
                        }
                        model.resetBoard()
                    },
                    onNextCollection: {
                        tabCoordinator.requestTab(.collections)
                        dismiss()
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: model.phase) { newPhase in
            guard outcome == nil else { return }
            switch newPhase {
            case .won:
                let stars = model.starsEarned()
                appState.registerCartographerCompletion(levelIndex: model.stageIndex, stars: stars)
                outcome = ActivityOutcome(
                    id: UUID().uuidString,
                    headline: "Atlas route complete",
                    detail: "Sequential anchors stayed true to the historic curve.",
                    stars: stars,
                    preview: "Collections tab reveals newly eligible thematic decks.",
                    cultureTip: CultureTipsProvider.tip(for: .cartographer, variant: model.stageIndex)
                )
            case .lost:
                outcome = ActivityOutcome(
                    id: UUID().uuidString,
                    headline: "Timer reached silence",
                    detail: "The trail paused before every anchor linked.",
                    stars: 0,
                    preview: "Switch to a relaxed pace or shorten gestures for cleaner hits.",
                    cultureTip: CultureTipsProvider.tip(for: .cartographer, variant: model.stageIndex + 4)
                )
            default:
                break
            }
        }
        .animation(.easeInOut(duration: 0.35), value: outcome?.id)
    }

    private func timeString(from value: TimeInterval) -> String {
        let clamped = max(0, Int(ceil(value)))
        let minutes = clamped / 60
        let seconds = clamped % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func cartographerCanvas(for size: CGSize) -> some View {
        Canvas { context, canvasSize in
            let water = Path(roundedRect: CGRect(origin: .zero, size: canvasSize), cornerRadius: 18)
            context.fill(water, with: .color(Color.appSurface.opacity(0.65)))

            var landmass = Path()
            landmass.move(to: CGPoint(x: canvasSize.width * 0.05, y: canvasSize.height * 0.55))
            landmass.addQuadCurve(
                to: CGPoint(x: canvasSize.width * 0.45, y: canvasSize.height * 0.35),
                control: CGPoint(x: canvasSize.width * 0.2, y: canvasSize.height * 0.25)
            )
            landmass.addQuadCurve(
                to: CGPoint(x: canvasSize.width * 0.92, y: canvasSize.height * 0.6),
                control: CGPoint(x: canvasSize.width * 0.75, y: canvasSize.height * 0.2)
            )
            landmass.addLine(to: CGPoint(x: canvasSize.width * 0.95, y: canvasSize.height * 0.95))
            landmass.addLine(to: CGPoint(x: canvasSize.width * 0.08, y: canvasSize.height * 0.92))
            landmass.closeSubpath()
            context.fill(landmass, with: .color(Color.appPrimary.opacity(0.25)))

            let fractions = model.siteFractions
            func center(for index: Int) -> CGPoint {
                let f = fractions[index]
                return CGPoint(x: f.x * canvasSize.width, y: f.y * canvasSize.height)
            }

            if model.segmentsCompleted > 0 {
                for index in 0..<(model.segmentsCompleted) {
                    var segment = Path()
                    segment.move(to: center(for: index))
                    segment.addLine(to: center(for: index + 1))
                    context.stroke(segment, with: .color(Color.appAccent), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                }
            }

            if let from = model.anchorFromIndex, let drag = model.dragPoint {
                var live = Path()
                live.move(to: center(for: from))
                live.addLine(to: drag)
                context.stroke(live, with: .color(Color.appAccent.opacity(0.65)), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 6]))
            }

            for index in 0..<fractions.count {
                let point = center(for: index)
                let rect = CGRect(x: point.x - 10, y: point.y - 10, width: 20, height: 20)
                let circle = Path(ellipseIn: rect)
                let fillColor = index <= model.segmentsCompleted ? Color.appPrimary : Color.appSurface
                context.fill(circle, with: .color(fillColor))
                context.stroke(circle, with: .color(Color.appAccent), style: StrokeStyle(lineWidth: 2))
            }
        }
        .background(Color.appBackground.opacity(0.01))
    }
}

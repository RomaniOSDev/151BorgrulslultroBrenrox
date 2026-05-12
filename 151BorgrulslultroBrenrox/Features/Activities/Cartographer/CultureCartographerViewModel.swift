//
//  CultureCartographerViewModel.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI
import Combine

final class CultureCartographerViewModel: ObservableObject {
    enum Pace: String, CaseIterable, Identifiable {
        case relaxed
        case steady
        case focused

        var id: String { rawValue }

        var title: String {
            switch self {
            case .relaxed: return "Relaxed"
            case .steady: return "Steady"
            case .focused: return "Focused"
            }
        }

        var timeLimit: TimeInterval {
            switch self {
            case .relaxed: return 90
            case .steady: return 60
            case .focused: return 40
            }
        }

        func captureRadius(base: CGFloat) -> CGFloat {
            switch self {
            case .relaxed: return base * 1.25
            case .steady: return base
            case .focused: return base * 0.78
            }
        }
    }

    enum Phase: Equatable {
        case idle
        case running
        case won
        case lost
    }

    let stageIndex: Int

    @Published var pace: Pace = .relaxed {
        didSet { if phase == .idle { secondsRemaining = pace.timeLimit } }
    }

    @Published private(set) var segmentsCompleted: Int = 0
    @Published private(set) var wrongMoves: Int = 0
    @Published private(set) var secondsRemaining: TimeInterval
    @Published private(set) var phase: Phase = .idle
    @Published var dragPoint: CGPoint?
    @Published private(set) var anchorFromIndex: Int?

    private var timerCancellable: AnyCancellable?

    init(stageIndex: Int) {
        self.stageIndex = stageIndex
        self.secondsRemaining = Pace.relaxed.timeLimit
    }

    var requiredSegments: Int {
        max(0, siteFractions.count - 1)
    }

    func resetBoard() {
        timerCancellable?.cancel()
        timerCancellable = nil
        segmentsCompleted = 0
        wrongMoves = 0
        secondsRemaining = pace.timeLimit
        phase = .idle
        dragPoint = nil
        anchorFromIndex = nil
    }

    func beginClockIfNeeded() {
        guard phase == .idle else { return }
        phase = .running
        secondsRemaining = pace.timeLimit
        startTimer()
    }

    func cancelDrag() {
        dragPoint = nil
        anchorFromIndex = nil
    }

    func updateDrag(location: CGPoint?, canvasSize: CGSize) {
        if location != nil, phase == .idle {
            beginClockIfNeeded()
        }
        dragPoint = location
        guard let location else {
            anchorFromIndex = nil
            return
        }
        if anchorFromIndex == nil {
            if let hit = indexHit(at: location, in: canvasSize), hit == segmentsCompleted {
                anchorFromIndex = hit
            }
        }
    }

    func finalizeDrag(at location: CGPoint, in canvasSize: CGSize) {
        defer {
            dragPoint = nil
            anchorFromIndex = nil
        }
        guard phase == .running || phase == .idle else { return }
        if phase == .idle {
            beginClockIfNeeded()
        }
        guard phase == .running else { return }

        guard let from = anchorFromIndex else { return }
        guard let to = indexHit(at: location, in: canvasSize) else {
            if from != segmentsCompleted {
                wrongMoves += 1
            }
            return
        }

        if from == segmentsCompleted && to == segmentsCompleted + 1 {
            segmentsCompleted += 1
            if segmentsCompleted >= requiredSegments {
                finishWin()
            }
        } else if from != to {
            wrongMoves += 1
        }
    }

    func starsEarned() -> Int {
        let limit = pace.timeLimit
        let ratio = limit > 0 ? secondsRemaining / limit : 0
        if wrongMoves == 0 && ratio > 0.35 {
            return 3
        }
        if wrongMoves <= 1 {
            return 2
        }
        return 1
    }

    private func finishWin() {
        phase = .won
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func finishLoss() {
        phase = .lost
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func startTimer() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.phase == .running else { return }
                self.secondsRemaining -= 1
                if self.secondsRemaining <= 0 {
                    self.secondsRemaining = 0
                    self.finishLoss()
                }
            }
    }

    private func indexHit(at point: CGPoint, in size: CGSize) -> Int? {
        let radius = pace.captureRadius(base: min(size.width, size.height) * 0.06)
        for (idx, fraction) in siteFractions.enumerated() {
            let center = CGPoint(x: fraction.x * size.width, y: fraction.y * size.height)
            let dist = hypot(point.x - center.x, point.y - center.y)
            if dist <= radius {
                return idx
            }
        }
        return nil
    }

    var siteFractions: [CGPoint] {
        CultureCartographerViewModel.layout(for: stageIndex)
    }

    private static func layout(for stage: Int) -> [CGPoint] {
        let presets: [[CGPoint]] = [
            [CGPoint(x: 0.18, y: 0.35), CGPoint(x: 0.42, y: 0.22), CGPoint(x: 0.68, y: 0.34), CGPoint(x: 0.52, y: 0.62)],
            [CGPoint(x: 0.2, y: 0.28), CGPoint(x: 0.45, y: 0.42), CGPoint(x: 0.72, y: 0.3), CGPoint(x: 0.6, y: 0.58), CGPoint(x: 0.32, y: 0.7)],
            [CGPoint(x: 0.22, y: 0.24), CGPoint(x: 0.5, y: 0.2), CGPoint(x: 0.78, y: 0.32), CGPoint(x: 0.64, y: 0.55), CGPoint(x: 0.38, y: 0.62), CGPoint(x: 0.24, y: 0.46)],
            [CGPoint(x: 0.18, y: 0.3), CGPoint(x: 0.38, y: 0.2), CGPoint(x: 0.58, y: 0.26), CGPoint(x: 0.78, y: 0.36), CGPoint(x: 0.66, y: 0.58), CGPoint(x: 0.42, y: 0.68), CGPoint(x: 0.22, y: 0.58)],
            [CGPoint(x: 0.16, y: 0.26), CGPoint(x: 0.36, y: 0.2), CGPoint(x: 0.56, y: 0.22), CGPoint(x: 0.76, y: 0.3), CGPoint(x: 0.7, y: 0.52), CGPoint(x: 0.48, y: 0.66), CGPoint(x: 0.26, y: 0.62), CGPoint(x: 0.2, y: 0.44)]
        ]
        let index = min(max(stage, 0), presets.count - 1)
        return presets[index]
    }
}

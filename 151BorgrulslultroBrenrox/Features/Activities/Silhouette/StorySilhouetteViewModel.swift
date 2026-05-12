//
//  StorySilhouetteViewModel.swift
//  151BorgrulslultroBrenrox
//

import Combine

final class StorySilhouetteViewModel: ObservableObject {
    let puzzleIndex: Int
    let columns = 5
    let rows = 5

    @Published private(set) var revealed: Set<Int>
    @Published private(set) var strayTaps: Int
    @Published private(set) var finished: Bool

    init(puzzleIndex: Int) {
        self.puzzleIndex = puzzleIndex
        self.revealed = []
        self.strayTaps = 0
        self.finished = false
    }

    var storyIndices: Set<Int> {
        Set(Self.masks[min(max(puzzleIndex, 0), Self.masks.count - 1)])
    }

    func reset() {
        revealed.removeAll()
        strayTaps = 0
        finished = false
    }

    func tapTile(flatIndex: Int) {
        guard !finished else { return }
        if revealed.contains(flatIndex) {
            return
        }
        if storyIndices.contains(flatIndex) {
            revealed.insert(flatIndex)
            if storyIndices.isSubset(of: revealed) {
                finished = true
            }
        } else {
            strayTaps += 1
        }
    }

    func starsEarned() -> Int {
        if strayTaps == 0 {
            return 3
        }
        if strayTaps <= 2 {
            return 2
        }
        return 1
    }

    private static let masks: [[Int]] = [
        [6, 7, 8, 11, 12, 13, 16, 17, 18],
        [0, 1, 2, 3, 4, 5, 9, 10, 14, 15, 19, 20, 21, 22, 23, 24],
        [0, 6, 12, 18, 24, 4, 8, 16, 20]
    ]
}

//
//  HabitHubViewModel.swift
//  151BorgrulslultroBrenrox
//

import Combine
import Foundation

final class HabitHubViewModel: ObservableObject {
    @Published var banner: String?

    func captureWeeklyAward(using appState: TravelAppState) -> Int {
        let stars = appState.tryAwardHabitWeeklyStarsIfEligible()
        if stars > 0 {
            banner = "Weekly rhythm logged with \(stars) stars."
        } else if appState.habitWeeklyProgressRatio() >= 0.999 {
            banner = "Stars already recorded for this calendar week."
        } else {
            banner = "Meet each active target to unlock weekly stars."
        }
        return stars
    }
}

//
//  TabCoordinator.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI
import Combine

final class TabCoordinator: ObservableObject {
    @Published var focusTab: MainTab?

    func requestTab(_ tab: MainTab) {
        focusTab = tab
    }
}

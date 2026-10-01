//
//  AppStorage.swift
//  151BorgrulslultroBrenrox
//

import Foundation
import Combine

struct LoggedSessionEntry: Codable, Identifiable, Equatable {
    var id: UUID
    var activityKind: String
    var detailTitle: String
    var starsEarned: Int
    var completedAt: Date
}

struct HabitItem: Codable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var isActive: Bool
    var weeklyTarget: Int
    var weekProgress: Int
}

struct PackingRow: Codable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var isPacked: Bool
}

struct FieldJournalEntry: Codable, Identifiable, Equatable {
    var id: UUID
    var createdAt: Date
    var body: String
}

enum DriftKind: String, Codable, CaseIterable, Identifiable {
    case fatigue
    case noise
    case contextSwitch
    case schedule
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fatigue: return "Fatigue"
        case .noise: return "Noise"
        case .contextSwitch: return "Context switch"
        case .schedule: return "Schedule pull"
        case .other: return "Other"
        }
    }

    var symbol: String {
        switch self {
        case .fatigue: return "battery.25"
        case .noise: return "speaker.wave.2.fill"
        case .contextSwitch: return "arrow.triangle.swap"
        case .schedule: return "calendar"
        case .other: return "ellipsis.circle"
        }
    }
}

struct FieldDaySeal: Codable, Equatable {
    var dayId: Int
    var carriedTitles: [String]
    var residueNote: String
    var sealedAt: Date
}

struct DriftEvent: Codable, Identifiable, Equatable {
    var id: UUID
    var kindRaw: String
    var note: String
    var createdAt: Date

    var kind: DriftKind {
        DriftKind(rawValue: kindRaw) ?? .other
    }
}

final class TravelAppState: ObservableObject {
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let hasSeenOnboarding = "travel.hasSeenOnboarding"
        static let culturalStreak = "travel.culturalStreak"
        static let mappedLocations = "travel.mappedLocations"
        static let activeAchievements = "travel.activeAchievements"
        static let totalStars = "travel.totalStars"
        static let cartographerStages = "travel.cartographerStages"
        static let silhouetteStages = "travel.silhouetteStages"
        static let habitItems = "travel.habitItems"
        static let packingItems = "travel.packingItems"
        static let sessionLog = "travel.sessionLog"
        static let habitWeekId = "travel.habitWeekId"
        static let habitStarsWeekId = "travel.habitStarsWeekId"
        static let collectionsUnlockedMask = "travel.collectionsUnlockedMask"
        static let journalEntries = "travel.journalEntries"
        static let microWeekId = "travel.microWeekId"
        static let microBits = "travel.microBits"
        static let microRewardClaimed = "travel.microRewardClaimed"
        static let routeWeekAnchor = "travel.routeWeekAnchor"
        static let routeWkCarto = "travel.routeWkCarto"
        static let routeWkSil = "travel.routeWkSil"
        static let routeWkHabit = "travel.routeWkHabit"
        static let routeWkStarsClaimed = "travel.routeWkStarsClaimed"
        static let viewedInsightKeys = "travel.viewedInsightKeys"
        static let fieldDaySeal = "fieldway.daySeal_v1"
        static let briefReviewedDayId = "fieldway.briefReviewedDayId_v1"
        static let driftEvents = "fieldway.driftEvents_v1"
        static let sealStreak = "fieldway.sealStreak_v1"
        static let lastSealDayId = "fieldway.lastSealDayId_v1"
    }

    @Published var hasSeenOnboarding: Bool {
        didSet { defaults.set(hasSeenOnboarding, forKey: Keys.hasSeenOnboarding) }
    }

    @Published var culturalStreak: Int {
        didSet { defaults.set(culturalStreak, forKey: Keys.culturalStreak) }
    }

    @Published var mappedLocations: Int {
        didSet { defaults.set(mappedLocations, forKey: Keys.mappedLocations) }
    }

    @Published private(set) var activeAchievements: [String] {
        didSet { defaults.set(activeAchievements, forKey: Keys.activeAchievements) }
    }

    @Published var totalStars: Int {
        didSet { defaults.set(totalStars, forKey: Keys.totalStars) }
    }

    @Published var cartographerStagesCleared: Int {
        didSet { defaults.set(cartographerStagesCleared, forKey: Keys.cartographerStages) }
    }

    @Published var silhouetteStagesCleared: Int {
        didSet { defaults.set(silhouetteStagesCleared, forKey: Keys.silhouetteStages) }
    }

    @Published var habitItems: [HabitItem] {
        didSet { persistHabits() }
    }

    @Published var packingItems: [PackingRow] {
        didSet { persistPacking() }
    }

    @Published private(set) var sessionLog: [LoggedSessionEntry] {
        didSet { persistSessions() }
    }

    @Published var habitCalendarWeekId: Int {
        didSet { defaults.set(habitCalendarWeekId, forKey: Keys.habitWeekId) }
    }

    @Published var habitStarsAwardedWeekId: Int {
        didSet { defaults.set(habitStarsAwardedWeekId, forKey: Keys.habitStarsWeekId) }
    }

    @Published var collectionsUnlockedMask: Int {
        didSet { defaults.set(collectionsUnlockedMask, forKey: Keys.collectionsUnlockedMask) }
    }

    @Published var journalEntries: [FieldJournalEntry] {
        didSet { persistJournal() }
    }

    @Published var microWeekId: Int {
        didSet { defaults.set(microWeekId, forKey: Keys.microWeekId) }
    }

    @Published var microBits: Int {
        didSet { defaults.set(microBits, forKey: Keys.microBits) }
    }

    @Published var microRewardClaimed: Bool {
        didSet { defaults.set(microRewardClaimed, forKey: Keys.microRewardClaimed) }
    }

    @Published var routeWeekAnchor: Int {
        didSet { defaults.set(routeWeekAnchor, forKey: Keys.routeWeekAnchor) }
    }

    @Published var routeWkCarto: Bool {
        didSet { defaults.set(routeWkCarto, forKey: Keys.routeWkCarto) }
    }

    @Published var routeWkSil: Bool {
        didSet { defaults.set(routeWkSil, forKey: Keys.routeWkSil) }
    }

    @Published var routeWkHabit: Bool {
        didSet { defaults.set(routeWkHabit, forKey: Keys.routeWkHabit) }
    }

    @Published var routeWkStarsClaimed: Bool {
        didSet { defaults.set(routeWkStarsClaimed, forKey: Keys.routeWkStarsClaimed) }
    }

    @Published var viewedInsightCardKeys: [String] {
        didSet { persistViewedInsights() }
    }

    @Published var latestFieldSeal: FieldDaySeal? {
        didSet { persistFieldSeal() }
    }

    @Published var briefReviewedDayId: Int {
        didSet { defaults.set(briefReviewedDayId, forKey: Keys.briefReviewedDayId) }
    }

    @Published var driftEvents: [DriftEvent] {
        didSet { persistDriftEvents() }
    }

    @Published var sealStreak: Int {
        didSet { defaults.set(sealStreak, forKey: Keys.sealStreak) }
    }

    @Published var lastSealDayId: Int {
        didSet { defaults.set(lastSealDayId, forKey: Keys.lastSealDayId) }
    }

    init() {
        hasSeenOnboarding = defaults.bool(forKey: Keys.hasSeenOnboarding)
        culturalStreak = defaults.integer(forKey: Keys.culturalStreak)
        mappedLocations = defaults.integer(forKey: Keys.mappedLocations)
        activeAchievements = defaults.stringArray(forKey: Keys.activeAchievements) ?? []
        totalStars = defaults.integer(forKey: Keys.totalStars)
        cartographerStagesCleared = defaults.integer(forKey: Keys.cartographerStages)
        silhouetteStagesCleared = defaults.integer(forKey: Keys.silhouetteStages)
        let rawWeekId = defaults.integer(forKey: Keys.habitWeekId)
        habitCalendarWeekId = rawWeekId == 0 ? Self.weekIdentifier(for: Date()) : rawWeekId
        habitStarsAwardedWeekId = defaults.integer(forKey: Keys.habitStarsWeekId)
        let rawCollectionsMask = defaults.integer(forKey: Keys.collectionsUnlockedMask)
        collectionsUnlockedMask = rawCollectionsMask == 0 ? 1 : rawCollectionsMask

        if let data = defaults.data(forKey: Keys.journalEntries),
           let decoded = try? JSONDecoder().decode([FieldJournalEntry].self, from: data) {
            journalEntries = decoded
        } else {
            journalEntries = []
        }

        let nowWeek = Self.weekIdentifier(for: Date())
        let storedMicroWeek = defaults.integer(forKey: Keys.microWeekId)
        if storedMicroWeek == 0 || storedMicroWeek != nowWeek {
            microWeekId = nowWeek
            microBits = 0
            microRewardClaimed = false
        } else {
            microWeekId = storedMicroWeek
            microBits = defaults.integer(forKey: Keys.microBits) & 0b111
            microRewardClaimed = defaults.bool(forKey: Keys.microRewardClaimed)
        }

        let storedRouteWeek = defaults.integer(forKey: Keys.routeWeekAnchor)
        if storedRouteWeek == 0 || storedRouteWeek != nowWeek {
            routeWeekAnchor = nowWeek
            routeWkCarto = false
            routeWkSil = false
            routeWkHabit = false
            routeWkStarsClaimed = false
        } else {
            routeWeekAnchor = storedRouteWeek
            routeWkCarto = defaults.bool(forKey: Keys.routeWkCarto)
            routeWkSil = defaults.bool(forKey: Keys.routeWkSil)
            routeWkHabit = defaults.bool(forKey: Keys.routeWkHabit)
            routeWkStarsClaimed = defaults.bool(forKey: Keys.routeWkStarsClaimed)
        }

        viewedInsightCardKeys = defaults.stringArray(forKey: Keys.viewedInsightKeys) ?? []
        briefReviewedDayId = defaults.integer(forKey: Keys.briefReviewedDayId)
        sealStreak = defaults.integer(forKey: Keys.sealStreak)
        lastSealDayId = defaults.integer(forKey: Keys.lastSealDayId)

        if let data = defaults.data(forKey: Keys.fieldDaySeal),
           let decoded = try? JSONDecoder().decode(FieldDaySeal.self, from: data) {
            latestFieldSeal = decoded
        } else {
            latestFieldSeal = nil
        }

        if let data = defaults.data(forKey: Keys.driftEvents),
           let decoded = try? JSONDecoder().decode([DriftEvent].self, from: data) {
            driftEvents = decoded
        } else {
            driftEvents = []
        }

        if let data = defaults.data(forKey: Keys.habitItems),
           let decoded = try? JSONDecoder().decode([HabitItem].self, from: data) {
            habitItems = decoded
        } else {
            habitItems = HabitItem.defaultStarterList()
        }

        if let data = defaults.data(forKey: Keys.packingItems),
           let decoded = try? JSONDecoder().decode([PackingRow].self, from: data) {
            packingItems = decoded
        } else {
            packingItems = PackingRow.defaultStarterList()
        }

        if let data = defaults.data(forKey: Keys.sessionLog),
           let decoded = try? JSONDecoder().decode([LoggedSessionEntry].self, from: data) {
            sessionLog = decoded
        } else {
            sessionLog = []
        }

        reconcileHabitWeekIfNeeded()
        refreshAchievementsAndCollections()
    }

    func markOnboardingFinished() {
        hasSeenOnboarding = true
    }

    func appendSession(_ entry: LoggedSessionEntry) {
        var next = sessionLog
        next.insert(entry, at: 0)
        if next.count > 24 {
            next = Array(next.prefix(24))
        }
        sessionLog = next
    }

    func addStars(_ value: Int) {
        guard value > 0 else { return }
        totalStars += value
        refreshAchievementsAndCollections()
    }

    func registerCartographerCompletion(levelIndex: Int, stars: Int) {
        let previous = cartographerStagesCleared
        let updated = max(previous, min(5, levelIndex + 1))
        let progressed = updated > previous
        cartographerStagesCleared = updated
        if progressed {
            mappedLocations += 1
        }
        culturalStreak = min(culturalStreak + 1, 99)
        let award = progressed ? stars : min(1, stars)
        if award > 0 {
            addStars(award)
        } else {
            refreshAchievementsAndCollections()
        }
        appendSession(
            LoggedSessionEntry(
                id: UUID(),
                activityKind: "cartographer",
                detailTitle: "Route \(levelIndex + 1)",
                starsEarned: award,
                completedAt: Date()
            )
        )
        recordRouteCartographerThisWeek()
    }

    func registerSilhouetteCompletion(puzzleIndex: Int, stars: Int) {
        let previous = silhouetteStagesCleared
        let updated = max(previous, min(3, puzzleIndex + 1))
        let progressed = updated > previous
        silhouetteStagesCleared = updated
        culturalStreak = min(culturalStreak + 1, 99)
        let award = progressed ? stars : min(1, stars)
        if award > 0 {
            addStars(award)
        } else {
            refreshAchievementsAndCollections()
        }
        appendSession(
            LoggedSessionEntry(
                id: UUID(),
                activityKind: "silhouette",
                detailTitle: "Narrative \(puzzleIndex + 1)",
                starsEarned: award,
                completedAt: Date()
            )
        )
        recordRouteSilhouetteThisWeek()
    }

    func registerHabitWeeklyStars(_ stars: Int) {
        guard stars > 0 else { return }
        addStars(stars)
        appendSession(
            LoggedSessionEntry(
                id: UUID(),
                activityKind: "habit",
                detailTitle: "Weekly rhythm",
                starsEarned: stars,
                completedAt: Date()
            )
        )
        recordRouteHabitRhythmThisWeek()
    }

    func reconcileHabitWeekIfNeeded() {
        let current = Self.weekIdentifier(for: Date())
        if habitCalendarWeekId != current {
            habitCalendarWeekId = current
            habitItems = habitItems.map {
                var copy = $0
                copy.weekProgress = 0
                return copy
            }
        }
    }

    func habitWeeklyProgressRatio() -> Double {
        let active = habitItems.filter(\.isActive)
        guard !active.isEmpty else { return 0 }
        let denom = active.reduce(0) { $0 + max(1, min(7, $1.weeklyTarget)) }
        let num = active.reduce(0) { $0 + min($1.weekProgress, max(1, min(7, $1.weeklyTarget))) }
        return denom > 0 ? Double(num) / Double(denom) : 0
    }

    func tryAwardHabitWeeklyStarsIfEligible() -> Int {
        reconcileHabitWeekIfNeeded()
        let ratio = habitWeeklyProgressRatio()
        let week = habitCalendarWeekId
        guard ratio >= 0.999 else { return 0 }
        guard habitStarsAwardedWeekId != week else { return 0 }
        habitStarsAwardedWeekId = week
        let stars: Int
        if habitItems.filter(\.isActive).allSatisfy({ $0.weekProgress >= max(1, $0.weeklyTarget) }) {
            stars = 3
        } else {
            stars = 2
        }
        registerHabitWeeklyStars(stars)
        culturalStreak = min(culturalStreak + 1, 99)
        refreshAchievementsAndCollections()
        return stars
    }

    func refreshWeeklyScopedState() {
        reconcileMicroWeekIfNeeded()
        reconcileRouteWeekIfNeeded()
    }

    var routeOfWeekCompletedSteps: Int {
        [routeWkCarto, routeWkSil, routeWkHabit].filter { $0 }.count
    }

    var routeOfWeekProgress: Double {
        Double(routeOfWeekCompletedSteps) / 3.0
    }

    func setMicroChallengeBit(_ index: Int, isOn: Bool) {
        reconcileMicroWeekIfNeeded()
        guard (0...2).contains(index) else { return }
        var bits = microBits
        if isOn {
            bits |= 1 << index
        } else {
            bits &= ~(1 << index)
        }
        microBits = bits
        tryClaimMicroChallengeReward()
    }

    func isMicroChallengeBitOn(_ index: Int) -> Bool {
        guard (0...2).contains(index) else { return false }
        return (microBits & (1 << index)) != 0
    }

    func addJournalEntry(body: String) {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var next = [FieldJournalEntry(id: UUID(), createdAt: Date(), body: trimmed)] + journalEntries
        if next.count > 50 {
            next = Array(next.prefix(50))
        }
        journalEntries = next
    }

    func deleteJournalEntry(id: UUID) {
        journalEntries.removeAll { $0.id == id }
    }

    func setAllPackingItemsPacked(_ packed: Bool) {
        packingItems = packingItems.map { row in
            var copy = row
            copy.isPacked = packed
            return copy
        }
    }

    static func weekIdentifier(for date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return (comps.yearForWeekOfYear ?? 0) * 100 + (comps.weekOfYear ?? 0)
    }

    static func dayIdentifier(for date: Date) -> Int {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return (comps.year ?? 0) * 10_000 + (comps.month ?? 0) * 100 + (comps.day ?? 0)
    }

    var todayDayId: Int { Self.dayIdentifier(for: Date()) }

    var isTodaySealed: Bool {
        latestFieldSeal?.dayId == todayDayId
    }

    var needsMorningBrief: Bool {
        !activeBriefTitles.isEmpty && briefReviewedDayId != todayDayId
    }

    var activeBriefTitles: [String] {
        guard let seal = latestFieldSeal, seal.dayId < todayDayId else { return [] }
        return seal.carriedTitles
    }

    func markMorningBriefReviewed() {
        briefReviewedDayId = todayDayId
    }

    func sealFieldDay(carriedTitles: [String], residueNote: String) {
        let trimmed = carriedTitles
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let capped = Array(trimmed.prefix(3))
        let residue = residueNote.trimmingCharacters(in: .whitespacesAndNewlines)
        let day = todayDayId
        let previousLast = lastSealDayId
        latestFieldSeal = FieldDaySeal(
            dayId: day,
            carriedTitles: capped,
            residueNote: residue,
            sealedAt: Date()
        )
        if previousLast == 0 {
            sealStreak = 1
        } else if day == previousLast {
            // already sealed today — keep streak
        } else if day - previousLast == 1 || isConsecutiveCalendarDay(previous: previousLast, current: day) {
            sealStreak = min(sealStreak + 1, 99)
        } else {
            sealStreak = 1
        }
        lastSealDayId = day
        culturalStreak = max(culturalStreak, sealStreak)
        addStars(1)
        appendSession(
            LoggedSessionEntry(
                id: UUID(),
                activityKind: "field_seal",
                detailTitle: capped.isEmpty ? "Day sealed" : "Sealed \(capped.count) waymark(s)",
                starsEarned: 1,
                completedAt: Date()
            )
        )
        refreshAchievementsAndCollections()
    }

    private func isConsecutiveCalendarDay(previous: Int, current: Int) -> Bool {
        let prevDate = dateFromDayId(previous)
        let currDate = dateFromDayId(current)
        guard let prevDate, let currDate else { return false }
        let gap = Calendar.current.dateComponents([.day], from: prevDate, to: currDate).day ?? 0
        return gap == 1
    }

    private func dateFromDayId(_ dayId: Int) -> Date? {
        var comps = DateComponents()
        comps.year = dayId / 10_000
        comps.month = (dayId / 100) % 100
        comps.day = dayId % 100
        return Calendar.current.date(from: comps)
    }

    func logDrift(kind: DriftKind, note: String = "") {
        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        var next = [
            DriftEvent(
                id: UUID(),
                kindRaw: kind.rawValue,
                note: trimmed,
                createdAt: Date()
            )
        ] + driftEvents
        if next.count > 40 {
            next = Array(next.prefix(40))
        }
        driftEvents = next
    }

    var driftPeakHour: Int? {
        guard !driftEvents.isEmpty else { return nil }
        var buckets = Array(repeating: 0, count: 24)
        for event in driftEvents {
            let hour = Calendar.current.component(.hour, from: event.createdAt)
            buckets[hour] += 1
        }
        guard let maxVal = buckets.max(), maxVal > 0 else { return nil }
        return buckets.firstIndex(of: maxVal)
    }

    var quietWindowLabel: String {
        guard let peak = driftPeakHour else {
            return "Tag drifts to reveal a quieter fieldwork window."
        }
        let quiet = (peak + 4) % 24
        return String(format: "Peak drift ~%02d:00 · try quiet block near %02d:00", peak, quiet)
    }

    var sealCandidateTitles: [String] {
        var titles: [String] = []
        for entry in sessionLog.prefix(8) {
            let label = "\(friendlyActivityTitle(entry.activityKind)): \(entry.detailTitle)"
            if titles.contains(label) == false {
                titles.append(label)
            }
        }
        for note in journalEntries.prefix(4) {
            let snippet = String(note.body.prefix(42))
            let label = "Note: \(snippet)"
            if titles.contains(label) == false {
                titles.append(label)
            }
        }
        return Array(titles.prefix(8))
    }

    private func friendlyActivityTitle(_ kind: String) -> String {
        switch kind {
        case "cartographer": return "Atlas"
        case "silhouette": return "Lattice"
        case "habit": return "Cadence"
        case "field_seal": return "Seal"
        default: return kind.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }

    func insightStorageKey(deck: Int, cardId: String) -> String {
        "\(deck)::\(cardId)"
    }

    func isInsightViewed(deck: Int, cardId: String) -> Bool {
        viewedInsightCardKeys.contains(insightStorageKey(deck: deck, cardId: cardId))
    }

    func markInsightViewed(deck: Int, cardId: String) {
        let key = insightStorageKey(deck: deck, cardId: cardId)
        guard viewedInsightCardKeys.contains(key) == false else { return }
        viewedInsightCardKeys = (viewedInsightCardKeys + [key]).sorted()
    }

    func isCartographerStageUnlocked(_ stageIndex: Int) -> Bool {
        let cap = 4
        return stageIndex >= 0 && stageIndex <= min(cap, cartographerStagesCleared)
    }

    func isSilhouettePuzzleUnlocked(_ index: Int) -> Bool {
        let cap = 2
        return index >= 0 && index <= min(cap, silhouetteStagesCleared)
    }

    var allCartographerStagesCleared: Bool {
        cartographerStagesCleared >= 5
    }

    var allSilhouettePuzzlesCleared: Bool {
        silhouetteStagesCleared >= 3
    }

    func isCollectionUnlocked(index: Int) -> Bool {
        guard index >= 0, index < 3 else { return false }
        return (collectionsUnlockedMask >> index) & 1 == 1
    }

    private func reconcileMicroWeekIfNeeded() {
        let now = Self.weekIdentifier(for: Date())
        guard microWeekId != now else { return }
        microWeekId = now
        microBits = 0
        microRewardClaimed = false
    }

    private func reconcileRouteWeekIfNeeded() {
        let now = Self.weekIdentifier(for: Date())
        guard routeWeekAnchor != now else { return }
        routeWeekAnchor = now
        routeWkCarto = false
        routeWkSil = false
        routeWkHabit = false
        routeWkStarsClaimed = false
    }

    private func tryClaimMicroChallengeReward() {
        let mask = microBits & 0b111
        guard mask == 0b111 else { return }
        guard microRewardClaimed == false else { return }
        microRewardClaimed = true
        addStars(2)
        appendSession(
            LoggedSessionEntry(
                id: UUID(),
                activityKind: "weekly_micro",
                detailTitle: "Weekly reflections",
                starsEarned: 2,
                completedAt: Date()
            )
        )
    }

    private func tryGrantRouteOfWeekIfComplete() {
        guard routeWkCarto, routeWkSil, routeWkHabit else { return }
        guard routeWkStarsClaimed == false else { return }
        routeWkStarsClaimed = true
        addStars(3)
        appendSession(
            LoggedSessionEntry(
                id: UUID(),
                activityKind: "route_week",
                detailTitle: "Weekly trio path",
                starsEarned: 3,
                completedAt: Date()
            )
        )
    }

    func recordRouteCartographerThisWeek() {
        reconcileRouteWeekIfNeeded()
        routeWkCarto = true
        tryGrantRouteOfWeekIfComplete()
    }

    func recordRouteSilhouetteThisWeek() {
        reconcileRouteWeekIfNeeded()
        routeWkSil = true
        tryGrantRouteOfWeekIfComplete()
    }

    func recordRouteHabitRhythmThisWeek() {
        reconcileRouteWeekIfNeeded()
        routeWkHabit = true
        tryGrantRouteOfWeekIfComplete()
    }

    func resetAllProgress() {
        [
            Keys.hasSeenOnboarding,
            Keys.culturalStreak,
            Keys.mappedLocations,
            Keys.activeAchievements,
            Keys.totalStars,
            Keys.cartographerStages,
            Keys.silhouetteStages,
            Keys.habitItems,
            Keys.packingItems,
            Keys.sessionLog,
            Keys.habitWeekId,
            Keys.habitStarsWeekId,
            Keys.collectionsUnlockedMask,
            Keys.journalEntries,
            Keys.microWeekId,
            Keys.microBits,
            Keys.microRewardClaimed,
            Keys.routeWeekAnchor,
            Keys.routeWkCarto,
            Keys.routeWkSil,
            Keys.routeWkHabit,
            Keys.routeWkStarsClaimed,
            Keys.viewedInsightKeys,
            Keys.fieldDaySeal,
            Keys.briefReviewedDayId,
            Keys.driftEvents,
            Keys.sealStreak,
            Keys.lastSealDayId
        ].forEach { defaults.removeObject(forKey: $0) }

        hasSeenOnboarding = false
        culturalStreak = 0
        mappedLocations = 0
        activeAchievements = []
        totalStars = 0
        cartographerStagesCleared = 0
        silhouetteStagesCleared = 0
        habitItems = HabitItem.defaultStarterList()
        packingItems = PackingRow.defaultStarterList()
        sessionLog = []
        habitCalendarWeekId = Self.weekIdentifier(for: Date())
        habitStarsAwardedWeekId = 0
        collectionsUnlockedMask = 1
        journalEntries = []
        let week = Self.weekIdentifier(for: Date())
        microWeekId = week
        microBits = 0
        microRewardClaimed = false
        routeWeekAnchor = week
        routeWkCarto = false
        routeWkSil = false
        routeWkHabit = false
        routeWkStarsClaimed = false
        viewedInsightCardKeys = []
        latestFieldSeal = nil
        briefReviewedDayId = 0
        driftEvents = []
        sealStreak = 0
        lastSealDayId = 0
        persistHabits()
        persistPacking()
        persistSessions()
        persistJournal()
        persistViewedInsights()
        persistFieldSeal()
        persistDriftEvents()
        NotificationCenter.default.post(name: .travelAppStateDidReset, object: nil)
        objectWillChange.send()
    }

    private func persistHabits() {
        if let data = try? JSONEncoder().encode(habitItems) {
            defaults.set(data, forKey: Keys.habitItems)
        }
    }

    private func persistPacking() {
        if let data = try? JSONEncoder().encode(packingItems) {
            defaults.set(data, forKey: Keys.packingItems)
        }
    }

    private func persistSessions() {
        if let data = try? JSONEncoder().encode(sessionLog) {
            defaults.set(data, forKey: Keys.sessionLog)
        }
    }

    private func persistJournal() {
        if let data = try? JSONEncoder().encode(journalEntries) {
            defaults.set(data, forKey: Keys.journalEntries)
        }
    }

    private func persistViewedInsights() {
        defaults.set(viewedInsightCardKeys, forKey: Keys.viewedInsightKeys)
    }

    private func persistFieldSeal() {
        if let latestFieldSeal,
           let data = try? JSONEncoder().encode(latestFieldSeal) {
            defaults.set(data, forKey: Keys.fieldDaySeal)
        } else {
            defaults.removeObject(forKey: Keys.fieldDaySeal)
        }
    }

    private func persistDriftEvents() {
        if let data = try? JSONEncoder().encode(driftEvents) {
            defaults.set(data, forKey: Keys.driftEvents)
        }
    }

    private func refreshAchievementsAndCollections() {
        var next = Set(activeAchievements)
        if culturalStreak >= 3 { next.insert("steady_explorer") }
        if totalStars >= 10 { next.insert("constellation") }
        if cartographerStagesCleared >= 3 { next.insert("pathfinder") }
        if silhouetteStagesCleared >= 2 { next.insert("story_seeker") }
        if mappedLocations >= 8 { next.insert("atlas_touch") }
        if sealStreak >= 3 { next.insert("field_seal_cadence") }
        if driftEvents.count >= 5 { next.insert("drift_mapper") }
        activeAchievements = Array(next).sorted()

        var mask = 1
        if totalStars >= 4 { mask |= 2 }
        if totalStars >= 12 { mask |= 4 }
        collectionsUnlockedMask = mask
    }

}

extension HabitItem {
    static func defaultStarterList() -> [HabitItem] {
        [
            HabitItem(id: UUID(), title: "Local greeting", isActive: true, weeklyTarget: 5, weekProgress: 0),
            HabitItem(id: UUID(), title: "Regional dish tasting", isActive: true, weeklyTarget: 3, weekProgress: 0),
            HabitItem(id: UUID(), title: "Craft observation notes", isActive: true, weeklyTarget: 4, weekProgress: 0)
        ]
    }
}

extension PackingRow {
    static func defaultStarterList() -> [PackingRow] {
        [
            PackingRow(id: UUID(), title: "Reusable bottle", isPacked: false),
            PackingRow(id: UUID(), title: "Compact journal", isPacked: false),
            PackingRow(id: UUID(), title: "Layered clothing", isPacked: false)
        ]
    }
}

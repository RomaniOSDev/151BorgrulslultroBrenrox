//
//  FieldJournalView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct FieldJournalView: View {
    @EnvironmentObject private var appState: TravelAppState
    @State private var draft = ""
    @FocusState private var editorFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Field journal")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text("Private notes stay on this device—capture textures, overheard lines, or routes worth revisiting. Entries cap at fifty so the scroll stays fast; export mentally by rereading older cards before deleting.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(10)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)

                sparkStrip

                VStack(alignment: .leading, spacing: 8) {
                    Text("New entry")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.appTextSecondary)
                    TextField("Write a short field note…", text: $draft, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                        .foregroundStyle(Color.appTextPrimary)
                        .focused($editorFocused)
                    Button {
                        appState.addJournalEntry(body: draft)
                        draft = ""
                        editorFocused = false
                    } label: {
                        Text("Save entry")
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .buttonStyle(AppPrimaryButtonStyle())
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(16)
                .appDepthSurface(cornerRadius: 18, shadow: .soft)

                if appState.journalEntries.isEmpty {
                    Text("No entries yet. Save moments while they are fresh.")
                        .font(.footnote)
                        .foregroundStyle(Color.appTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                } else {
                    ForEach(appState.journalEntries) { entry in
                        journalRow(entry)
                    }
                }
            }
            .padding(16)
        }
        .appDepthScrollBackdrop()
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sparkStrip: some View {
        let sparks = [
            "Brass doorplate patina at knee height—who polished it last?",
            "Vendor called weights in two languages; note the switch word.",
            "Stair wind favors leftward; guess why carts unloaded east.",
            "Smell: ozone near a tram, sugar near a school—log both.",
            "Tile crack forms a triangle; does it point to a fountain?",
            "Afternoon light square on a lintel—time the shadow next visit."
        ]
        return VStack(alignment: .leading, spacing: 10) {
            Text("Spark lines")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextSecondary)
            Text("Tap to append a prompt to your draft—you can edit before saving.")
                .font(.caption2)
                .foregroundStyle(Color.appTextSecondary.opacity(0.9))
                .lineLimit(4)
                .minimumScaleFactor(0.7)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 8)], spacing: 8) {
                ForEach(Array(sparks.enumerated()), id: \.offset) { _, line in
                    Button {
                        if draft.isEmpty {
                            draft = line
                        } else {
                            draft += "\n\n" + line
                        }
                    } label: {
                        Text(line)
                            .font(.caption)
                            .foregroundStyle(Color.appTextPrimary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                            .minimumScaleFactor(0.7)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.appSurface.opacity(0.88),
                                                Color.appSurface.opacity(0.62)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(Color.appTextPrimary.opacity(0.06), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .appDepthSurface(cornerRadius: 18, shadow: .soft)
    }

    private func journalRow(_ entry: FieldJournalEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextSecondary)
            Text(entry.body)
                .font(.body)
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(20)
                .minimumScaleFactor(0.7)
            Button(role: .destructive) {
                appState.deleteJournalEntry(id: entry.id)
            } label: {
                Text("Delete")
                    .font(.footnote.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(minHeight: 44, alignment: .center)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .none)
    }
}

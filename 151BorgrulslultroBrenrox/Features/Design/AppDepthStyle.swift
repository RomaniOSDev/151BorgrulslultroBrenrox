//
//  AppDepthStyle.swift
//  151BorgrulslultroBrenrox
//
//  Lightweight depth: one LinearGradient fill + hairline stroke + single shadow.
//  Avoid blur, drawingGroup on scroll, and stacking multiple shadows per row.
//

import SwiftUI

enum AppDepthShadow {
    /// No shadow (lists, dense grids).
    case none
    /// Default cards (radius ≤ 10 keeps GPU cost low).
    case soft
    /// Hero / tab bar (use sparingly).
    case lifted

    fileprivate var shadowOpacity: Double {
        switch self {
        case .none: return 0
        case .soft: return 0.06
        case .lifted: return 0.085
        }
    }

    fileprivate var shadowRadius: CGFloat {
        switch self {
        case .none: return 0
        case .soft: return 8
        case .lifted: return 14
        }
    }

    fileprivate var shadowY: CGFloat {
        switch self {
        case .none: return 0
        case .soft: return 3
        case .lifted: return 5
        }
    }
}

enum AppDepthStyle {
    /// Slight top→bottom shift for volume (cheap single gradient).
    static let volumeFill = LinearGradient(
        colors: [
            Color.appSurface.opacity(0.97),
            Color.appSurface.opacity(0.78)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let hairlineStroke = Color.appTextPrimary.opacity(0.08)

    static let screenBackdrop = LinearGradient(
        colors: [
            Color.appBackground,
            Color.appBackground,
            Color.appPrimary.opacity(0.045),
            Color.appAccent.opacity(0.03)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    /// Full-screen subtle gradient behind scroll content.
    func appDepthScrollBackdrop() -> some View {
        background(AppDepthStyle.screenBackdrop)
    }

    /// Standard elevated card: gradient fill + stroke + optional shadow.
    func appDepthSurface(
        cornerRadius: CGFloat = 18,
        shadow: AppDepthShadow = .soft,
        stroke: Color = AppDepthStyle.hairlineStroke
    ) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(AppDepthStyle.volumeFill)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(stroke, lineWidth: 1)
        }
        .shadow(
            color: Color.appTextPrimary.opacity(shadow.shadowOpacity),
            radius: shadow.shadowRadius,
            x: 0,
            y: shadow.shadowY
        )
    }

    /// Card with accent-tinted top edge (still one fill + one stroke + one shadow).
    func appDepthSurfaceTinted(
        cornerRadius: CGFloat = 18,
        tint: Color,
        shadow: AppDepthShadow = .soft
    ) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            tint.opacity(0.22),
                            Color.appSurface.opacity(0.92),
                            Color.appSurface.opacity(0.74)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            tint.opacity(0.35),
                            Color.appTextPrimary.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(
            color: Color.appTextPrimary.opacity(shadow.shadowOpacity),
            radius: shadow.shadowRadius,
            x: 0,
            y: shadow.shadowY
        )
    }
}

import SwiftUI

enum AppTheme {
    static let inkText = Color(red: 0.12, green: 0.16, blue: 0.22) // #1F2937
    static let placeholderText = inkText.opacity(0.45)
    static let paperTop = Color.white // #FFFFFF
    static let cardMist = Color(red: 0.96, green: 0.96, blue: 0.96) // #F4F4F4

    static let primeOrange = Color(red: 1.00, green: 0.48, blue: 0.00) // #FF7A00
    static let sunGold = Color(red: 1.00, green: 0.82, blue: 0.40) // #FFD166
    static let aquaGlow = Color(red: 0.02, green: 0.71, blue: 0.83) // #06B6D4

    static let backplateGradient = LinearGradient(
        colors: [
            paperTop,
            Color(red: 0.90, green: 0.92, blue: 0.96),
            Color(red: 0.16, green: 0.18, blue: 0.22)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static func headlineFont(_ size: CGFloat) -> Font { .system(size: size, weight: .semibold, design: .rounded) }
    static func bodyFont(_ size: CGFloat) -> Font { .system(size: size, weight: .regular, design: .rounded) }
    static func numberFont(_ size: CGFloat) -> Font { .system(size: size, weight: .bold, design: .rounded).monospacedDigit() }
}


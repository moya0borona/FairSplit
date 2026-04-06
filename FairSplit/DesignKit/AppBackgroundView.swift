import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        AppTheme.backplateGradient
            .ignoresSafeArea()
    }
}

struct CardSurface: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(AppTheme.cardMist)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
    }
}

extension View {
    func cardSurface() -> some View { modifier(CardSurface()) }
    func appInkText() -> some View { foregroundColor(AppTheme.inkText) }
}


import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: AppFlowCoordinator

    @State private var pageIndex: Int = 0

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 14) {
                TabView(selection: $pageIndex) {
                    pageCard(
                        title: "Splitting bills is slow.",
                        message: "Different dishes, tips, rounding — it turns into debate."
                    )
                    .tag(0)

                    pageCard(
                        title: "Fairness should be instant.",
                        message: "Enter the bill once and see a clear split right away."
                    )
                    .tag(1)

                    pageCard(
                        title: "Ready to divide smarter?",
                        message: "Save results, tweak weights, and come back anytime."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                VStack(spacing: 10) {
                    Button(action: primaryTap) {
                        Text(pageIndex == 2 ? "Get Started" : "Continue")
                            .font(AppTheme.headlineFont(16))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.primeOrange)
                            .cornerRadius(14)
                    }
                    .accessibilityIdentifier("onboarding_primary")

                    Button(action: skipTap) {
                        Text("Skip")
                            .font(AppTheme.bodyFont(15))
                            .foregroundColor(AppTheme.inkText.opacity(0.85))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    .accessibilityIdentifier("onboarding_skip")
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 14)
            }
        }
    }

    private func pageCard(title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Text(title)
                .font(AppTheme.headlineFont(26))
                .appInkText()
                .minimumScaleFactor(0.82)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 16)

            Text(message)
                .font(AppTheme.bodyFont(16))
                .appInkText()
                .opacity(0.88)
                .minimumScaleFactor(0.86)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 28)
        .padding(.horizontal, 18)
    }

    private func primaryTap() {
        if pageIndex < 2 {
            withAnimation(.easeInOut(duration: 0.25)) {
                pageIndex += 1
            }
        } else {
            withAnimation(.easeInOut(duration: 0.25)) {
                coordinator.completeOnboarding()
            }
        }
    }

    private func skipTap() {
        withAnimation(.easeInOut(duration: 0.25)) {
            coordinator.completeOnboarding()
        }
    }
}


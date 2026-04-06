import SwiftUI

struct SplashView: View {
    @ObservedObject var coordinator: AppFlowCoordinator

    @State private var leftDigit: Int = 7
    @State private var rightDigit: Int = 3
    @State private var digitsScale: CGFloat = 0.86
    @State private var didScheduleExit: Bool = false

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 18) {
                VStack(spacing: 10) {
                    Text("FairSplit")
                        .font(AppTheme.headlineFont(34))
                        .appInkText()

                    Text("Smart Bill Divider")
                        .font(AppTheme.bodyFont(15))
                        .appInkText()
                        .opacity(0.85)
                        .minimumScaleFactor(0.90)
                        .lineLimit(1)
                }

                HStack(spacing: 12) {
                    Text("\(leftDigit)")
                        .font(AppTheme.numberFont(52))
                        .foregroundColor(AppTheme.primeOrange)
                    Text(":")
                        .font(AppTheme.numberFont(44))
                        .foregroundColor(AppTheme.inkText.opacity(0.75))
                    Text("\(rightDigit)")
                        .font(AppTheme.numberFont(52))
                        .foregroundColor(AppTheme.aquaGlow)
                }
                .scaleEffect(digitsScale)
                .accessibilityLabel("Loading")

                Text("Fairness in seconds.")
                    .font(AppTheme.bodyFont(16))
                    .appInkText()
                    .opacity(0.90)
                    .minimumScaleFactor(0.88)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 24)
            }
            .padding(.horizontal, 18)
        }
        .onAppear {
            guard didScheduleExit == false else { return }
            didScheduleExit = true
            animateDigits()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    coordinator.advanceFromSplash()
                }
            }
        }
    }

    private func animateDigits() {
        let digitSequence = [9, 4, 1, 8, 2, 6, 0, 5, 3, 7]
        for stepIndex in 0..<digitSequence.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12 * Double(stepIndex)) {
                withAnimation(.easeInOut(duration: 0.18)) {
                    leftDigit = digitSequence[stepIndex]
                    rightDigit = digitSequence[(stepIndex + 3) % digitSequence.count]
                    digitsScale = (stepIndex % 2 == 0) ? 0.90 : 0.98
                }
            }
        }
    }
}


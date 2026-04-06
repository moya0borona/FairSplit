import SwiftUI
import Combine

final class AppFlowCoordinator: ObservableObject {
    enum Route: Equatable {
        case splash
        case onboarding
        case mainTabs
    }

    @Published var route: Route = .splash

    private let onboardingCompletionKey = "onboardingCompletion__fairSplit_1"

    init() {
        route = .splash
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingCompletionKey)
        route = .mainTabs
    }

    func advanceFromSplash() {
        if UserDefaults.standard.bool(forKey: onboardingCompletionKey) {
            route = .mainTabs
        } else {
            route = .onboarding
        }
    }
}


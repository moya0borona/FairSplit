import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppFlowCoordinator()

    var body: some View {
        ZStack {
            switch coordinator.route {
            case .splash:
                SplashView(coordinator: coordinator)
            case .onboarding:
                OnboardingView(coordinator: coordinator)
            case .mainTabs:
                MainTabView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import Foundation
import Combine

final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    struct Keys {
        static let hapticsEnabled = "hapticsEnabled__fairSplit_1"
        static let defaultTipIndex = "defaultTipIndex__fairSplit_1"
        static let currencyCode = "currencyCode__fairSplit_1"
    }

    @Published var hapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticsEnabled, forKey: Keys.hapticsEnabled) }
    }
    @Published var defaultTipIndex: Int {
        didSet { UserDefaults.standard.set(defaultTipIndex, forKey: Keys.defaultTipIndex) }
    }
    @Published var currencyCode: String {
        didSet { UserDefaults.standard.set(currencyCode, forKey: Keys.currencyCode) }
    }

    private init() {
        let ud = UserDefaults.standard
        hapticsEnabled = ud.object(forKey: Keys.hapticsEnabled) as? Bool ?? true
        defaultTipIndex = ud.object(forKey: Keys.defaultTipIndex) as? Int ?? 2
        currencyCode = ud.string(forKey: Keys.currencyCode) ?? "USD"
    }
}


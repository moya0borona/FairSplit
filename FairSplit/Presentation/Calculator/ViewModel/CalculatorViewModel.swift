import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {
    struct TipPreset {
        let title: String
        let fraction: Double
    }

    @Published var billText: String = ""
    @Published var peopleCount: Int = 2
    @Published var selectedTipIndex: Int = 2
    @Published var customTipText: String = ""
    @Published var useCustomTip: Bool = false

    let tipPresets: [TipPreset] = [
        TipPreset(title: "0%", fraction: 0),
        TipPreset(title: "10%", fraction: 0.10),
        TipPreset(title: "15%", fraction: 0.15),
        TipPreset(title: "20%", fraction: 0.20)
    ]

    var billValue: Double { Self.parseMoneyLoose(billText) }
    var tipFraction: Double {
        if useCustomTip {
            let pct = Self.parseMoneyLoose(customTipText)
            return max(0, pct / 100)
        }
        return tipPresets[safe: selectedTipIndex]?.fraction ?? 0
    }

    func adoptDefaultTipIndex(_ idx: Int) {
        guard idx >= 0, idx < tipPresets.count else { return }
        selectedTipIndex = idx
    }

    var splitSummary: SplitSummary {
        SplitSummary(
            billTotal: billValue,
            tipFraction: tipFraction,
            peopleCount: peopleCount
        )
    }

    static func parseMoneyLoose(_ raw: String) -> Double {
        let sanitized = raw
            .replacingOccurrences(of: ",", with: ".")
            .filter { "0123456789.".contains($0) }
        return Double(sanitized) ?? 0
    }
}

private extension Array {
    subscript(safe idx: Int) -> Element? {
        guard idx >= 0, idx < count else { return nil }
        return self[idx]
    }
}


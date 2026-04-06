import Foundation
import Combine

final class SmartSplitViewModel: ObservableObject {
    @Published var totalText: String = ""
    @Published var tipFraction: Double = 0.15
    @Published var members: [PersonLineItem] = [
        PersonLineItem(displayName: "Alex", fixedAmount: 0, weight: 1),
        PersonLineItem(displayName: "Sam", fixedAmount: 0, weight: 1),
        PersonLineItem(displayName: "Taylor", fixedAmount: 0, weight: 1)
    ]

    var totalValue: Double { CalculatorViewModel.parseMoneyLoose(totalText) }
    var totalWithTip: Double { BillMath.totalWithTip(bill: totalValue, tipFraction: tipFraction) }

    func shares() -> [UUID: Double] {
        let weights = members.map { $0.weight }
        let values = BillMath.weightedShares(total: totalWithTip, weights: weights)
        var map: [UUID: Double] = [:]
        for (idx, mem) in members.enumerated() {
            map[mem.id] = values[safe: idx] ?? 0
        }
        return map
    }

    func addMember() {
        members.append(PersonLineItem(displayName: "Guest \(members.count + 1)", fixedAmount: 0, weight: 1))
    }

    func removeMember(_ id: UUID) {
        members.removeAll { $0.id == id }
    }
}

private extension Array {
    subscript(safe idx: Int) -> Element? {
        guard idx >= 0, idx < count else { return nil }
        return self[idx]
    }
}


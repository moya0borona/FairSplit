import Foundation

struct SplitSummary: Equatable {
    var billTotal: Double
    var tipFraction: Double
    var peopleCount: Int

    var totalWithTip: Double { billTotal * (1 + tipFraction) }
    var perPersonEven: Double {
        guard peopleCount > 0 else { return 0 }
        return totalWithTip / Double(peopleCount)
    }
}

struct PersonLineItem: Equatable, Identifiable {
    let id: UUID
    var displayName: String
    var fixedAmount: Double
    var weight: Double

    init(id: UUID = UUID(), displayName: String, fixedAmount: Double, weight: Double = 1) {
        self.id = id
        self.displayName = displayName
        self.fixedAmount = fixedAmount
        self.weight = weight
    }
}


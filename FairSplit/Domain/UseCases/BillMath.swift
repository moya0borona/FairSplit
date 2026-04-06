import Foundation

enum BillMath {
    static func totalWithTip(bill: Double, tipFraction: Double) -> Double {
        bill * (1 + tipFraction)
    }

    static func perPerson(totalWithTip: Double, people: Int) -> Double {
        guard people > 0 else { return 0 }
        return totalWithTip / Double(people)
    }

    static func remaining(totalWithTip: Double, individualSum: Double) -> Double {
        totalWithTip - individualSum
    }

    static func weightedShares(total: Double, weights: [Double]) -> [Double] {
        let safeWeights = weights.map { max(0, $0) }
        let sum = safeWeights.reduce(0, +)
        guard sum > 0 else { return safeWeights.map { _ in 0 } }
        return safeWeights.map { total * ($0 / sum) }
    }
}


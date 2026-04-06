import Foundation

enum MoneyFormatter {
    static func format(amount: Double, currencyCode: String) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = currencyCode
        fmt.maximumFractionDigits = 2
        fmt.minimumFractionDigits = 2
        return fmt.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}


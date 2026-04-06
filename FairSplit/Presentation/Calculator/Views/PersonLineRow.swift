import SwiftUI

struct PersonLineRow: View {
    @Binding var nameText: String
    @Binding var amountValue: Double
    @Binding var weightValue: Double

    let currencyCode: String
    let onRemoveTap: () -> Void

    @State private var amountTextDraft: String = ""

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                TextField("Name", text: $nameText, prompt: Text("Name").foregroundColor(AppTheme.placeholderText))
                    .font(AppTheme.bodyFont(15))
                    .foregroundColor(AppTheme.inkText)
                    .tint(AppTheme.aquaGlow)
                    .padding(10)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(12)

                TextField("0.00", text: Binding(
                    get: { amountTextDraft.isEmpty ? formattedDraftOrEmpty() : amountTextDraft },
                    set: { newVal in
                        amountTextDraft = newVal
                        amountValue = max(0, CalculatorViewModel.parseMoneyLoose(newVal))
                    }
                ), prompt: Text("0.00").foregroundColor(AppTheme.placeholderText))
                .keyboardType(.decimalPad)
                .font(AppTheme.numberFont(16))
                .foregroundColor(AppTheme.inkText)
                .tint(AppTheme.aquaGlow)
                .padding(10)
                .background(Color.white.opacity(0.95))
                .cornerRadius(12)
                .frame(width: 110)
                .onAppear {
                    amountTextDraft = amountValue == 0 ? "" : String(format: "%.2f", amountValue)
                }
            }

            HStack {
                Text("Weight")
                    .font(AppTheme.bodyFont(13))
                    .appInkText()
                    .opacity(0.86)
                    .lineLimit(1)
                Spacer(minLength: 8)
                Text(String(format: "%.2f", weightValue))
                    .font(AppTheme.numberFont(14))
                    .foregroundColor(AppTheme.inkText)
                    .lineLimit(1)
            }

            Slider(value: $weightValue, in: 0...3)
                .accentColor(AppTheme.aquaGlow)

            HStack {
                Text(MoneyFormatter.format(amount: amountValue, currencyCode: currencyCode))
                    .font(AppTheme.bodyFont(12))
                    .appInkText()
                    .opacity(0.78)
                    .minimumScaleFactor(0.80)
                    .lineLimit(1)
                Spacer()
                Button(action: onRemoveTap) {
                    Text("Remove")
                        .font(AppTheme.bodyFont(13))
                        .foregroundColor(AppTheme.inkText.opacity(0.9))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(10)
                }
            }
        }
        .padding(12)
        .background(AppTheme.cardMist.opacity(0.70))
        .cornerRadius(14)
    }

    private func formattedDraftOrEmpty() -> String {
        amountValue == 0 ? "" : String(format: "%.2f", amountValue)
    }
}


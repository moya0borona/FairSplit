import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            AppBackgroundView()

            TabView {
                NavigationView {
                    CalculatorView()
                }
                .tabItem {
                    Label("Calculator", systemImage: "divide.circle")
                }

                NavigationView {
                    HistoryView()
                }
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

                NavigationView {
                    AnalyticsView()
                }
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie")
                }

                NavigationView {
                    SettingsView()
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .accentColor(AppTheme.primeOrange)
        }
    }
}

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @ObservedObject private var settings = SettingsStore.shared

    @State private var isShowingSmartSplit: Bool = false

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: 14) {
                    calculatorInputCard
                    stickyResultCard

                    Button(action: { isShowingSmartSplit = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Smart Split")
                                    .font(AppTheme.headlineFont(17))
                                    .foregroundColor(Color.white)
                                    .minimumScaleFactor(0.88)
                                    .lineLimit(1)
                                Text("Weights, percentages, drag controls.")
                                    .font(AppTheme.bodyFont(13))
                                    .foregroundColor(Color.white.opacity(0.92))
                                    .minimumScaleFactor(0.88)
                                    .lineLimit(2)
                            }
                            Spacer(minLength: 8)
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white.opacity(0.95))
                        }
                        .padding(14)
                        .background(AppTheme.aquaGlow)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
                    }

                    NavigationLink(
                        destination: SmartSplitView(),
                        isActive: $isShowingSmartSplit,
                        label: { EmptyView() }
                    )
                    .hidden()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if viewModel.useCustomTip == false {
                viewModel.adoptDefaultTipIndex(settings.defaultTipIndex)
            }
        }
    }

    private var calculatorInputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Calculator")
                .font(AppTheme.headlineFont(28))
                .appInkText()
                .minimumScaleFactor(0.82)
                .lineLimit(1)

            VStack(alignment: .leading, spacing: 8) {
                Text("Bill Amount")
                    .font(AppTheme.headlineFont(15))
                    .appInkText()
                    .lineLimit(1)

                TextField("0.00", text: $viewModel.billText, prompt: Text("0.00").foregroundColor(AppTheme.placeholderText))
                    .keyboardType(.decimalPad)
                    .font(AppTheme.numberFont(20))
                    .foregroundColor(AppTheme.inkText)
                    .tint(AppTheme.primeOrange)
                    .padding(12)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(12)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("People")
                        .font(AppTheme.headlineFont(15))
                        .appInkText()
                        .lineLimit(1)
                    Spacer(minLength: 8)
                    Stepper("", value: $viewModel.peopleCount, in: 1...24, step: 1)
                        .labelsHidden()
                }
                
                Text("\(viewModel.peopleCount)")
                    .font(AppTheme.numberFont(18))
                    .foregroundColor(AppTheme.primeOrange)
                    .lineLimit(1)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Tip")
                        .font(AppTheme.headlineFont(15))
                        .appInkText()
                        .lineLimit(1)
                    Spacer(minLength: 8)
                    Toggle("Custom", isOn: $viewModel.useCustomTip)
                        .labelsHidden()
                }

                if viewModel.useCustomTip {
                    TextField("Custom %", text: $viewModel.customTipText, prompt: Text("Custom %").foregroundColor(AppTheme.placeholderText))
                        .keyboardType(.decimalPad)
                        .font(AppTheme.numberFont(18))
                        .foregroundColor(AppTheme.inkText)
                        .tint(AppTheme.primeOrange)
                        .padding(12)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(12)
                } else {
                    Picker("Tip", selection: $viewModel.selectedTipIndex) {
                        ForEach(0..<viewModel.tipPresets.count, id: \.self) { ix in
                            Text(viewModel.tipPresets[ix].title).tag(ix)
                        
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
        .cardSurface()
    }

    private var stickyResultCard: some View {
        let splitSummary = viewModel.splitSummary
        let totalWithTip = splitSummary.totalWithTip
        let perPerson = splitSummary.perPersonEven

        return VStack(alignment: .leading, spacing: 10) {
            Text("Result")
                .font(AppTheme.headlineFont(16))
                .appInkText()
                .lineLimit(1)

            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Per Person")
                        .font(AppTheme.bodyFont(13))
                        .appInkText()
                        .opacity(0.86)
                        .lineLimit(1)
                    Text(MoneyFormatter.format(amount: perPerson, currencyCode: settings.currencyCode))
                        .font(AppTheme.numberFont(26))
                        .foregroundColor(AppTheme.aquaGlow)
                        .minimumScaleFactor(0.80)
                        .lineLimit(1)
                }
                Spacer(minLength: 10)
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total With Tip")
                        .font(AppTheme.bodyFont(13))
                        .appInkText()
                        .opacity(0.86)
                        .lineLimit(1)
                    Text(MoneyFormatter.format(amount: totalWithTip, currencyCode: settings.currencyCode))
                        .font(AppTheme.numberFont(20))
                        .foregroundColor(AppTheme.primeOrange)
                        .minimumScaleFactor(0.80)
                        .lineLimit(1)
                }
            }

            Button(action: saveSnapshot) {
                Text("Save to History")
                    .font(AppTheme.headlineFont(15))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppTheme.aquaGlow)
                    .cornerRadius(14)
            }
            .accessibilityIdentifier("calculator_save_history")
        }
        .cardSurface()
    }

    @Environment(\.managedObjectContext) private var ctx

    private func saveSnapshot() {
        Haptics.tapSoftIfEnabled(settings.hapticsEnabled)
        let splitSummary = viewModel.splitSummary
        do {
            try HistoryRepository(context: ctx).createCalculation(
                total: splitSummary.billTotal,
                tipFraction: splitSummary.tipFraction,
                people: splitSummary.peopleCount,
                resultPerPerson: splitSummary.perPersonEven
            )
            Haptics.notifySuccessIfEnabled(settings.hapticsEnabled)
        } catch {
            // ignore for v1
        }
    }
}

struct SmartSplitView: View {
    @StateObject private var viewModel = SmartSplitViewModel()
    @ObservedObject private var settings = SettingsStore.shared

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Smart Split")
                            .font(AppTheme.headlineFont(28))
                            .appInkText()
                            .minimumScaleFactor(0.85)
                            .lineLimit(1)
                        Text("Drag to adjust weights. Shares update instantly.")
                            .font(AppTheme.bodyFont(15))
                            .appInkText()
                            .opacity(0.86)
                            .minimumScaleFactor(0.85)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface()

                    totalCard
                    membersCard
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            }
            .navigationTitle("Smart Split")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var totalCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Total")
                .font(AppTheme.headlineFont(16))
                .appInkText()
                .lineLimit(1)

            TextField("0.00", text: $viewModel.totalText, prompt: Text("0.00").foregroundColor(AppTheme.placeholderText))
                .keyboardType(.decimalPad)
                .font(AppTheme.numberFont(20))
                .foregroundColor(AppTheme.inkText)
                .tint(AppTheme.primeOrange)
                .padding(12)
                .background(Color.white.opacity(0.95))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Tip \(Int(viewModel.tipFraction * 100))%")
                        .font(AppTheme.bodyFont(14))
                        .appInkText()
                        .opacity(0.86)
                        .lineLimit(1)
                    Spacer(minLength: 8)
                    Text(MoneyFormatter.format(amount: viewModel.totalWithTip, currencyCode: settings.currencyCode))
                        .font(AppTheme.numberFont(16))
                        .foregroundColor(AppTheme.primeOrange)
                        .minimumScaleFactor(0.80)
                        .lineLimit(1)
                }
                Slider(value: $viewModel.tipFraction, in: 0...0.35, step: 0.01)
                    .accentColor(AppTheme.primeOrange)
            }
        }
        .cardSurface()
    }

    private var membersCard: some View {
        let shareMap = viewModel.shares()

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Members")
                    .font(AppTheme.headlineFont(16))
                    .appInkText()
                    .lineLimit(1)
                Spacer(minLength: 8)
                Button(action: {
                    Haptics.tapSoftIfEnabled(settings.hapticsEnabled)
                    viewModel.addMember()
                }) {
                    Text("Add")
                        .font(AppTheme.headlineFont(14))
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppTheme.aquaGlow)
                        .cornerRadius(10)
                }
            }

            ForEach(viewModel.members) { mem in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        TextField("Name", text: Binding(
                            get: { mem.displayName },
                            set: { newVal in
                                if let idx = viewModel.members.firstIndex(where: { $0.id == mem.id }) {
                                    viewModel.members[idx].displayName = String(newVal.prefix(16))
                                }
                            }
                        ), prompt: Text("Name").foregroundColor(AppTheme.placeholderText))
                        .font(AppTheme.bodyFont(15))
                        .foregroundColor(AppTheme.inkText)
                        .tint(AppTheme.primeOrange)
                        .padding(10)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(12)

                        VStack(alignment: .trailing, spacing: 3) {
                            Text("Share")
                                .font(AppTheme.bodyFont(12))
                                .appInkText()
                                .opacity(0.78)
                                .lineLimit(1)
                            Text(MoneyFormatter.format(amount: shareMap[mem.id] ?? 0, currencyCode: settings.currencyCode))
                                .font(AppTheme.numberFont(14))
                                .foregroundColor(AppTheme.inkText)
                                .minimumScaleFactor(0.78)
                                .lineLimit(1)
                        }
                        .frame(width: 120, alignment: .trailing)
                    }

                    HStack {
                        Text("Weight")
                            .font(AppTheme.bodyFont(13))
                            .appInkText()
                            .opacity(0.86)
                            .lineLimit(1)
                        Spacer(minLength: 8)
                        Text(String(format: "%.2f", mem.weight))
                            .font(AppTheme.numberFont(14))
                            .foregroundColor(AppTheme.primeOrange)
                            .lineLimit(1)
                    }

                    Slider(value: Binding(
                        get: { mem.weight },
                        set: { newVal in
                            if let idx = viewModel.members.firstIndex(where: { $0.id == mem.id }) {
                                viewModel.members[idx].weight = max(0, newVal)
                            }
                        }
                    ), in: 0...4)
                    .accentColor(AppTheme.primeOrange)

                    HStack {
                        Spacer()
                        Button(action: {
                            Haptics.tapSoftIfEnabled(settings.hapticsEnabled)
                            viewModel.removeMember(mem.id)
                        }) {
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
        }
        .cardSurface()
    }
}

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var ctx
    @ObservedObject private var settings = SettingsStore.shared

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
        animation: .easeInOut
    )
    private var calculations: FetchedResults<ObsidianCalcGlyph>

    var body: some View {
        ZStack {
            AppBackgroundView()
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Saved Calculations")
                            .font(AppTheme.headlineFont(20))
                            .appInkText()
                            .minimumScaleFactor(0.85)
                            .lineLimit(1)
                        Text("Swipe left to delete any record.")
                            .font(AppTheme.bodyFont(14))
                            .appInkText()
                            .opacity(0.86)
                            .minimumScaleFactor(0.85)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(AppTheme.cardMist)

                if calculations.isEmpty {
                    Section {
                        Text("No history yet. Save from Calculator.")
                            .font(AppTheme.bodyFont(15))
                            .appInkText()
                            .opacity(0.88)
                            .minimumScaleFactor(0.85)
                            .lineLimit(2)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(AppTheme.cardMist)
                } else {
                    ForEach(calculations) { glyph in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(dateString(glyph.date))
                                    .font(AppTheme.bodyFont(13))
                                    .appInkText()
                                    .opacity(0.78)
                                    .lineLimit(1)
                                Spacer(minLength: 8)
                                Text("\(Int(glyph.people)) ppl")
                                    .font(AppTheme.bodyFont(13))
                                    .appInkText()
                                    .opacity(0.78)
                                    .lineLimit(1)
                            }

                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Total")
                                        .font(AppTheme.bodyFont(12))
                                        .appInkText()
                                        .opacity(0.78)
                                        .lineLimit(1)
                                    Text(MoneyFormatter.format(amount: glyph.total, currencyCode: settings.currencyCode))
                                        .font(AppTheme.numberFont(15))
                                        .foregroundColor(AppTheme.primeOrange)
                                        .minimumScaleFactor(0.80)
                                        .lineLimit(1)
                                }
                                Spacer(minLength: 8)
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Per Person")
                                        .font(AppTheme.bodyFont(12))
                                        .appInkText()
                                        .opacity(0.78)
                                        .lineLimit(1)
                                    Text(MoneyFormatter.format(amount: glyph.result, currencyCode: settings.currencyCode))
                                        .font(AppTheme.numberFont(16))
                                        .foregroundColor(AppTheme.aquaGlow)
                                        .minimumScaleFactor(0.78)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(AppTheme.cardMist)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteGlyph(glyph)
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func deleteGlyph(_ glyph: ObsidianCalcGlyph) {
        Haptics.tapSoftIfEnabled(settings.hapticsEnabled)
        do {
            try HistoryRepository(context: ctx).delete(glyph)
        } catch {
            // keep UI responsive; CoreData issues are rare here
        }
    }

    private func dateString(_ dt: Date?) -> String {
        let d = dt ?? Date()
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        return fmt.string(from: d)
    }
}

struct AnalyticsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
        animation: .easeInOut
    )
    private var calculations: FetchedResults<ObsidianCalcGlyph>

    @ObservedObject private var settings = SettingsStore.shared

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Analytics")
                            .font(AppTheme.headlineFont(28))
                            .appInkText()
                            .minimumScaleFactor(0.85)
                            .lineLimit(1)
                        Text("Pie and bar charts for your saved splits.")
                            .font(AppTheme.bodyFont(15))
                            .appInkText()
                            .opacity(0.86)
                            .minimumScaleFactor(0.85)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface()

                    pieCard
                    barCard
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var pieCard: some View {
        let totals = calculations.map { max(0, $0.total) }
        let sum = totals.reduce(0, +)
        let colors: [Color] = [
            AppTheme.primeOrange,
            AppTheme.aquaGlow,
            AppTheme.sunGold,
            AppTheme.inkText.opacity(0.65)
        ]

        return VStack(alignment: .leading, spacing: 12) {
            Text("Total Volume")
                .font(AppTheme.headlineFont(16))
                .appInkText()
                .lineLimit(1)

            if sum <= 0 {
                Text("Save a few calculations to see charts.")
                    .font(AppTheme.bodyFont(14))
                    .appInkText()
                    .opacity(0.86)
                    .minimumScaleFactor(0.85)
                    .lineLimit(2)
            } else {
                ZStack {
                    var running: Double { 0 } // placeholder for SwiftUI local var restrictions
                    ForEach(Array(totals.prefix(6).enumerated()), id: \.offset) { ix, val in
                        let start = Angle(degrees: 360 * (totals.prefix(ix).reduce(0, +) / sum) - 90)
                        let end = Angle(degrees: 360 * (totals.prefix(ix + 1).reduce(0, +) / sum) - 90)
                        PieSliceShape(startAngle: start, endAngle: end)
                            .fill(colors[ix % colors.count])
                    }
                }
                .frame(height: 180)
                .padding(.vertical, 6)

                HStack {
                    Text("Total: \(MoneyFormatter.format(amount: sum, currencyCode: settings.currencyCode))")
                        .font(AppTheme.numberFont(15))
                        .foregroundColor(AppTheme.inkText)
                        .minimumScaleFactor(0.80)
                        .lineLimit(1)
                    Spacer(minLength: 8)
                    Text("Last \(min(6, totals.count))")
                        .font(AppTheme.bodyFont(13))
                        .appInkText()
                        .opacity(0.78)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private var barCard: some View {
        let rows = Array(calculations.prefix(7)).reversed()
        let values = rows.map { max(0, $0.result) }
        let peak = max(values.max() ?? 0.01, 0.01)

        return VStack(alignment: .leading, spacing: 12) {
            Text("Per Person Trend")
                .font(AppTheme.headlineFont(16))
                .appInkText()
                .lineLimit(1)

            if rows.isEmpty {
                Text("No data yet.")
                    .font(AppTheme.bodyFont(14))
                    .appInkText()
                    .opacity(0.86)
                    .lineLimit(1)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { ix, glyph in
                        let val = max(0, glyph.result)
                        let h = CGFloat(val / peak)
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppTheme.aquaGlow)
                                .frame(width: 20, height: max(18, 140 * h))
                                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
                            Text(shortDay(glyph.date))
                                .font(AppTheme.bodyFont(11))
                                .appInkText()
                                .opacity(0.78)
                                .minimumScaleFactor(0.75)
                                .lineLimit(1)
                        }
                        .accessibilityLabel("Bar \(ix + 1)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Text("Peak: \(MoneyFormatter.format(amount: peak, currencyCode: settings.currencyCode))")
                        .font(AppTheme.bodyFont(13))
                        .appInkText()
                        .opacity(0.78)
                        .minimumScaleFactor(0.80)
                        .lineLimit(1)
                    Spacer(minLength: 8)
                    Text("Last \(rows.count)")
                        .font(AppTheme.bodyFont(13))
                        .appInkText()
                        .opacity(0.78)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private func shortDay(_ dt: Date?) -> String {
        let d = dt ?? Date()
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM d"
        return fmt.string(from: d)
    }
}

struct SettingsView: View {
    @ObservedObject private var settings = SettingsStore.shared
    private let tipPresets: [String] = ["0%", "10%", "15%", "20%"]
    private let currencyCandidates: [String] = ["USD", "EUR", "GBP", "RUB", "AED", "TRY", "JPY", "CNY", "INR"]

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Settings")
                            .font(AppTheme.headlineFont(28))
                            .appInkText()
                            .minimumScaleFactor(0.85)
                            .lineLimit(1)
                        Text("Default tip, haptics, and currency.")
                            .font(AppTheme.bodyFont(15))
                            .appInkText()
                            .opacity(0.86)
                            .minimumScaleFactor(0.85)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface()

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Haptics")
                                .font(AppTheme.headlineFont(16))
                                .appInkText()
                                .lineLimit(1)
                            Spacer(minLength: 8)
                            Toggle("", isOn: $settings.hapticsEnabled)
                                .labelsHidden()
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Default Tip")
                                .font(AppTheme.headlineFont(16))
                                .appInkText()
                                .lineLimit(1)
                            Picker("Default Tip", selection: $settings.defaultTipIndex) {
                                ForEach(0..<tipPresets.count, id: \.self) { ix in
                                    Text(tipPresets[ix]).tag(ix)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Currency")
                                .font(AppTheme.headlineFont(16))
                                .appInkText()
                                .lineLimit(1)

                            Picker("Currency", selection: $settings.currencyCode) {
                                ForEach(currencyCandidates, id: \.self) { code in
                                    Text(code).tag(code)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            Text("Preview: \(MoneyFormatter.format(amount: 123.45, currencyCode: settings.currencyCode))")
                                .font(AppTheme.bodyFont(13))
                                .appInkText()
                                .opacity(0.82)
                                .minimumScaleFactor(0.85)
                                .lineLimit(1)
                        }
                    }
                    .cardSurface()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


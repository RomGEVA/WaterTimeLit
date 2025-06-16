import SwiftUI

struct HistoryView: View {
    @AppStorage("history") private var historyData: Data = Data()
    @AppStorage("cupsDrunkToday") private var cupsDrunkToday: Int = 0
    @AppStorage("cupsDrunkDate") private var cupsDrunkDate: String = ""
    
    private var history: [DayRecord] {
        if let decoded = try? JSONDecoder().decode([DayRecord].self, from: historyData) {
            return decoded.sorted { $0.date > $1.date }
        }
        return []
    }
    
    var body: some View {
        ZStack {
            WaterBalanceBackground()
            
            if history.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("No History Yet")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Complete your first day to see your progress here")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Weekly Chart
                        WeeklyChartView(history: Array(history.prefix(7)))
                            .waterTimeCard()
                        
                        // History List
                        VStack(spacing: 15) {
                            ForEach(history, id: \.date) { record in
                                HistoryRow(record: record) {
                                    deleteDay(record.date)
                                }
                            }
                        }
                        .waterTimeCard()
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("History")
    }
    
    private func deleteDay(_ date: String) {
        var currentHistory = history
        currentHistory.removeAll { $0.date == date }
        if let encoded = try? JSONEncoder().encode(currentHistory) {
            historyData = encoded
        }
        
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        if date == today {
            cupsDrunkToday = 0
            cupsDrunkDate = ""
        }
    }
}

struct WeeklyChartView: View {
    let history: [DayRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("Last 7 Days")
                    .font(.headline)
            }
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(history.reversed(), id: \.date) { record in
                    VStack {
                        Text("\(record.cupsDrunk)")
                            .font(.caption)
                            .foregroundColor(.primary)
                        ZStack(alignment: .bottom) {
                            Capsule()
                                .fill(Color.gray.opacity(0.18))
                                .frame(width: 18, height: 80)
                            Capsule()
                                .fill(record.isCompleted ? Color.blue : Color.gray)
                                .frame(width: 18, height: CGFloat(record.cupsDrunk) / CGFloat(max(record.targetCups, 1)) * 80)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: record.cupsDrunk)
                        }
                        Text(shortDate(record.date))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(width: 32)
                    }
                }
            }
            .frame(height: 100)
        }
        .padding(.vertical, 8)
    }
    
    private func shortDate(_ date: String) -> String {
        
        let comps = date.split(separator: ".")
        if comps.count >= 2 {
            return comps[0] + "." + comps[1]
        }
        return date
    }
}

struct HistoryRow: View {
    let record: DayRecord
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date)
                    .font(.headline)
                
                Text("\(record.cupsDrunk) of \(record.targetCups) cups")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
} 


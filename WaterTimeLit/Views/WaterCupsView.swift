import SwiftUI

struct WaterCupsView: View {
    @AppStorage("userWeight") private var weight: Double = 70
    @AppStorage("userGender") private var gender: Int = 1 // 1 = Male, 0 = Female
    @AppStorage("userActivityLevel") private var activityLevel: ActivityLevel = .medium
    @AppStorage("cupSize") private var cupSize: Double = 250
    @AppStorage("cupsDrunkToday") private var cupsDrunkToday: Int = 0
    @AppStorage("cupsDrunkDate") private var cupsDrunkDate: String = ""
    @AppStorage("history") private var historyData: Data = Data()
    @State private var showCompleteDayAlert = false
    @State private var isDayCompleted: Bool = false
    @State private var showAlreadyCompletedAlert = false
    
    @State private var filledCups: Set<Int> = []
    @State private var showCongrats = false
    
    private var waterNorm: Int {
        let baseNorm = gender == 1 ? Int(weight * 35) : Int(weight * 31)
        return baseNorm + activityLevel.waterBonus
    }
    
    private var cupsCount: Int {
        Int(ceil(Double(waterNorm) / cupSize))
    }
    
    private var cupsLeft: Int {
        max(cupsCount - cupsDrunkToday, 0)
    }
    
    private var mlLeft: Int {
        max(waterNorm - cupsDrunkToday * Int(cupSize), 0)
    }
    
    private var progress: Double {
        cupsCount == 0 ? 0 : min(Double(cupsDrunkToday) / Double(cupsCount), 1)
    }
    
    private var history: [DayRecord] {
        if let decoded = try? JSONDecoder().decode([DayRecord].self, from: historyData) {
            return decoded
        }
        return []
    }
    
    var body: some View {
        ZStack {
            WaterBalanceBackground()
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        VStack(spacing: 10) {
                            Text("Your Daily Norm")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("\(waterNorm) ml")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.blue)
                            
                            Text("\(cupsCount) cups of \(Int(cupSize)) ml")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .waterTimeCard()
                        
                        // Cups
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 20)
                        ], spacing: 20) {
                            ForEach(0..<cupsCount, id: \.self) { index in
                                WaterCupView(
                                    index: index + 1,
                                    isFilled: index < cupsDrunkToday,
                                    onTap: {
                                        toggleCup(index)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Tips
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Tips")
                                .font(.headline)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                TipRow(icon: "clock.fill", text: "Spread your water intake throughout the day")
                                TipRow(icon: "drop.fill", text: "Drink water 30 minutes before meals")
                                TipRow(icon: "sun.max.fill", text: "Start your day with a glass of water")
                                TipRow(icon: "moon.fill", text: "Have your last glass 2 hours before sleep")
                            }
                        }
                        .waterTimeCard()
                    }
                    .padding(.bottom, 32)
                    .padding(.top)
                }
                // Bottom section
                VStack(spacing: 8) {
                    Divider()
                    Text("Left: \(cupsLeft) cup\(cupsLeft == 1 ? "" : "s") / \(mlLeft) ml")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Button(action: {
                        if isDayCompleted {
                            showAlreadyCompletedAlert = true
                        } else {
                            showCompleteDayAlert = true
                        }
                    }) {
                        Text(isDayCompleted ? "Day Completed" : "Complete Day")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isDayCompleted ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(isDayCompleted)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .background(Color.white.opacity(0.01))
            }
        }
        .navigationTitle("Water Cups")
        .alert("Complete Day", isPresented: $showCompleteDayAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Complete") {
                completeDay()
            }
        } message: {
            Text("Are you sure you want to complete this day? This will save your progress and reset the counter.")
        }
        .alert("Congratulations!", isPresented: $showCongrats) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You have reached your daily water goal!")
        }
        .alert("Day already completed", isPresented: $showAlreadyCompletedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You have already completed this day. Come back tomorrow!")
        }
        .onAppear {
            checkAndResetCupsIfNeeded()
            checkDayCompleted()
        }
    }
    
    private func toggleCup(_ index: Int) {
        if index < cupsDrunkToday {
            cupsDrunkToday = index
        } else if index == cupsDrunkToday && cupsDrunkToday < cupsCount {
            cupsDrunkToday += 1
            if cupsDrunkToday == cupsCount {
                showCongrats = true
            }
        }
    }
    
    private func checkAndResetCupsIfNeeded() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        if cupsDrunkDate.isEmpty || cupsDrunkDate != today {
            cupsDrunkDate = today
            cupsDrunkToday = 0
        }
    }
    
    private func checkDayCompleted() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        if let last = history.last, last.date == today {
            isDayCompleted = true
        } else {
            isDayCompleted = false
        }
    }
    
    private func completeDay() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        var currentHistory = history
        currentHistory.removeAll { $0.date == today }
        let record = DayRecord(
            date: today,
            cupsDrunk: cupsDrunkToday,
            targetCups: cupsCount,
            isCompleted: cupsDrunkToday >= cupsCount
        )
        currentHistory.append(record)
        if let encoded = try? JSONEncoder().encode(currentHistory) {
            historyData = encoded
        }
        cupsDrunkToday = 0
        cupsDrunkDate = today
        isDayCompleted = true
    }
}

struct WaterCupView: View {
    let index: Int
    var isFilled: Bool
    var onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isFilled ? "cup.and.saucer.fill" : "cup.and.saucer")
                .font(.system(size: 40))
                .foregroundColor(isFilled ? .blue : .gray)
                .frame(width: 80, height: 80)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                )
            
            Text("Cup \(index)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                onTap()
            }
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

struct DayRecord: Codable {
    let date: String
    let cupsDrunk: Int
    let targetCups: Int
    let isCompleted: Bool
} 
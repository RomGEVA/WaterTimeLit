import SwiftUI

struct AchievementsView: View {
    @AppStorage("history") private var historyData: Data = Data()
    @AppStorage("streakCount") private var streakCount: Int = 0
    
    private var history: [DayRecord] {
        if let decoded = try? JSONDecoder().decode([DayRecord].self, from: historyData) {
            return decoded.sorted { $0.date > $1.date }
        }
        return []
    }
    
    private var achievements: [Achievement] {
        [
            Achievement(
                id: "bronze",
                title: "3 Days Streak",
                description: "Complete your water goal for 3 days in a row",
                icon: "3.circle.fill",
                isUnlocked: streakCount >= 3
            ),
            Achievement(
                id: "silver",
                title: "7 Days Streak",
                description: "Complete your water goal for 7 days in a row",
                icon: "7.circle.fill",
                isUnlocked: streakCount >= 7
            ),
            Achievement(
                id: "gold",
                title: "30 Days Streak",
                description: "Complete your water goal for 30 days in a row",
                icon: "30.circle.fill",
                isUnlocked: streakCount >= 30
            )
        ]
    }
    
    var body: some View {
        ZStack {
            WaterBalanceBackground()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Current Streak
                    VStack(spacing: 15) {
                        Text("Current Streak")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            
                            Text("\(streakCount) days")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.orange)
                        }
                    }
                    .waterTimeCard()
                    
                    // Achievements
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Achievements")
                            .font(.headline)
                        
                        ForEach(achievements) { achievement in
                            AchievementRow(achievement: achievement)
                        }
                    }
                    .waterTimeCard()
                }
                .padding()
            }
        }
        .navigationTitle("Achievements")
        .onAppear {
            updateStreak()
        }
    }
    
    private func updateStreak() {
        var currentStreak = 0
        let sortedHistory = history.sorted { $0.date > $1.date }
        
        for record in sortedHistory {
            if record.isCompleted {
                currentStreak += 1
            } else {
                break
            }
        }
        
        streakCount = currentStreak
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: achievement.icon)
                .font(.system(size: 30))
                .foregroundColor(achievement.isUnlocked ? .blue : .gray)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: achievement.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                .foregroundColor(achievement.isUnlocked ? .green : .gray)
                .font(.title2)
        }
        .padding(.vertical, 8)
    }
} 
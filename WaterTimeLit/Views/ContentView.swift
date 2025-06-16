import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WaterCupsView()
                .tabItem {
                    Label("Cups", systemImage: "cup.and.saucer.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            
            AchievementsView()
                .tabItem {
                    Label("Achievements", systemImage: "trophy.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
} 
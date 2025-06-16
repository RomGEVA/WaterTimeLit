//
//  ChooseStartView.swift
//  WaterTimeLit
//
//  Created by Роман Главацкий on 16.06.2025.
//

import SwiftUI

struct ChooseStartView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    init() {
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
    }
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView()
        } else {
            ContentView()
        }
    }
}

#Preview {
    ChooseStartView()
}

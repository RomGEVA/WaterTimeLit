import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("userWeight") private var weight: Double = 70
    @AppStorage("userGender") private var gender: Int = 1
    @AppStorage("userActivityLevel") private var activityLevel: ActivityLevel = .medium
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to WaterTime! 💧",
            description: "Track your daily water intake and stay hydrated with our simple and beautiful app.",
            imageName: "drop.fill"
        ),
        OnboardingPage(
            title: "Your Personal Water Norm",
            description: "We calculate your daily water intake based on your weight, gender, and activity level.",
            imageName: "person.fill"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Mark your cups as you drink and see your progress throughout the day.",
            imageName: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Stay Hydrated",
            description: "Get gentle reminders to drink water and maintain your healthy habits.",
            imageName: "bell.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            WaterBalanceBackground()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count + 1, id: \.self) { index in
                        if index < pages.count {
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        } else {
                            OnboardingUserParamsView(weight: $weight, gender: $gender, activityLevel: $activityLevel)
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                if currentPage == pages.count {
                    Button(action: {
                        withAnimation {
                            hasSeenOnboarding = true
                        }
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(weight > 0 ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(weight <= 0)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

struct OnboardingUserParamsView: View {
    @Binding var weight: Double
    @Binding var gender: Int
    @Binding var activityLevel: ActivityLevel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("Personalize your norm")
                .font(.title2)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 18) {
                Text("Weight (kg)")
                    .font(.headline)
                TextField("Enter your weight", value: $weight, format: .number)
                    .keyboardType(.decimalPad)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                Text("Gender")
                    .font(.headline)
                Picker("Gender", selection: $gender) {
                    Text("Male").tag(1)
                    Text("Female").tag(0)
                }
                .pickerStyle(.segmented)
                Text("Activity Level")
                    .font(.headline)
                Picker("Activity Level", selection: $activityLevel) {
                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(.menu)
                Text("Your daily activity level (affects your water norm)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
        }
        .padding()
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding()
    }
} 
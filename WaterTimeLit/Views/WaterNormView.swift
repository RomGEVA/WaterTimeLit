import SwiftUI

enum ActivityLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var waterBonus: Int {
        switch self {
        case .low: return 0
        case .medium: return 350
        case .high: return 700
        }
    }
}

struct WaterNormView: View {
    @AppStorage("userWeight") private var weight: Double = 70
    @AppStorage("userGender") private var gender: Int = 1 // 1 = Male, 0 = Female
    @AppStorage("userActivityLevel") private var activityLevel: ActivityLevel = .medium
    @AppStorage("cupSize") private var cupSize: Double = 250
    
    @State private var showingResult = false
    
    let genderOptions = [1, 0]
    let genderLabels = ["Male", "Female"]
    let genderIcons = ["person.fill", "person.fill"]
    
    private var waterNorm: Int {
        let baseNorm = gender == 1 ? Int(weight * 35) : Int(weight * 31)
        return baseNorm + activityLevel.waterBonus
    }
    
    private var cupsCount: Int {
        Int(ceil(Double(waterNorm) / cupSize))
    }
    
    var body: some View {
        ZStack {
            WaterBalanceBackground()
            ScrollView {
                VStack(spacing: 24) {
                    Text("My Water Norm")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Weight (kg)")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        BubbleInputField(value: $weight, placeholder: "Enter your weight")
                    }
                    .waterTimeCard()
                    
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Gender")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        AquaTabBar(options: genderOptions, selected: $gender, icons: genderIcons, labels: genderLabels)
                    }
                    .waterTimeCard()
                    
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Activity Level")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Button(action: { activityLevel = level }) {
                                HStack {
                                    Text(level.rawValue)
                                    Spacer()
                                    if activityLevel == level {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.cyan)
                                    }
                                }
                            }
                            .buttonStyle(WaterTimeButtonStyle())
                            .background(activityLevel == level ? Color.cyan.opacity(0.13) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .waterTimeCard()
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("\(waterNorm) ml — this is \(cupsCount) cup\(cupsCount == 1 ? "" : "s") of \(Int(cupSize)) ml")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.teal)
                            .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
    }
} 
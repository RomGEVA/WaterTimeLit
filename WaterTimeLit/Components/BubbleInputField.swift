import SwiftUI

struct BubbleInputField: View {
    @Binding var value: Double
    var placeholder: String = "Enter value"
    var icon: String = "drop.fill"
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AquaTheme.accent)
                .shadow(color: AquaTheme.accentLight.opacity(0.5), radius: 4, x: 0, y: 2)
            TextField(placeholder, value: $value, format: .number)
                .keyboardType(.decimalPad)
                .font(.title2.weight(.semibold))
                .foregroundColor(AquaTheme.text)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 22)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AquaTheme.background.opacity(0.85),
                                Color.white.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: AquaTheme.shadow1, radius: 12, x: 0, y: 6)
                    .shadow(color: AquaTheme.shadow2.opacity(0.3), radius: 2, x: 0, y: 1)
                Circle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 60, height: 30)
                    .offset(x: -40, y: -28)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(AquaTheme.accent, lineWidth: 2)
        )
        .padding(.horizontal, 8)
    }
} 
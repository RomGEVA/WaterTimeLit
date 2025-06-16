import SwiftUI

struct WaterTimeGradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBlue).opacity(0.18), Color(.systemTeal).opacity(0.22), Color(.systemBackground)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func waterTimeBackground() -> some View {
        self.modifier(WaterTimeGradientBackground())
    }
}

struct WaterTimeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemTeal), Color(.systemBlue)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
            )
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color(.systemBlue).opacity(0.18), radius: 10, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct WaterTimeTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundColor(.teal)
            configuration
        }
        .padding(14)
        .background(
            BlurView(style: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.systemTeal).opacity(0.5), lineWidth: 1)
        )
    }
}

struct WaterTimeCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                BlurView(style: .systemUltraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color(.systemTeal).opacity(0.13), lineWidth: 1)
            )
            .shadow(color: Color(.systemTeal).opacity(0.13), radius: 16, x: 0, y: 8)
    }
}

extension View {
    func waterTimeCard() -> some View {
        modifier(WaterTimeCardStyle())
    }
}

// MARK: - BlurView for glassmorphism
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
} 
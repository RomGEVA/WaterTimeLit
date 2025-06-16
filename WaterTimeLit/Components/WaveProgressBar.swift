import SwiftUI

struct WaveProgressBar: View {
    var progress: Double // 0...1
    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AquaTheme.background)
                .frame(height: 32)
                .shadow(color: AquaTheme.shadow1, radius: 6, x: 0, y: 2)
            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    WaveShape2(phase: phase, progress: progress)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [AquaTheme.accent, AquaTheme.accentLight]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(progress), height: 32)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)
                }
            }
            .frame(height: 32)
        }
        .frame(width: 220)
        .overlay(
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundColor(AquaTheme.text)
                .padding(.horizontal, 8),
            alignment: .center
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

struct WaveShape2: Shape {
    var phase: CGFloat
    var progress: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let amplitude: CGFloat = 6
        let baseHeight = rect.height / 2
        path.move(to: CGPoint(x: 0, y: rect.height))
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / rect.width
            let y = baseHeight + sin(relativeX * .pi * 2 + phase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
} 
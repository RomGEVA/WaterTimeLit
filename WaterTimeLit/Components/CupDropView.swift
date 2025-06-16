import SwiftUI

struct CupDropView: View {
    var filled: Bool
    var index: Int
    var onTap: () -> Void
    @State private var animateFill = false

    var body: some View {
        ZStack {
            DropShape()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: filled ? [AquaTheme.accent, AquaTheme.accentLight] : [AquaTheme.background, Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 54, height: 72)
                .shadow(color: filled ? AquaTheme.accent.opacity(0.18) : .clear, radius: 8, x: 0, y: 4)
                .overlay(
                    DropShape()
                        .stroke(AquaTheme.accentDark.opacity(0.18), lineWidth: 2)
                )
                .scaleEffect(animateFill ? 1.08 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animateFill)
            if filled {
                Image(systemName: "checkmark")
                    .font(.title2)
                    .foregroundColor(.white)
                    .offset(y: 10)
                    .opacity(0.8)
            }
        }
        .onTapGesture {
            animateFill = true
            onTap()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                animateFill = false
            }
        }
    }
}

struct DropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
} 
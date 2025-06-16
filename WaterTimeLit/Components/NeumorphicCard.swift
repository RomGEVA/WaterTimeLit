import SwiftUI

struct NeumorphicCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(AquaTheme.card)
                    .shadow(color: AquaTheme.shadow1, radius: 10, x: 0, y: 6)
                    .shadow(color: AquaTheme.shadow2.opacity(0.18), radius: 2, x: 0, y: 1)
            )
            .padding(.vertical, 6)
    }
} 
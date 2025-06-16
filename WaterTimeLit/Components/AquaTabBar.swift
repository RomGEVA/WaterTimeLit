import SwiftUI

struct AquaTabBar<T: Hashable>: View {
    let options: [T]
    @Binding var selected: T
    var icons: [String]
    var labels: [String]
    @Namespace private var tabAnim
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Array(options.enumerated()), id: \ .element) { idx, option in
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selected = option
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: icons[idx])
                            .font(.headline)
                            .foregroundColor(selected == option ? .white : AquaTheme.accentDark)
                        Text(labels[idx])
                            .font(.headline)
                            .foregroundColor(selected == option ? .white : AquaTheme.accentDark)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(
                        ZStack {
                            if selected == option {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [AquaTheme.accent, AquaTheme.accentLight]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: AquaTheme.accent.opacity(0.25), radius: 8, x: 0, y: 4)
                                    .matchedGeometryEffect(id: "tab", in: tabAnim)
                            }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.5))
        )
    }
} 
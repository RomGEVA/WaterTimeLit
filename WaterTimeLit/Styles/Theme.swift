import SwiftUI

struct AquaTheme {
    static let background = Color(hex: "#DDF8FF")
    static let accent = Color(hex: "#00B4D8")
    static let accentDark = Color(hex: "#0077B6")
    static let accentLight = Color(hex: "#90E0EF")
    static let shadow1 = Color(hex: "#CAE9F2")
    static let shadow2 = Color(hex: "#A3D4E0")
    static let text = Color(hex: "#023E8A")
    static let card = Color.white.opacity(0.85)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
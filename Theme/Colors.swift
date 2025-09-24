import SwiftUI

extension Color {
    static let theme = Theme()
}

struct Theme {
    // Custom dark background colors
    let background = Color(light: .white, dark: Color(red: 0.11, green: 0.11, blue: 0.12))
    let cardBackground = Color(light: .white.opacity(0.8), dark: Color(red: 0.15, green: 0.15, blue: 0.16))
    let secondaryBackground = Color(light: Color(red: 0.96, green: 0.96, blue: 0.98), dark: Color(red: 0.18, green: 0.18, blue: 0.20))
    
    // Accent colors
    let accent = Color(light: .blue, dark: Color(red: 0.1, green: 0.6, blue: 1.0))
    let secondaryAccent = Color(light: .orange, dark: Color(red: 1.0, green: 0.6, blue: 0.1))
    
    // Text colors
    let primaryText = Color(light: .black, dark: .white)
    let secondaryText = Color(light: .gray, dark: .gray.opacity(0.8))
}

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}

// MARK: - Custom Colors
extension Color {
    static var systemBackground: Color {
        Color(UIColor.systemBackground)
    }
    
    static var secondarySystemBackground: Color {
        Color(UIColor.secondarySystemBackground)
    }
    
    static var tertiarySystemBackground: Color {
        Color(UIColor.tertiarySystemBackground)
    }
}

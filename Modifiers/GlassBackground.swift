import SwiftUI

public struct GlassBackground: ViewModifier {
    let opacity: Double
    
    public init(opacity: Double = 0.3) {
        self.opacity = opacity
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                TranslucentBackground(opacity: opacity)
            )
    }
}

struct TranslucentBackground: View {
    let opacity: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Blur layer
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0.3),
                        .white.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(opacity)
                
                // Subtle border
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.6),
                                .white.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

public extension View {
    func glassBackground(opacity: Double = 0.3) -> some View {
        self.modifier(GlassBackground(opacity: opacity))
    }
}

import SwiftUI

struct SpringButtonStyle: ButtonStyle {
    @State private var isPressed = false
    
    let scale: CGFloat
    let haptic: UIImpactFeedbackGenerator.FeedbackStyle
    
    init(scale: CGFloat = 0.95, haptic: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        self.scale = scale
        self.haptic = haptic
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    UIImpactFeedbackGenerator(style: haptic).impactOccurred()
                }
            }
    }
}

extension View {
    func springButton(
        scale: CGFloat = 0.95,
        haptic: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        buttonStyle(SpringButtonStyle(scale: scale, haptic: haptic))
    }
}

struct SpringPressModifier: ViewModifier {
    @GestureState private var isPressed = false
    @State private var animationScale: CGFloat = 1
    
    let scale: CGFloat
    let haptic: UIImpactFeedbackGenerator.FeedbackStyle
    let onPress: () -> Void
    
    init(
        scale: CGFloat = 0.95,
        haptic: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        onPress: @escaping () -> Void
    ) {
        self.scale = scale
        self.haptic = haptic
        self.onPress = onPress
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(animationScale)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
                    .onEnded { _ in
                        onPress()
                    }
            )
            .onChange(of: isPressed) { newValue in
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                    animationScale = newValue ? scale : 1.0
                }
                if newValue {
                    UIImpactFeedbackGenerator(style: haptic).impactOccurred()
                }
            }
    }
}

extension View {
    func springPress(
        scale: CGFloat = 0.95,
        haptic: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        onPress: @escaping () -> Void
    ) -> some View {
        modifier(SpringPressModifier(scale: scale, haptic: haptic, onPress: onPress))
    }
}

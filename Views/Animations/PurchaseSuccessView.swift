import SwiftUI

struct PurchaseSuccessView: View {
    let onComplete: () -> Void
    @State private var scale = 0.0
    @State private var opacity = 0.0
    @State private var rotation = -30.0
    @State private var showCheck = false
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.green)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .opacity(opacity)
            
            // Burrito emoji with rotation
            Text("🌯")
                .font(.system(size: 40))
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
            
            // Checkmark
            if showCheck {
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1
                opacity = 1
                rotation = 0
            }
            
            // Show checkmark after burrito spins
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showCheck = true
                }
            }
            
            // Hide after delay and call completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.2)) {
                    scale = 1.2
                    opacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    PurchaseSuccessView {
        print("Animation completed")
    }
}

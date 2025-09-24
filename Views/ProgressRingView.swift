import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color(.systemGray6), lineWidth: 20)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: progress)
        }
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView(progress: 0.7)
            .frame(width: 200, height: 200)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
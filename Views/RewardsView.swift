import SwiftUI

struct RewardsView: View {
    @StateObject var viewModel: RewardsViewModel
    @State private var showingConfetti = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Points Display
                Text("\(viewModel.currentPoints) pts")
                    .font(.system(size: 36, weight: .heavy))
                    .padding(.vertical, 24)
                
                // Rewards List
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.rewards) { reward in
                        RewardCard(
                            reward: reward,
                            canRedeem: viewModel.canRedeemReward(reward)
                        ) {
                            if viewModel.redeemReward(reward) {
                                showingConfetti = true
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                
                                // Hide confetti after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showingConfetti = false
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Rewards")
        .overlay {
            if showingConfetti {
                ConfettiView()
            }
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    let canRedeem: Bool
    let onRedeem: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reward.title)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(reward.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button(action: onRedeem) {
                    Text("Redeem")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(canRedeem ? .white : .gray)
                        .frame(width: 100, height: 36)
                        .background(canRedeem ? Color.blue : Color(.systemGray4))
                        .cornerRadius(18)
                }
                .disabled(!canRedeem)
            }
            
            Text("\(reward.requiredPoints) pts")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(canRedeem ? .green : .secondary)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct ConfettiView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Canvas { context, size in
            let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple]
            let particleSize: CGFloat = 8
            let particleCount = 100
            
            for i in 0..<particleCount {
                let position = CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: isAnimating ? size.height + 100 : -100
                )
                
                let color = colors[i % colors.count]
                let path = Path(ellipseIn: CGRect(x: position.x, y: position.y, width: particleSize, height: particleSize))
                
                context.fill(path, with: .color(color))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 3)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    NavigationView {
        RewardsView(viewModel: RewardsViewModel(persistence: DefaultPersistence()))
    }
}

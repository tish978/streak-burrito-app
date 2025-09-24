import SwiftUI
import UIKit

struct RewardsView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @State private var showingRedeemAlert = false
    @State private var selectedReward: Reward?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Current Points Card
                VStack(spacing: 8) {
                    Text("\(viewModel.currentPoints)")
                        .font(.system(size: 48, weight: .heavy))
                    Text("AVAILABLE POINTS")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .glassBackground(opacity: 0.4)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 10, y: 2)
                
                // Rewards List
                ForEach(viewModel.rewards) { reward in
                    RewardCard(
                        reward: reward,
                        isAvailable: viewModel.canRedeem(reward),
                        onRedeem: {
                            selectedReward = reward
                            showingRedeemAlert = true
                        }
                    )
                }
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.theme.secondaryAccent.opacity(0.2),
                    Color.theme.accent.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Rewards")
        .alert("Redeem Reward?", isPresented: $showingRedeemAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Redeem", role: .none) {
                if let reward = selectedReward {
                    viewModel.redeemReward(reward)
                }
            }
        } message: {
            if let reward = selectedReward {
                Text("Would you like to redeem \(reward.title) for \(reward.requiredPoints) points?")
            }
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    let isAvailable: Bool
    let onRedeem: () -> Void
    @State private var isPressed = false
    
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
                
                Text(isAvailable ? "Redeem" : "Locked")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 36)
                    .background(isAvailable ? Color.theme.accent : Color.gray)
                    .cornerRadius(18)
                    .springPress(scale: 0.92, haptic: .medium) {
                        if isAvailable {
                            onRedeem()
                        }
                    }
                    .opacity(isAvailable ? 1.0 : 0.7)
            }
            
            Text("\(reward.requiredPoints) pts")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isAvailable ? .green : .secondary)
        }
        .padding(16)
        .glassBackground(opacity: isAvailable ? 0.3 : 0.15)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 10, y: 2)
        .opacity(isAvailable ? 1.0 : 0.7)
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RewardsView(viewModel: RewardsViewModel(
                pointsService: PointsService.shared
            ))
        }
    }
}

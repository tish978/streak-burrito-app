import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showingResetAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Points Card
                VStack(spacing: 16) {
                    ZStack {
                        ProgressRingView(progress: viewModel.progressToNextReward)
                            .frame(width: 200, height: 200)
                        
                        VStack(spacing: 4) {
                            Text("\(viewModel.points)")
                                .font(.system(size: 56, weight: .heavy))
                                .contentTransition(.numericText())
                            Text("TOTAL POINTS")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Next Reward Text
                    Text("Next reward at \(viewModel.nextRewardPoints) pts")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(32)
                .background(Color(.systemBackground))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                
                // Streak Card
                VStack(spacing: 8) {
                    Text("\(viewModel.streak)")
                        .font(.system(size: 44, weight: .heavy))
                    Text("DAY STREAK")
                        .font(.system(size: 13, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(24)
                
                // Order Button
                Button {
                    viewModel.placeTestOrder()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    Text("Place Test Order (+75)")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(28)
                }
                .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button {
                        viewModel.sendTestNotification()
                    } label: {
                        Text("Test Notification")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(.systemBackground))
                            .foregroundColor(.blue)
                            .cornerRadius(18)
                    }
                    
                    Button {
                        viewModel.scheduleDailyReminder()
                    } label: {
                        Text("Daily Reminder")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(.systemBackground))
                            .foregroundColor(.blue)
                            .cornerRadius(18)
                    }
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                
                // Reset Button
                Button {
                    showingResetAlert = true
                } label: {
                    Text("Reset Points")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.red)
                }
            }
            .padding(24)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Streak Burrito")
        .alert("Reset Points?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                withAnimation {
                    viewModel.resetPoints()
                }
            }
        } message: {
            Text("This will reset your points to 0. This action cannot be undone.")
        }
    }
}

// MARK: - ProgressRingView
private struct ProgressRingView: View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(viewModel: HomeViewModel(
                pointsService: PointsService.shared,
                notificationService: NotificationService()
            ))
        }
    }
}

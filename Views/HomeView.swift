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
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    
                    // Next Reward Text
                    Text("Next reward at \(viewModel.nextRewardPoints) pts")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(32)
                .glassBackground()
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 12, x: 0, y: 4)
                
                // Streak Card
                VStack(spacing: 8) {
                    Text("\(viewModel.streak)")
                        .font(.system(size: 44, weight: .heavy))
                    Text("DAY STREAK")
                        .font(.system(size: 13, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .glassBackground(opacity: 0.4)
                .foregroundColor(Color.theme.secondaryAccent)
                .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
                
                // Order Button
                Button {
                    viewModel.placeTestOrder()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    Text("Place Test Order (+75)")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.theme.accent)
                        .foregroundColor(Color.theme.primaryText)
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
                            .background(Color.theme.cardBackground)
                            .foregroundColor(Color.theme.accent)
                            .cornerRadius(18)
                    }
                    
                    Button {
                        viewModel.scheduleDailyReminder()
                    } label: {
                        Text("Daily Reminder")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.theme.cardBackground)
                            .foregroundColor(Color.theme.accent)
                            .cornerRadius(18)
                    }
                }
                .padding(16)
                .glassBackground(opacity: 0.2)
                
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
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.theme.accent.opacity(0.2),
                    Color.theme.secondaryAccent.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
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
                .stroke(Color.theme.secondaryBackground, lineWidth: 20)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    Color.theme.accent,
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

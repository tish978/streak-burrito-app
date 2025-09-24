import Foundation
import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published private(set) var points: Int = 0
    @Published private(set) var streak: Int = 0
    @Published private(set) var progressToNextReward: Double = 0.0
    @Published private(set) var nextRewardPoints: Int = 100
    
    private let pointsService: PointsService
    private let notificationService: NotificationService
    private var cancellables = Set<AnyCancellable>()
    
    // Reward tiers for progress calculation
    private let rewardTiers = [100, 200, 500, 1000, 2000]
    
    init(pointsService: PointsService, notificationService: NotificationService) {
        self.pointsService = pointsService
        self.notificationService = notificationService
        
        setupBindings()
        updateState()
    }
    
    private func setupBindings() {
        // Bind to pointsService updates
        pointsService.$currentPoints
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPoints in
                self?.points = newPoints
                self?.updateProgress()
                print("HomeViewModel points updated to: \(newPoints)")
            }
            .store(in: &cancellables)
    }
    
    func updateState() {
        points = pointsService.currentPoints
        updateProgress()
    }
    
    private func updateProgress() {
        // Find current tier and next tier
        let currentTier = rewardTiers.filter { $0 <= points }.max() ?? 0
        nextRewardPoints = rewardTiers.first { $0 > points } ?? rewardTiers.last ?? 100
        
        // Calculate progress to next tier
        let progressPoints = points - currentTier
        let tierSize = nextRewardPoints - currentTier
        
        // Update progress (0 to 1)
        progressToNextReward = Double(progressPoints) / Double(tierSize)
        
        print("HomeViewModel state updated - Points: \(points), Progress: \(progressToNextReward)")
        objectWillChange.send()
    }
    
    func placeTestOrder() {
        pointsService.addPoints(75)
    }
    
    func resetPoints() {
        pointsService.resetPoints()
    }
    
    func sendTestNotification() {
        notificationService.fireTestNotification()
    }
    
    func scheduleDailyReminder() {
        notificationService.scheduleDailyReminder()
    }
}

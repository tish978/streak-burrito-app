import Foundation
import SwiftUI
import Combine

@MainActor
class RewardsViewModel: ObservableObject {
    @Published private(set) var rewards: [Reward]
    @Published private(set) var currentPoints: Int = 0
    
    private let pointsService: PointsService
    private var cancellables = Set<AnyCancellable>()
    
    init(pointsService: PointsService) {
        self.pointsService = pointsService
        
        // Initialize with mock rewards
        self.rewards = [
            Reward(id: UUID(), title: "Free Burrito", description: "Any burrito of your choice, on us!", requiredPoints: 500),
            Reward(id: UUID(), title: "Free Drink", description: "Any fountain drink or bottled beverage", requiredPoints: 100),
            Reward(id: UUID(), title: "Extra Protein", description: "Double the protein in any item", requiredPoints: 200),
            Reward(id: UUID(), title: "Free Guacamole", description: "Add guacamole to any item for free", requiredPoints: 150),
            Reward(id: UUID(), title: "Meal Deal", description: "Any combo meal with drink and side", requiredPoints: 750)
        ]
        
        // Sort rewards by required points
        self.rewards.sort { $0.requiredPoints < $1.requiredPoints }
        
        setupBindings()
        updatePoints()
    }
    
    private func setupBindings() {
        pointsService.$currentPoints
            .receive(on: DispatchQueue.main)
            .sink { [weak self] points in
                self?.currentPoints = points
            }
            .store(in: &cancellables)
    }
    
    private func updatePoints() {
        currentPoints = pointsService.currentPoints
    }
    
    func canRedeem(_ reward: Reward) -> Bool {
        return currentPoints >= reward.requiredPoints
    }
    
    func redeemReward(_ reward: Reward) {
        guard canRedeem(reward) else { return }
        
        if pointsService.redeemPoints(reward.requiredPoints) {
            print("Successfully redeemed \(reward.title) for \(reward.requiredPoints) points")
        }
    }
}

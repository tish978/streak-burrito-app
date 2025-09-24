import Foundation
import Combine

@MainActor
class RewardsViewModel: ObservableObject {
    @Published private(set) var rewards: [Reward]
    @Published private(set) var currentPoints: Int = 0
    
    private let pointsService: PointsService
    private var cancellables = Set<AnyCancellable>()
    
    init(persistence: Persistence) {
        self.pointsService = PointsService(persistence: persistence)
        
        // Initialize with mock rewards
        self.rewards = [
            Reward(
                title: "Free Chips & Salsa",
                description: "Get a free side of chips and your choice of salsa",
                requiredPoints: 100
            ),
            Reward(
                title: "Free Guacamole",
                description: "Add fresh guacamole to any order",
                requiredPoints: 200
            ),
            Reward(
                title: "Free Burrito",
                description: "Any burrito of your choice with toppings",
                requiredPoints: 500
            ),
            Reward(
                title: "Free Meal",
                description: "Any meal with drink and side included",
                requiredPoints: 1000
            ),
            Reward(
                title: "Catering Pack",
                description: "Feed the whole team! Serves 10-12 people",
                requiredPoints: 2000
            )
        ]
        
        setupBindings()
        updatePoints()
    }
    
    private func setupBindings() {
        pointsService.$currentPoints
            .sink { [weak self] _ in
                self?.updatePoints()
            }
            .store(in: &cancellables)
    }
    
    private func updatePoints() {
        currentPoints = pointsService.currentPoints
    }
    
    func canRedeemReward(_ reward: Reward) -> Bool {
        return currentPoints >= reward.requiredPoints
    }
    
    func redeemReward(_ reward: Reward) -> Bool {
        guard canRedeemReward(reward) else { return false }
        return pointsService.redeemPoints(reward.requiredPoints)
    }
}

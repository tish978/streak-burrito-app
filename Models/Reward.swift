import Foundation

struct Reward: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let requiredPoints: Int
}

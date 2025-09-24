import Foundation

struct Reward: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let requiredPoints: Int
}

import Foundation

struct UserProfile: Codable {
    var displayName: String
    var points: Int
    var currentStreak: Int
    var lastOrderDate: Date?
}

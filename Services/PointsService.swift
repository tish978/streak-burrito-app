import Foundation
import SwiftUI
import Combine

@MainActor
class PointsService: ObservableObject {
    static let shared: PointsService = {
        let persistence = DefaultPersistence()
        return PointsService(persistence: persistence)
    }()
    
    private let persistence: Persistence
    private let key = "userProfile"
    
    @Published private(set) var currentPoints: Int = 0
    
    init(persistence: Persistence) {
        self.persistence = persistence
        updatePoints()
        print("PointsService initialized with \(currentPoints) points")
    }
    
    private func updatePoints() {
        currentPoints = getUserProfile()?.points ?? 0
        print("Points updated to: \(currentPoints)")
        objectWillChange.send()
    }
    
    func addPoints(_ points: Int) {
        print("Adding \(points) points to current \(currentPoints)")
        var profile = getUserProfile() ?? UserProfile(displayName: "User", points: 0, currentStreak: 0, lastOrderDate: nil)
        profile.points += points
        saveUserProfile(profile)
        updatePoints()
        print("New total points: \(currentPoints)")
        
        // Post notification for UI update
        NotificationCenter.default.post(name: .pointsUpdated, object: nil)
    }
    
    func redeemPoints(_ points: Int) -> Bool {
        guard let profile = getUserProfile(), profile.points >= points else { return false }
        var updatedProfile = profile
        updatedProfile.points -= points
        saveUserProfile(updatedProfile)
        updatePoints()
        
        // Post notification for UI update
        NotificationCenter.default.post(name: .pointsUpdated, object: nil)
        return true
    }
    
    func resetPoints() {
        var profile = getUserProfile() ?? UserProfile(displayName: "User", points: 0, currentStreak: 0, lastOrderDate: nil)
        profile.points = 0
        saveUserProfile(profile)
        updatePoints()
        
        // Post notification for UI update
        NotificationCenter.default.post(name: .pointsUpdated, object: nil)
    }
    
    private func getUserProfile() -> UserProfile? {
        return persistence.load(forKey: key)
    }
    
    private func saveUserProfile(_ profile: UserProfile) {
        persistence.save(profile, forKey: key)
    }
}

extension Notification.Name {
    static let pointsUpdated = Notification.Name("pointsUpdated")
}

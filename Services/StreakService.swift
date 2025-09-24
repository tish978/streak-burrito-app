import Foundation

@MainActor
class StreakService: ObservableObject {
    private let persistence: Persistence
    private let key = "userProfile"
    private let calendar = Calendar.current
    
    @Published private(set) var currentStreak: Int = 0
    
    init(persistence: Persistence) {
        self.persistence = persistence
        updateStreak()
    }
    
    private func updateStreak() {
        currentStreak = getUserProfile()?.currentStreak ?? 0
    }
    
    func incrementStreak() {
        var profile = getUserProfile() ?? UserProfile(displayName: "User", points: 0, currentStreak: 0, lastOrderDate: nil)
        let now = Date()
        
        if let lastOrderDate = profile.lastOrderDate {
            // If last order was today, don't increment streak
            if calendar.isDate(lastOrderDate, inSameDayAs: now) {
                profile.lastOrderDate = now
                saveUserProfile(profile)
                return
            }
            
            // If last order was yesterday, increment streak
            if calendar.isDate(lastOrderDate, equalTo: calendar.date(byAdding: .day, value: -1, to: now)!, toGranularity: .day) {
                profile.currentStreak += 1
            } else {
                // If last order was before yesterday, reset streak to 1
                profile.currentStreak = 1
            }
        } else {
            // First order ever
            profile.currentStreak = 1
        }
        
        profile.lastOrderDate = now
        saveUserProfile(profile)
        updateStreak()
    }
    
    private func getUserProfile() -> UserProfile? {
        return persistence.load(forKey: key)
    }
    
    private func saveUserProfile(_ profile: UserProfile) {
        persistence.save(profile, forKey: key)
    }
}

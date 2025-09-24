import Foundation
import UserNotifications

@MainActor
class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        setupNotifications()
    }
    
    private func setupNotifications() {
        notificationCenter.delegate = self
        
        // Request authorization
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
                Task { @MainActor in
                    self.setupNotificationCategories()
                }
            } else if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
    }
    
    private func setupNotificationCategories() {
        // Create REDEEM_ACTION
        let redeemAction = UNNotificationAction(
            identifier: "REDEEM_ACTION",
            title: "Redeem Now",
            options: .foreground
        )
        
        // Create VIEW_REWARDS_ACTION
        let viewRewardsAction = UNNotificationAction(
            identifier: "VIEW_REWARDS_ACTION",
            title: "View Rewards",
            options: .foreground
        )
        
        // Create STREAK_CATEGORY with both actions
        let category = UNNotificationCategory(
            identifier: "STREAK_CATEGORY",
            actions: [redeemAction, viewRewardsAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Register the category
        notificationCenter.setNotificationCategories([category])
    }
    
    func fireTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🌯 Streak Burrito"
        content.body = "Your burrito streak is on fire! 🔥 Check out your rewards!"
        content.sound = .default
        content.categoryIdentifier = "STREAK_CATEGORY"
        content.userInfo = ["deeplink": "streakburrito://rewards"]
        
        // Add image attachment
        if let imageURL = Bundle.main.url(forResource: "confetti", withExtension: "png") {
            do {
                let attachment = try UNNotificationAttachment(
                    identifier: "confetti",
                    url: imageURL,
                    options: nil
                )
                content.attachments = [attachment]
            } catch {
                print("Failed to attach image: \(error)")
            }
        }
        
        // Trigger in 2 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule test notification: \(error)")
            }
        }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🌯 Daily Streak Reminder"
        content.body = "Don't forget to order today to keep your streak going!"
        content.sound = .default
        content.categoryIdentifier = "STREAK_CATEGORY"
        content.userInfo = ["deeplink": "streakburrito://rewards"]
        
        // Create calendar components for 6 PM
        var components = DateComponents()
        components.hour = 18
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "dailyReminder",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule daily reminder: \(error)")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // Handle in app coordinator
    }
}

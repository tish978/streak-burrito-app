import SwiftUI

@main
struct StreakBurritoApp: App {
    private let persistence = DefaultPersistence()
    @StateObject private var pointsService = PointsService.shared
    @StateObject private var notificationService = NotificationService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.persistence, persistence)
                .environmentObject(pointsService)
                .environmentObject(notificationService)
        }
    }
}
import SwiftUI

struct ContentView: View {
    @Environment(\.persistence) private var persistence
    @EnvironmentObject private var pointsService: PointsService
    @EnvironmentObject private var notificationService: NotificationService
    
    var body: some View {
        TabView {
            NavigationView {
                HomeView(viewModel: HomeViewModel(
                    pointsService: pointsService,
                    notificationService: notificationService
                ))
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationView {
                OrderView(viewModel: OrderViewModel(
                    pointsService: pointsService
                ))
            }
            .tabItem {
                Label("Menu", systemImage: "list.bullet")
            }
            
            NavigationView {
                Text("Rewards Coming Soon!")
            }
            .tabItem {
                Label("Rewards", systemImage: "gift.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.persistence, DefaultPersistence())
            .environmentObject(PointsService.shared)
            .environmentObject(NotificationService())
    }
}

import Foundation
import Combine

@MainActor
class OrderViewModel: ObservableObject {
    @Published private(set) var menuItems: [MenuItem]
    private let pointsService: PointsService
    
    init(pointsService: PointsService) {
        self.pointsService = pointsService
        
        // Initialize with mock menu items
        self.menuItems = [
            MenuItem(id: UUID(), name: "Classic Burrito", description: "Your choice of protein with rice, beans, and fresh toppings", points: 75),
            MenuItem(id: UUID(), name: "Super Quesadilla", description: "Extra-large tortilla with melted cheese and fresh ingredients", points: 60),
            MenuItem(id: UUID(), name: "Loaded Nachos", description: "Crispy chips topped with all the favorites", points: 50),
            MenuItem(id: UUID(), name: "Taco Trio", description: "Three delicious tacos with your choice of filling", points: 45),
            MenuItem(id: UUID(), name: "Burrito Bowl", description: "All your favorite burrito ingredients in a bowl", points: 70)
        ]
    }
    
    func purchaseItem(_ item: MenuItem) {
        print("Purchasing item: \(item.name) for \(item.points) points")
        pointsService.addPoints(item.points)
    }
}

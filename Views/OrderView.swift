import SwiftUI
import UIKit

struct OrderView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.menuItems) { item in
                    MenuItemCard(item: item) {
                        viewModel.purchaseItem(item)
                    }
                }
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.theme.accent.opacity(0.2),
                    Color.theme.secondaryAccent.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Menu")
    }
}

struct MenuItemCard: View {
    let item: MenuItem
    let onBuy: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Text("Buy")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 36)
                    .background(Color.theme.accent)
                    .cornerRadius(18)
                    .springPress(scale: 0.92, haptic: .medium) {
                        onBuy()
                    }
            }
            
            Text("+\(item.points) pts")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.green)
        }
        .padding(16)
        .glassBackground(opacity: 0.3)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 10, y: 2)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderView(viewModel: OrderViewModel(
                pointsService: PointsService.shared
            ))
        }
    }
}

//
//  MainTabBarView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI

struct MainTabBarView: View {
    @State private var selectedTab: Int = 0
    @StateObject var carManager = CarManager()
    
    var body: some View {
        TabView {
            CarRentalCollectionView(carManager: carManager)
                .tabItem {
                    VStack {
                        Image(systemName: "list.clipboard")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Bookings Overview")
                    }
                }
                .onAppear {
                    selectedTab = 0
                }
            PieView(carManager: carManager, carType: CarType.electric, car: nil)
                .tabItem {
                    VStack {
                        Image(systemName: "dollarsign.circle")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Money Info")
                    }
                }
                .onAppear {
                    selectedTab = 1
                }
           CarListView(carManager: carManager)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        Text("List")
                    }
                }
                .onAppear {
                    selectedTab = 2
                }
        }
    }
}

#Preview {
    MainTabBarView()
}

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
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Home")
                    }
                }
                .onAppear {
                    selectedTab = 0
                }
           CarListView(carManager: carManager)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("List")
                    }
                }
                .onAppear {
                    selectedTab = 1
                }
        }
    }
}

#Preview {
    MainTabBarView()
}

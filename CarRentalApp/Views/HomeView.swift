//
//  HomeView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/29/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var carManager: CarManager
    
    @State private var selectedStartDate = Date()
    @State private var selectedEndDate = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                EarningsOverview(earnings: calculateEarnings())
                    .padding()
                MonthlyOverview(bookings: calculateBookings())
                    .padding()
                AvailabilityOverview(availableDays: calculateAvailableDays())
                    .padding()
            }
            
        }
        .navigationBarTitle("Home")
    }
    
    // Calculate total earnings
    private func calculateEarnings() -> Double {
        return carManager.cars.reduce(0) { $0 + $1.revenue }
    }
    
    // Calculate monthly bookings
    private func calculateBookings() -> Int {
        // Implement logic to calculate monthly bookings
        // You can use Date components to filter cars based on the month
        return 0
    }
    
    // Calculate available days
    private func calculateAvailableDays() -> Int {
        // Implement logic to calculate available days
        return 0
    }
}

struct EarningsOverview: View {
    let earnings: Double
    
    var body: some View {
        let formattedEarnings = formatCurrency(earnings)
        
        return Text("Total Earnings: \(formattedEarnings)")
            .font(.title)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct MonthlyOverview: View {
    let bookings: Int
    
    var body: some View {
        Text("Monthly Bookings: \(bookings)")
            .font(.title)
    }
}

struct AvailabilityOverview: View {
    let availableDays: Int
    
    var body: some View {
        Text("Available Days: \(availableDays)")
            .font(.title)
    }
}

#Preview {
    HomeView(carManager: CarManager())
}

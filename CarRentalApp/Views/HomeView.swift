//
//  HomeView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/29/24.
//

import SwiftUI
import Charts

struct HomeView: View {
    @ObservedObject var carManager: CarManager
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                EarningsOverview(earnings: calculateEarnings())
                    .padding()
                CarsOverview(carsRented: calculateNumberOfCarsRented())
                    .padding()
                AvailabilityOverview(daysTaken: carManager.totalRentedDays)
                    .padding()
            }
        }
        .navigationTitle("Home")
    }
    
    // Calculate total earnings
    private func calculateEarnings() -> Double {
        return carManager.cars.reduce(0) { $0 + $1.revenue }
    }
    
    // Calculate total number of days booked
    private func calculateDaysRented() -> Int {
        return carManager.totalRentedDays
    }
    
    // Calculate total number of cars rented
    private func calculateNumberOfCarsRented() -> Int {
        return carManager.cars.count
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

struct AvailabilityOverview: View {
    let daysTaken: Int
    
    var body: some View {
        Text("Total Days Booked: \(daysTaken)")
            .font(.title)
    }
}

struct CarsOverview: View {
    let carsRented: Int
    
    var body: some View {
        Text("Number of Cars Rented: \(carsRented)")
            .font(.title)
    }
}

#Preview {
    HomeView(carManager: CarManager())
}

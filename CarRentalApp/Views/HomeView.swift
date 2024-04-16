//
//  HomeView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/29/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var carManager: CarManager
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                EarningsOverview(carManager: carManager)
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
        return carManager.cars.reduce(0) { $0 + $1.pricePerDay }
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
    @ObservedObject var carManager: CarManager
    
    var body: some View {
        
        Text("Total Price: $\(formattedTotalRevenue)")
            .font(.title)
    }
    
    private var formattedTotalRevenue: String {
        let totalRevenue = carManager.cars.reduce(0) { $0 + $1.revenue }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(for: totalRevenue) ?? "\(totalRevenue)"
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

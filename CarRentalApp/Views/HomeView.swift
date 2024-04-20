//
//  HomeView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/29/24.
//

import SwiftUI

struct DaysOverview: View {
    @ObservedObject var carManager: CarManager
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                AvailabilityOverview(daysTaken: carManager.totalRentedDays)
                    .padding()
            }
        }
        .navigationTitle("Home")
    }

    // Calculate total number of days booked
    private func calculateDaysRented() -> Int {
        return carManager.totalRentedDays
    }
    
}

struct AvailabilityOverview: View {
    let daysTaken: Int
    
    var body: some View {
        Text("Total Days Booked: \(daysTaken)")
            .font(.title)
    }
}


#Preview {
    DaysOverview(carManager: CarManager())
}

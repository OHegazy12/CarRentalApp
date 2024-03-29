//
//  CarDetailView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI

struct CarDetailView: View {
    @ObservedObject var carManager: CarManager // Use @ObservedObject to observe changes
    @State var car: Car
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            Text("Car Name: \(car.name)")
            // Display other car details
            Text("Price per day: $\(formattedPrice)")
            Text("Dates Rented: \(formattedStartDate) - \(formattedEndDate)")
        }
        .navigationTitle(car.name)
        .navigationBarItems(trailing:
            Button(action: {
                isEditing = true
            }) {
                Image(systemName: "pencil")
            }
        )
        .sheet(isPresented: $isEditing) {
            NewCarInputView(carManager: carManager, carToEdit: car) {
                isEditing = false
            }
        }
        .onReceive(carManager.objectWillChange) { _ in
            // Update the car when changes are detected in the car manager
            if let updatedCar = carManager.cars.first(where: { $0.id == car.id }) {
                car = updatedCar
            }
        }
    }
    
    private var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: car.startDate)
    }
    
    private var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: car.endDate)
    }
    
    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter.string(for: car.revenue) ?? "\(car.revenue)"
    }
}


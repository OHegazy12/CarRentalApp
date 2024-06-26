//
//  NewCarInputView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI

struct NewCarInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var carManager: CarManager
    var carToEdit: Car? // Existing car details to be edited
    var onAddCar: () -> Void // Closure to be called when a new car is added or an existing one is edited
    
    @State private var carName: String
    @State private var rentalPrice: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var showAlert = false
    
    // Initialization
    init(carManager: CarManager, carToEdit: Car?, onAddCar: @escaping () -> Void) {
        self.carManager = carManager
        self.carToEdit = carToEdit
        
        // Set initial values based on existing car details for editing, or default values for new entry
        _carName = State(initialValue: carToEdit?.name ?? "")
        _rentalPrice = State(initialValue: "\(carToEdit?.revenue ?? 0)")
        _startDate = State(initialValue: carToEdit?.startDate ?? Date())
        _endDate = State(initialValue: carToEdit?.endDate ?? Date())
        
        self.onAddCar = onAddCar
    }
    
    var body: some View {
        Form {
            Section(header: Text("Car Details")) {
                TextField("Car Name", text: $carName)
                TextField("Rental Price Per Day", text: $rentalPrice)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Select Rental Dates")) {
                CalendarView(startDate: $startDate, endDate: $endDate)
            }
            
            Section {
                Button("Save") {
                    saveCar()
                }
            }
        }
        .navigationTitle(carToEdit != nil ? "Edit Car" : "Add New Car")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(carToEdit != nil ? "Car Updated" : "Car Added"), message: Text("The car details have been \(carToEdit != nil ? "updated" : "added") to the list."), dismissButton: .default(Text("OK")))
        }
    }
    
    func saveCar() {
        guard let price = Double(rentalPrice) else {
            // Show an alert indicating that rental price is invalid
            print("Error: Rental price is invalid.")
            return
        }
        
        if carName.isEmpty {
            // Show an alert indicating that car name is required
            print("Error: Car Name is required.")
            return
        }
        
        // Update existing car if editing, otherwise add new car
        if let index = carManager.cars.firstIndex(where: { $0.id == carToEdit?.id }) {
            carManager.cars[index].name = carName
            carManager.cars[index].startDate = startDate
            carManager.cars[index].endDate = endDate
            carManager.cars[index].revenue = price
        } else {
            let newCar = Car(name: carName, startDate: startDate, endDate: endDate, revenue: price)
            carManager.cars.append(newCar)
        }
        
        // Save the cars to UserDefaults
        carManager.saveCars()
        
        // Show the alert
        showAlert = true
        
        // Call the closure to notify that a new car is added or an existing one is edited
        onAddCar()
        
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}

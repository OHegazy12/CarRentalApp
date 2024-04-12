//
//  CarDetailView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI

struct CarDetailView: View {
    @ObservedObject var carManager: CarManager
    @State var car: Car
    @State private var isEditing = false
    @State private var carImage: UIImage?
    
    var body: some View {
        VStack {
            if let carImage = carImage {
                Image(uiImage: carImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
            
            Text("Car Name: \(car.name)")
            // Display other car details
            Text("Car Type: \(car.carType.rawValue.capitalized)")
            Text("Price Per Day: $\(formattedPrice)")
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
                loadCarImage()
            }
        }
        .onAppear {
            print("---> start: \(car.startDate) end: \(car.endDate)")
            loadCarImage()
        }
    }
    
    private func loadCarImage() {
        guard let imageData = car.imageData else { return }
        carImage = UIImage(data: imageData)
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
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(for: car.pricePerDay) ?? "\(car.pricePerDay)"
    }
}

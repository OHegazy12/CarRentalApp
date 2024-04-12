//
//  NewCarInputView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI
import UIKit

struct NewCarInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var carManager: CarManager
    var carToEdit: Car?
    var onAddCar: () -> Void
    
    @State private var carName: String = ""
    @State private var rentalPrice: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedCarType: CarType = .electric
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    init(carManager: CarManager, carToEdit: Car?, onAddCar: @escaping () -> Void) {
        self.carManager = carManager
        self.carToEdit = carToEdit
        self.onAddCar = onAddCar
        
        if let carToEdit = carToEdit {
            _carName = State(initialValue: carToEdit.name)
            _rentalPrice = State(initialValue: "\(carToEdit.pricePerDay)")
            _startDate = State(initialValue: carToEdit.startDate)
            _endDate = State(initialValue: carToEdit.endDate)
            _selectedCarType = State(initialValue: carToEdit.carType)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Car Details")) {
                    TextField("Car Name", text: $carName)
                    TextField("Rental Price Per Day", text: $rentalPrice)
                        .keyboardType(.numberPad)
                    
                    Picker("Car Type", selection: $selectedCarType) {
                        ForEach(CarType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                }
                
                Section(header: Text("Select Rental Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Upload Image")) {
                    Button(action: {
                        self.isShowingImagePicker.toggle()
                    }) {
                        Text("Select Image")
                    }
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    }
                }
                
                Section {
                    Button("Save") {
                        saveCar()
                    }
                }
            }
            .navigationTitle(carToEdit != nil ? "Edit Car" : "Add New Car")
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    func saveCar() {
        guard let pricePerDay = Double(rentalPrice), pricePerDay > 0 else {
            print("Error: Rental price per day is invalid.")
            return
        }
        
        if carName.isEmpty {
            print("Error: Car Name is required.")
            return
        }
        
        if let index = carManager.cars.firstIndex(where: { $0.id == carToEdit?.id }) {
            carManager.cars[index].name = carName
            carManager.cars[index].startDate = startDate
            carManager.cars[index].endDate = endDate
            carManager.cars[index].pricePerDay = pricePerDay
            carManager.cars[index].carType = selectedCarType
            carManager.cars[index].imageData = selectedImage?.jpegData(compressionQuality: 0.5)
        } else {
            let newCar = Car(name: carName, startDate: startDate, endDate: endDate, pricePerDay: pricePerDay, carType: selectedCarType, imageData: selectedImage?.jpegData(compressionQuality: 0.5))
            carManager.cars.append(newCar)
        }
        
        carManager.saveCars()
        onAddCar()
        presentationMode.wrappedValue.dismiss()
    }
}

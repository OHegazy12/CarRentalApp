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
    @State private var nameOfOwner: String = ""
    @State private var extraNotes: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedCarType: CarType = .electric
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var selectedColorHex: String = "#000000"
    
    var totalCost: Double {
        guard let pricePerDay = Double(rentalPrice), pricePerDay > 0 else {
            return 0
        }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return pricePerDay * Double(numberOfDays)
    }
    
    init(carManager: CarManager, carToEdit: Car?, onAddCar: @escaping () -> Void) {
        self.carManager = carManager
        self.carToEdit = carToEdit
        self.onAddCar = onAddCar
        
        if let carToEdit = carToEdit {
            _carName = State(initialValue: carToEdit.name)
            _rentalPrice = State(initialValue: "\(carToEdit.pricePerDay)")
            _nameOfOwner = State(initialValue: carToEdit.renterName)
            _startDate = State(initialValue: carToEdit.startDate)
            _endDate = State(initialValue: carToEdit.endDate)
            _selectedCarType = State(initialValue: carToEdit.carType)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Car Details")) {
                        TextField("Car Name", text: $carName)
                        TextField("Rental Price Per Day", text: $rentalPrice)
                            .keyboardType(.numberPad)
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        
                        Picker("Car Type", selection: $selectedCarType) {
                            ForEach(CarType.allCases, id: \.self) { type in
                                Text(type.rawValue.capitalized)
                            }
                        }
                    }
                    
                    Section(header: Text("Name Of Renter")) {
                        TextField("Name of Renter", text: $nameOfOwner)
                    }
                    
                    Section(header: Text("Extra Notes (Optional): ")) {
                        TextField("", text: $extraNotes, prompt: Text("Add description ✍️")
                            .fontWeight(.light)
                            .foregroundColor(Color(uiColor: .lightGray)))
                    }
                    
                    Section(header: Text("Color")) {
                        ColorPicker("Select Color", selection: Binding(
                            get: {
                                Color(hex: selectedColorHex)
                            },
                            set: { newColor in
                                selectedColorHex = newColor.toHex()
                            }
                        ))
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Select Rental Dates")) {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Total Cost of Rental")) {
                        Text("$\(totalCost, specifier: "%.2f")")
                            .foregroundColor(.blue)
                            .font(.headline)
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
                }
                
                Button(carToEdit == nil ? "Add To List" : "Update Entry") {
                    saveCar()
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
            }
            .navigationTitle(carToEdit != nil ? "Edit Car" : "Add New Car")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    func saveCar() {
        guard let pricePerDay = Double(rentalPrice), pricePerDay > 0, !carName.isEmpty, !nameOfOwner.isEmpty else {
            showAlert(message: "Please fill out all required fields.")
            return
        }
        
        if let index = carManager.cars.firstIndex(where: { $0.id == carToEdit?.id }) {
            carManager.cars[index].name = carName
            carManager.cars[index].startDate = startDate
            carManager.cars[index].endDate = endDate
            carManager.cars[index].pricePerDay = pricePerDay
            carManager.cars[index].carType = selectedCarType
            carManager.cars[index].color = selectedColorHex
            carManager.cars[index].notes = extraNotes
            carManager.cars[index].renterName = nameOfOwner
            
            if let newImage = selectedImage {
                carManager.cars[index].imageData = newImage.jpegData(compressionQuality: 0.5)
            } else if let existingImageData = carManager.cars[index].imageData {
                carManager.cars[index].imageData = existingImageData
            }
            
            showAlert(message: "Car details updated successfully.")
        } else {
            let newCar = Car(name: carName, startDate: startDate, endDate: endDate, pricePerDay: pricePerDay, carType: selectedCarType, imageData: selectedImage?.jpegData(compressionQuality: 0.5), color: selectedColorHex, notes: extraNotes, renterName: nameOfOwner)
            carManager.cars.append(newCar)
            showAlert(message: "Car saved successfully.")
        }
        
        carManager.saveCars()
        onAddCar()
        presentationMode.wrappedValue.dismiss()
    }
    
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else { return "#000000" }
        
        let red = UInt8(components[0] * 255)
        let green = UInt8(components[1] * 255)
        let blue = UInt8(components[2] * 255)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

struct NewCarInputView_Preview: PreviewProvider {
    static var previews: some View {
        let carManager = CarManager()
        var car: Car?
        return NewCarInputView(carManager: carManager, carToEdit: car) {
            //
        }
    }
}

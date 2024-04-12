//
//  CarManager.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import Foundation
import Combine
import SwiftUI

enum CarType: String, CaseIterable, Codable {
    case electric
    case hybrid
    case gas
}

struct Car: Identifiable, Encodable, Decodable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var pricePerDay: Double
    var carType: CarType
    var imageData: Data?
    
    var rentedDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    
    var revenue: Double {
        return pricePerDay * Double(rentedDays)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, startDate, endDate, pricePerDay, carType, imageData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(pricePerDay, forKey: .pricePerDay)
        try container.encode(carType.rawValue, forKey: .carType)
        try container.encode(imageData, forKey: .imageData)
    }
    
    init(name: String, startDate: Date, endDate: Date, pricePerDay: Double, carType: CarType, imageData: Data? = nil) { 
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.pricePerDay = pricePerDay
        self.carType = carType
        self.imageData = imageData // Assign imageData
    }
}

class CarManager: ObservableObject {
    @Published var cars: [Car] = [] {
        didSet {
            saveCars()
        }
    }
    
    @Published var totalRentedDays: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        loadCars()
        
        $cars
            .sink { [weak self] cars in
                self?.totalRentedDays = cars.reduce(0) { $0 + $1.rentedDays }
            }
            .store(in: &cancellables)
    }
    
    // Add, Edit, Delete functions for cars
    
    func saveCars() {
        // Encode cars array to Data
        if let encoded = try? JSONEncoder().encode(cars) {
            // Store the encoded data in UserDefaults
            UserDefaults.standard.set(encoded, forKey: "cars")
        }
    }
    
    func loadCars() {
        if let savedCarsData = UserDefaults.standard.data(forKey: "cars") {
            // Decode the saved data back into an array of Car objects
            if let decodedCars = try? JSONDecoder().decode([Car].self, from: savedCarsData) {
                self.cars = decodedCars
                return
            }
        }
        // If no saved data is found, initialize with an empty array
        self.cars = []
    }
    
    func deleteCar(at index: Int) {
        guard index >= 0 && index < cars.count else {
            print("Index out of range")
            return
        }
        cars.remove(at: index)
    }
}

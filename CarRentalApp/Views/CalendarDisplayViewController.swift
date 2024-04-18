//
//  CalendarDisplayViewController.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 4/14/24.
//

import SwiftUI

struct CarRentalCollectionView: View {
    @ObservedObject var carManager: CarManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 10) {
                        ForEach(carManager.cars) { car in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(car.name)
                                    .font(.headline)
                                
                                ForEach(carRentPeriods(car: car), id: \.self) { period in
                                    Text(period)
                                }
                            }
                            .padding()
                            .background(Color(hex: car.color).opacity(0.5))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Bookings Overview")
        }
    }
    
    func carRentPeriods(car: Car) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        var periods: [String] = []
        let calendar = Calendar.current
        var currentDate = car.startDate
        while currentDate <= car.endDate {
            if calendar.isDate(currentDate, inSameDayAs: car.startDate) {
                periods.append(dateFormatter.string(from: currentDate))
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        periods.append(dateFormatter.string(from: car.endDate))
        return ["\(periods.first!)-\(periods.last!)"]
    }
}

struct CarRentalCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        let carManager = CarManager()
        return CarRentalCollectionView(carManager: carManager)
    }
}

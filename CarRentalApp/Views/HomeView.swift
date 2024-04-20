//
//  HomeView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/29/24.
//

import SwiftUI

struct DaysOverview: View {
    @ObservedObject var carManager: CarManager
    @State private var navBackToCollectionView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Dates Overview")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    AvailabilityOverview(daysTakenByMonth: calculateDaysTakenByMonth())
                        .padding()
                }
            }
            .navigationBarItems(leading: Button(action: {
                navBackToCollectionView.toggle()
            }, label: {
                Image(systemName: "text.justify.left")
            }))
            .fullScreenCover(isPresented: $navBackToCollectionView) {
                CarRentalCollectionView(carManager: carManager)
            }
        }
    }
    
    // Calculate total number of days taken for each month
    private func calculateDaysTakenByMonth() -> [String: Int] {
        var daysTakenByMonth: [String: Set<Int>] = [:] // Using a set to ensure each day is counted only once
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        for car in carManager.cars {
            let startDate = car.startDate
            let endDate = Calendar.current.date(byAdding: .day, value: car.rentedDays, to: startDate)!
            
            // Iterate through each date in the rental period and add it to the set for the corresponding month
            for date in Date.dates(from: startDate, to: endDate) {
                let monthKey = dateFormatter.string(from: date)
                daysTakenByMonth[monthKey, default: []].insert(date.day)
            }
        }
        
        // Convert the set to a count for each month
        var daysTakenCountByMonth: [String: Int] = [:]
        for (month, days) in daysTakenByMonth {
            daysTakenCountByMonth[month] = days.count
        }
        
        return daysTakenCountByMonth
    }
}

struct AvailabilityOverview: View {
    let daysTakenByMonth: [String: Int]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(daysTakenByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, daysTaken in
                Text("\(month): \(daysTaken) days taken")
            }
        }
    }
}

extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    static func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        let calendar = Calendar.current
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}


#Preview {
    DaysOverview(carManager: CarManager())
}

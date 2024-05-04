//
//  HomeView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/29/24.
//

import SwiftUI

struct DaysOverview: View {
    @ObservedObject var carManager: CarManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    AvailabilityOverview(daysTakenByMonth: calculateDaysTakenByMonth())
                        .padding()
                }
            }
            .navigationTitle("Taken Days Overview")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "text.justify.left")
            }))
        }
    }
    
    // Calculate total number of days taken for each month
    private func calculateDaysTakenByMonth() -> [(String, Int)] {
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
        return daysTakenByMonth.map { (key, value) in
            (key, value.count)
        }
        .sorted(by: { (first, second) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            if let firstDate = dateFormatter.date(from: first.0), let secondDate = dateFormatter.date(from: second.0) {
                return firstDate < secondDate
            }
            return false
        })
    }
}

struct AvailabilityOverview: View {
    let daysTakenByMonth: [(String, Int)]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(daysTakenByMonth, id: \.0) { month, daysTaken in
                Text("- \(month): \(daysTaken) / \(Date.daysInMonth(month: month))  days taken")
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
    
    static func daysInMonth(month: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        if let date = dateFormatter.date(from: month) {
            return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
        }
        return 0
    }
}

#Preview {
    DaysOverview(carManager: CarManager())
}

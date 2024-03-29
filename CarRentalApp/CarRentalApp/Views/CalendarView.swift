//
//  CalendarView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("Select Dates")
            
            DatePicker("Start Date", selection: $startDate, in: ...endDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            
            DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
        }
    }
}

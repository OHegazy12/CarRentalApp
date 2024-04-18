//
//  MoneyInfoView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 4/9/24.
//

import SwiftUI

struct CarChartData: Identifiable {
    var id = UUID()
    var name: String
    var pricePerDay: Double
    var color: Color
}

struct PieView: View {
    @StateObject var carManager: CarManager
    @State var carType: CarType
    
    let car: Car?
    
    @State private var displayDonutChart = false
    @State private var selectedMonth: Int = 0
    
    private var months: [String] {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return (0..<12).map { index in
            let date = Calendar.current.date(byAdding: .month, value: -index, to: Date())!
            return dateFormatter.string(from: date)
        }
    }
    
    private var filteredCars: [Car] {
        if selectedMonth == 0 { // All-time
            return carManager.cars
        } else {
            let month = Calendar.current.date(byAdding: .month, value: -(selectedMonth - 1), to: Date())!
            return carManager.cars.filter { car in
                let components = Calendar.current.dateComponents([.year, .month], from: car.startDate)
                let carMonth = Calendar.current.date(from: components)!
                return Calendar.current.isDate(carMonth, equalTo: month, toGranularity: .month)
            }
        }
    }
    
    private var monthlyRevenue: Double {
        return filteredCars.reduce(0) { $0 + $1.revenue }
    }
    
    private var formattedTotalRevenue: String {
        let totalRevenue = carManager.cars.reduce(0) { $0 + $1.revenue }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(for: totalRevenue) ?? "\(totalRevenue)"
    }
    
    var body: some View {
        let data: [CarChartData] = filteredCars.map { car in
            CarChartData(name: car.name, pricePerDay: car.pricePerDay, color: Color(hex: car.color))
        }
        
        ScrollView {
            VStack {
                Text("Money Breakdown")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Canvas { context, size in
                    let total = data.reduce(0) {$0 + $1.pricePerDay}
                    
                    if(displayDonutChart) {
                        let donut = Path{ p in
                            p.addEllipse(in: CGRect(origin: .zero, size: size))
                            p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
                        }
                        context.clip(to: donut, style: .init(eoFill: true))
                    }
                    
                    context.translateBy(x: size.width*0.5, y: size.height*0.5)
                    var picontext = context
                    picontext.rotate(by: .degrees(-90))
                    let radius = min(size.width, size.height)*0.45
                    var startAngle = Angle.zero
                    for carData in data {
                        let angle = Angle(degrees: 360 * (carData.pricePerDay/total))
                        let endAngle = startAngle + angle
                        let path = Path { p in
                            p.move(to: .zero)
                            p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                            p.closeSubpath()
                        }
                        
                        picontext.fill(path , with: .color(carData.color))
                        startAngle = endAngle
                    }
                }
                .aspectRatio(contentMode: .fit)
                VStack(alignment: .leading) {
                    ForEach(data) { carData in
                        HStack {
                            Rectangle()
                                .frame(width: 30, height: 20)
                                .foregroundColor(carData.color)
                            Text(carData.name)
                                .font(.footnote)
                            Text("$\(String(format: "%.2f", carData.pricePerDay)) per day")
                                .font(.caption)
                        }
                    }
                    Text("Total Price: $\(formattedTotalRevenue)")
                        .font(.headline)
                }
                Toggle("Display Donut Chart?", isOn: $displayDonutChart)
                    .padding()
            }
            
        }
    }
}


struct PieView_Previews: PreviewProvider {
    static var previews: some View {
        let carManager = CarManager()
        return PieView(carManager: carManager, carType: .electric, car: nil)
    }
}

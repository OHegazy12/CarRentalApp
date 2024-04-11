//
//  MoneyInfoView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 4/9/24.
//

import SwiftUI

struct MoneyInfoView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CarActivityView: Identifiable {
    var carType: CarType
    var pricePerDay: Double
    var id = UUID()
}

struct PieView: View {
    @StateObject var carManager: CarManager
    @State var carType: CarType
    
    let car: Car?
    
    @State private var displayDonutChart = false
    
    func typeToColor(_ carType : CarType) -> Color {
        switch(carType) {
        case .electric:
            return .green
        case .hybrid:
            return .blue
        case .gas:
            return .orange
        default:
            return .purple
        }
    }
    
    var body: some View {
        let data: [CarActivityView] = carManager.cars.map { car in
            CarActivityView(carType: car.carType, pricePerDay: car.pricePerDay)
        }
        VStack {
            Canvas { context, size in
                let total = data.reduce(0) {$0 + $1.pricePerDay}
                
                context.translateBy(x: size.width*0.5, y: size.height*0.5)
                var picontext = context
                picontext.rotate(by: .degrees(-90))
                let radius = min(size.width, size.height)*0.45
                var startAngle = Angle.zero
                for carTypes in data {
                    let angle = Angle(degrees: 360 * (carTypes.pricePerDay/total))
                    let endAngle = startAngle + angle
                    let path = Path { p in
                        p.move(to: .zero)
                        p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                        p.closeSubpath()
                    }
                    
                    picontext.fill(path , with: .color(typeToColor(carTypes.carType)))
                    startAngle = endAngle
                }
            }
            .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                ForEach(data) { carTypes in
                    HStack {
                        Rectangle()
                            .frame(width: 30, height: 20)
                            .foregroundColor(typeToColor(carTypes.carType))
                        Text(carTypes.carType.rawValue)
                            .font(.footnote)
                    }
                }
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
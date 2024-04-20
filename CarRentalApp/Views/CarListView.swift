//
//  CarListView.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 3/27/24.
//

import SwiftUI

struct CarListView: View {
    @ObservedObject var carManager: CarManager
    @State private var isAddingNewCar = false
    @State var carToEdit: Car?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(carManager.cars) { car in
                    NavigationLink(destination: CarDetailView(carManager: carManager, car: car)) {
                        VStack(alignment: .leading) {
                            if let imageData = car.imageData, let carImage = UIImage(data: imageData) {
                                Image(uiImage: carImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 365, height: 300)
                                    .cornerRadius(10)
                            }
                            HStack {
                                Text(car.name)
                                    .fontWeight(.heavy)
                                Spacer()
                                Text("\(String(format: "%.2f", car.pricePerDay)) / Day")
                                    .fontWeight(.heavy)
                            }
                        }
                        
                    }
                    .contextMenu {
                        Button(action: {
                            deleteCar(car)
                        }) {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Cars")
            .navigationBarItems(
                trailing: Button(action: {
                    isAddingNewCar = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isAddingNewCar) {
                NewCarInputView(carManager: carManager, carToEdit: carToEdit) {
                    isAddingNewCar = false
                }
            }
        }
        .onAppear {
            carManager.loadCars()
        }
    }
    
    private func deleteCar(_ car: Car) {
        if let index = carManager.cars.firstIndex(where: { $0.id == car.id }) {
            carManager.deleteCar(at: index)
        }
    }
}

struct CarListView_Preview: PreviewProvider {
    static var previews: some View {
        let carManager = CarManager()
        return CarListView(carManager: carManager)
    }
}

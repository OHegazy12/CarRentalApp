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
                        HStack {
                            Text(car.name)
                            Spacer()
                            let color = Color(hex: car.color) 
                            if color != nil {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(color)
                                    .frame(width: 30, height: 30)
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
                    isAddingNewCar = false // Dismiss the sheet after adding a new car
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

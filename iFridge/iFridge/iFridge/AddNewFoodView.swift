//
//  TestView.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 03/05/24.
//

import SwiftUI

struct AddNewFoodView: View {
    var myData = sharedData
    @State private var isKeyboardVisible = false
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var selectedFood: Food? = nil
    @State private var isAddingFood: Bool = false
    @State private var quantity: Int = 1
    @State private var expirationDate: Date = Date()
    @State private var isModalShowed: Bool = false
    @State private var isAddManuallyShown: Bool = false
    @StateObject private var vm = AppViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        SearchBar(searchText: $searchText, isSearching: $isSearching)
                        
                        if myData.foodItem.filter({ $0.name.localizedCaseInsensitiveContains(searchText) }).isEmpty && searchText != "" {
                            Button(action: {
                                isAddManuallyShown = true
                            }) {
                                Text("Add Manually")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(frameYellow)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                        } else {
                            ForEach(myData.foodItem.filter { !searchText.isEmpty && $0.name.localizedCaseInsensitiveContains(searchText) }) { food in
                                Button(action: {
                                    selectedFood = food
                                    isAddingFood = true
                                }) {
                                    FoodRowView(food: food)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.top, 0)
                }.background(backColor)
            }
            .navigationTitle("Add New Food")
            .sheet(isPresented: $isAddingFood) {
                AddFoodView(selectedFood: $selectedFood, isAddingFood: $isAddingFood, quantity: $quantity, expirationDate: $expirationDate)
            }
            .sheet(isPresented: $isAddManuallyShown) {
                AddManuallyFoodView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isModalShowed.toggle()
                    }) {
                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(frameYellow)
                    }.sheet(isPresented: $isModalShowed) {
                        ContentView(selectedFood: $selectedFood , quantity: $quantity, expirationDate: $expirationDate)
                            .environmentObject(vm)
                            .task {
                                await vm.requestDataScannerAccesStatus()
                            }
                    }
                }
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isKeyboardVisible = false
        }
    }
}

struct FoodRowView: View {
    var food: Food
    var body: some View {
        HStack {
            Image(food.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
            
            Text(food.name).foregroundColor(frameYellow)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

struct AddFoodView: View {
    @Binding var selectedFood: Food?
    @Binding var isAddingFood: Bool
    @Binding var quantity: Int
    @Binding var expirationDate: Date
    @Environment(\.dismiss) var dismiss
    var myData = sharedData
    
    var body: some View {
        VStack {
            Text("\(selectedFood?.name ?? "")")
                .foregroundColor(frameYellow)
            
            Image("\(selectedFood?.image ?? "")")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
            
            Stepper("Quantity: \(quantity)", value: $quantity)
                .padding()
            
            DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                .padding().accentColor(frameYellow)
            
            Button(action: {
                addFood(name: selectedFood?.name ?? "", expirationDate: expirationDate, quantity: quantity)
                dismiss()
                isAddingFood = false
            }) {
                Text("Add")
                    .foregroundColor(frameYellow)
            }
            .padding()
            Spacer()
        }
        .padding()
        
    }
    func addFood(name: String, expirationDate: Date, quantity: Int, image: UIImage? = nil) {
        var imageName = "basic" // Default image
        
        // Cerca l'alimento corrispondente nella lista di alimenti predefiniti
        if let foodItem = myData.foodItem.first(where: { $0.name.lowercased() == name.lowercased() }) {
            imageName = foodItem.image // Usa l'immagine specificata per l'alimento
        }
        
        // Controlla se l'alimento esiste già nel frigorifero
        if let existingFoodIndex = myData.foodItem.firstIndex(where: { $0.name.lowercased() == name.lowercased() && $0.expirationDate == expirationDate}) {
            // Se l'alimento esiste già, aggiorna la quantità
            myData.fridgeFoodItem[existingFoodIndex].quantity += quantity
        } else {
            // Se l'alimento non esiste ancora, aggiungi un nuovo oggetto alimentare con l'immagine
            let addNewFood = Food(name: name, image: imageName, expirationDate: expirationDate, quantity: quantity, uiImage: image)
            myData.fridgeFoodItem.append(addNewFood)
        }
    }
}

#Preview {
    AddNewFoodView()
}

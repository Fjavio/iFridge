//
//  test.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 02/05/24.
//

import SwiftUI

// Struttura che rappresenta la vista principale del frigorifero
struct MyFridgeView: View {
    // Variabile per i dati del frigorifero
    @ObservedObject var myData = sharedData
    // Stato per tenere traccia dello stato della tastiera
        @State private var isKeyboardVisible = false
    // Variabile di stato per mostrare/nascondere il modal di aggiunta alimento
    @State var isModalShowed: Bool = false
    
    // Variabile di stato per il testo di ricerca
    @State private var searchText: String = ""
    
    // Variabile di stato per indicare se si sta effettuando una ricerca
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView([.vertical], showsIndicators: true) {
                VStack() {
                    SearchBar(searchText: $searchText, isSearching: $isSearching)
                    
                    ForEach(myData.fridgeFoodItem.indices, id: \.self) { index in
                        let food = myData.fridgeFoodItem[index]
                        
                        // Applica il filtro per il testo di ricerca e per la data di scadenza
                        if searchText.isEmpty ? true : food.name.localizedCaseInsensitiveContains(searchText) {
                            let expirationDifference = calculateDayDifference(from: food.expirationDate)
                            
                            // Applica il filtro sulla differenza di scadenza
                            if expirationDifference >= -1 {
                                let textColor = calculateTextColor(forDifference: expirationDifference)
                                
                                ZStack(alignment: .bottomLeading) {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.white)
                                        .overlay(
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    if let uiImage = food.uiImage {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 60, height: 60)
                                                            .cornerRadius(30)
                                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                                                    } else {
                                                        Image(food.image)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 60, height: 60)
                                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                                                    }
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(food.name)
                                                            .foregroundColor(Color.black)
                                                        
                                                        Text("\(expirationDifference) Days").foregroundColor(textColor)
                                                            .font(.subheadline)
                                                        
                                                        if food.isExpanded {
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                HStack {
                                                                    Text("Quantity: \(food.quantity)")
                                                                    Button(action: {
                                                                        decrementQuantity(for: food)
                                                                    }) {
                                                                        Image(systemName: "minus.circle").foregroundColor(frameYellow)
                                                                    }
                                                                }
                                                                Text("Expiration Date: \(formattedDate(for: food.expirationDate))")
                                                            }
                                                        }
                                                    }//VSTACK
                                                    
                                                    Spacer()
                                                    Image(systemName: food.isExpanded ? "chevron.up" : "chevron.down")
                                                        .foregroundColor(frameYellow)
                                                        .frame(width: 24, height: 24)
                                                }//hstack
                                            }
                                            .padding()
                                        )
                                        .frame(height: food.isExpanded ? 150 : 87)
                                        .onTapGesture {
                                            withAnimation {
                                                toggleExpansion(of: food)
                                            }
                                        }
                                }//MARK: Z STACK END
                                .cornerRadius(24)
                                .padding(.horizontal)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                                
                                // Controllo se mancano 5 giorni alla scadenza e invio la notifica
                                if expirationDifference == 5 {
                                    Button(action: {
                                        sendNotification(for: food)
                                    }) {
                                        EmptyView()
                                    }.hidden()
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.top, 0)
            }.navigationTitle("My Fridge").foregroundStyle(Color.black)
                .background(
                    Image("myfridge")
                        .resizable().edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Creare una notifica per l'alimento "Apple"
                            if let appleFood = sharedData.foodItem.first(where: { $0.name == "Apple" }) {
                                sendNotification(for: appleFood)
                            }
                        }) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color.clear)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isModalShowed.toggle()
                        }) {
                            Image(systemName: "plus.app.fill")
                                .foregroundColor(frameYellow)
                        }.sheet(isPresented: $isModalShowed) {
                            AddNewFoodView()
                        }
                    }
                }
        }//MARK: NAVIGATIONSTACK END
        .onTapGesture {
                    // Nascondi la tastiera quando si tocca una parte diversa dall'area di input
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    isKeyboardVisible = false
                }
        
    }

    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func toggleExpansion(of food: Food) {
        if let index = myData.fridgeFoodItem.firstIndex(where: { $0.id == food.id }) {
            myData.fridgeFoodItem[index].isExpanded.toggle()
        }
    }
    
    private func calculateDayDifference(from expirationDate: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: expirationDate)
        if let differenceInDays = components.day {
            return differenceInDays
        } else {
            return -1
        }
    }
    
    private func calculateTextColor(forDifference difference: Int) -> Color {
        return difference <= 10 ? .red : .green
    }
    
    func decrementQuantity(for food: Food) {
        if let index = myData.fridgeFoodItem.firstIndex(where: { $0.id == food.id }) {
            if myData.fridgeFoodItem[index].quantity > 0 {
                myData.fridgeFoodItem[index].quantity -= 1
                if myData.fridgeFoodItem[index].quantity == 0{
                    myData.fridgeFoodItem.remove(at: index)
                }
            }
        }
    }
    
    func sendNotification(for food: Food) {
        let center = UNUserNotificationCenter.current()
        
        // Create content
        let content = UNMutableNotificationContent()
        content.title = "LAST CALL!!"
        content.body = "Your \(food.name) is going to expire soon. Please eat it."
        content.categoryIdentifier = NotificationCategory.general.rawValue
        content.userInfo = ["customData": "Some Data"]
        content.sound = UNNotificationSound.default

        // Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        // Create a request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Add request to notification center
        center.add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully")
            }
        }
    }
}

struct Keyboard: View {
    // Stato per tenere traccia dello stato della tastiera
    @State private var isKeyboardVisible = false

    var body: some View {
        VStack {
            // Contenuto della vista
            TextField("Enter text", text: .constant(""))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onTapGesture {
                    // Quando si tocca l'area di input, impostare isKeyboardVisible su true
                    isKeyboardVisible = true
                }

            Spacer()
        }
        .padding()
        // Rileva il tocco su altre parti dello schermo
        .onTapGesture {
            // Quando si tocca una parte diversa dall'area di input, nascondi la tastiera
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isKeyboardVisible = false
        }
    }
}

#Preview {
    MyFridgeView()
}

//
//  ExpiredView.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 05/05/24.
//

import SwiftUI

struct ExpiredView: View {
    var myData = sharedData
    
    var body: some View {
        NavigationView {
            ScrollView([.vertical], showsIndicators: true) {
                VStack() {
                    ForEach(myData.fridgeFoodItem.indices, id: \.self) { index in
                        let food = myData.fridgeFoodItem[index]
                        
                        // Calcola la differenza di scadenza per l'alimento corrente
                        let expirationDifference = calculateDayDifference(from: food.expirationDate)
                        
                        // Applica il filtro sulla differenza di scadenza
                        if expirationDifference < -1 {
                            // Ottieni il colore del testo in base alla differenza di scadenza
                            let textColor = calculateTextColor(forDifference: expirationDifference)
                            
                            // Visualizza il contenuto per ogni alimento scaduto
                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white)
                                
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
                                    
                                    VStack(alignment: .leading){
                                        Text(food.name)
                                        
                                        // Mostra il numero di giorni trascorsi dalla scadenza dell'alimento
                                        Text(" \(abs(expirationDifference)) Days ago")
                                            .foregroundColor(textColor)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(height: 87)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                    }
                }
            }
                    .padding(.top, 12)

                    .navigationTitle("Expired")
                    .padding(.top)
                    .background(
                        Image("expired")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    )
                }
            
        
    }
        
            
            // Funzione per formattare la data
           private func formattedDate(for date: Date) -> String {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                return formatter.string(from: date)
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
            
          private  func calculateTextColor(forDifference difference: Int) -> Color {
                return difference <= 10 ? .red : .green
            }
        }
struct ExpiredView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiredView()
    }
}


#Preview {
    ExpiredView()
}

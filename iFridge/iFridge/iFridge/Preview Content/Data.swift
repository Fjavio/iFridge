//
//  Data.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 30/04/24.
//


import SwiftUI

class SharedData: ObservableObject {
    
    @Published var capturedImage: UIImage? = nil
    
    @Published var fridgeFoodItem : [Food] = []
    
    @Published var foodItem = [Food(name: "Apple", image: "apple", expirationDate: Date(), quantity: 8),
                               Food(name: "Salad", image: "salad", expirationDate: Date(), quantity: 1),
                               Food(name: "Eggs", image: "eggs", expirationDate: Date(), quantity: 6),
                               Food(name: "Milk", image: "milk", expirationDate: Date(), quantity: 1),
                               Food(name: "Butter", image: "butter", expirationDate: Date(), quantity: 2),
                               Food(name: "Cheese", image: "cheese", expirationDate: Date(), quantity: 2),
                               Food(name: "Cheesecake", image: "cheesecake", expirationDate: Date(), quantity: 1),
                               Food(name: "Fruitjuice", image: "fruitjuice", expirationDate: Date(), quantity: 3),
                               Food(name: "Ham", image: "ham", expirationDate: Date(), quantity: 1),
                               Food(name: "Vegetable Nut", image: "vegetablenut", expirationDate: Date(), quantity: 1),
                               Food(name: "Jam", image: "jam", expirationDate: Date(), quantity: 2),
                               Food(name: "Ketchup", image: "ketchup", expirationDate: Date(), quantity: 1),
                               Food(name: "Mayonnaise", image: "mayonnaise", expirationDate: Date(), quantity: 1),
                               Food(name: "Salami", image: "salami", expirationDate: Date(), quantity: 2),
                               Food(name: "Soy Sauce", image: "soysauce", expirationDate: Date(), quantity: 1),
                               Food(name: "Strawberry Yogurt", image: "strawyogurt", expirationDate: Date(), quantity: 4),
                               Food(name: "Cookie", image: "cookie", expirationDate: Date(), quantity: 1)
    ]
    
    @Published var barcodeFoodItem: [BarcodeFood] = [
        BarcodeFood(name: "Cioko Muffin", barcode: "8023696006813"),
        BarcodeFood(name: "Latte", barcode: "8000830123456"),
        BarcodeFood(name: "Pasta", barcode: "8001728150008"),
        BarcodeFood(name: "Pane", barcode: "8001470123453"),
        BarcodeFood(name: "Pesce", barcode: "8003000123459")
    ]
    
}

var sharedData = SharedData()

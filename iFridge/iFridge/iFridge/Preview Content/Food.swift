//
//  Food.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 30/04/24.
//

import Foundation
import SwiftUI

struct Food: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var expirationDate: Date
    var quantity: Int
    var isExpanded: Bool = false
    var uiImage: UIImage? // Aggiunta variabile per l'immagine UIImage
    var isUserImage: Bool // Aggiunta variabile per indicare se l'immagine è stata catturata dall'utente
    
    init(name: String, image: String, expirationDate: Date, quantity: Int, uiImage: UIImage? = nil, isUserImage: Bool = false) {
        self.name = name
        self.image = image
        self.expirationDate = expirationDate
        self.quantity = quantity
        self.uiImage = uiImage // Inizializza l'immagine UIImage
        self.isUserImage = isUserImage // Inizializza il flag isUserImage
    }
}


struct Recipe: Identifiable{
    var id = UUID()
    var title: String
    var image: String
    var category: String = "no category"
    var ingredients: [String]
    var directions: [String]
    var Foods: [String]
    var description: [String]
    var isExpanded: Bool = false
}

struct BarcodeFood: Identifiable{
    
    var id = UUID()
    
    var name: String
    
    var barcode: String
}

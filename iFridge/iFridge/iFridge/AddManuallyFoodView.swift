//
//  AddFoodView PIA.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 05/05/24.
//

import SwiftUI

struct AddManuallyFoodView: View {
    @State private var isKeyboardVisible = false
    @State var name: String = ""
    @State var quantity: Int = 1
    @State var expirationDate: Date = Date()
    @State var imageString: String = "fork.knife.circle"
    @State var image: UIImage?
    @State var isUserImage = false
    @Environment(\.dismiss) var dismiss
    @ObservedObject var myData = sharedData
    @State private var showImagePicker: Bool = false

    @State private var isAddingFood: Bool = false
    @State private var scannedBarcode: String?
    @State private var selectedFood: Food?
    @State private var isAddScreenPresented = false
    @State private var capturedImage: UIImage?
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Quantity")) {
                    Stepper(value: $quantity, in: 1...100) {
                        Text("Quantity: \(quantity)")
                    }
                }
                Section(header: Text("Photo")) {
                    HStack {
                        Text("Photo")
                        Spacer()
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Image(systemName: "camera")
                                .foregroundColor(frameYellow)
                        }
                    }
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                }
                Section(header: Text("Expiration Date")) {
                    DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                        .accentColor(frameYellow)
                }
            }
            .navigationTitle("New Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addFood(name: name, expirationDate: expirationDate, quantity: quantity, image: image)
                        dismiss()
                    }) {
                        Text("Add")
                            .foregroundColor(frameYellow)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .camera, image: self.$image)
        }
    }

    func addFood(name: String, expirationDate: Date, quantity: Int, image: UIImage?) {
            var imageName = "basic" // Default image
            
            // Cerca l'alimento corrispondente nella lista di alimenti predefiniti
            if let foodItem = myData.foodItem.first(where: { $0.name.lowercased() == name.lowercased() }) {
                imageName = foodItem.image // Usa l'immagine specificata per l'alimento
            }
            
            // Controlla se l'alimento esiste già nel frigorifero
            if let existingFoodIndex = myData.fridgeFoodItem.firstIndex(where: { $0.name.lowercased() == name.lowercased() && $0.expirationDate == expirationDate}) {
                // Se l'alimento esiste già, aggiorna la quantità
                myData.fridgeFoodItem[existingFoodIndex].quantity += quantity
            } else {
                // Se l'alimento non esiste ancora, aggiungi un nuovo oggetto alimentare con l'immagine
                let addNewFood = Food(name: name, image: imageName, expirationDate: expirationDate, quantity: quantity, uiImage: image) // Passa l'immagine catturata come parametro
                myData.fridgeFoodItem.append(addNewFood)
            }
        }
}


struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var image: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage // Assegna l'immagine catturata alla variabile di stato image
                sharedData.capturedImage = uiImage // Assegna l'immagine catturata a capturedImage in sharedData
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}



#Preview {
    AddManuallyFoodView()
}





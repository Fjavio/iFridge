

import SwiftUI
import VisionKit

struct ContentView: View {
    var myData = sharedData
    @EnvironmentObject var vm: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scannedBarcode: String?
    @State  var isAddingFood: Bool = false
    @Binding var selectedFood: Food?
    @Binding var quantity: Int
    @Binding var expirationDate: Date
    @State private var isAddScreenPresented = false
    
    // Aggiungi altre proprietà e metodi se necessario

    // Funzione per cercare un alimento in base al codice a barre scannerizzato
    func findFoodItem(forScannedBarcode barcode: String, in barcodeFoodItem: [BarcodeFood]) -> String? {
        // Itera attraverso la lista di alimenti
        for food in barcodeFoodItem {
            // Confronta il codice a barre dell'alimento con quello scannerizzato
            if food.barcode == barcode {
                // Se il codice a barre corrisponde, restituisci l'alimento
                return food.name
            }
        }
        // Se non viene trovata nessuna corrispondenza, restituisci nil
        return nil
    }
    
    private func addProductToMyFridge() {
        if let barcode = scannedBarcode, let productName = findFoodItem(forScannedBarcode: barcode, in: myData.barcodeFoodItem), let foundFood = myData.foodItem.first(where: { $0.name == productName }) {
            // Trovato un alimento corrispondente al codice a barre scansionato
            addFood(name: foundFood.name, expirationDate: foundFood.expirationDate, quantity: 1, image: foundFood.image)
        } else {
            print("Product not found for barcode:", scannedBarcode ?? "")
        }
    }
    
    func addFood(name: String, expirationDate: Date, quantity: Int, image: String?) {
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
            let addNewFood = Food(name: "Cookie", image: "cookie", expirationDate: expirationDate, quantity: quantity, uiImage: nil)
            myData.fridgeFoodItem.append(addNewFood)
        }
    }
    
    
    
    
    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        /*
         ("Phone", .telephoneNumber),
         ("Email", .emailAddress),
         ("Address", .fullStreetAddress)*/
    ]
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvaiable:
            Text("You device doesn't have a camera")
            //2
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning barcode with this app ")
            //3
        case .cameraAccessNotGranted:
            Text("Please provide access to the camera in settings")
            //4
        case .notDetermined:
            Text("Requesting camera access")
            
        }
        
        
    }
    
    private var mainView: some View {
        DataScannerView(recognizedItems: $vm.recognizedItems, recognizedDataType: vm.recognizedDataType, recognizesMultipleItems: vm.recognizesMultipleItems)
            .background { Color.gray.opacity(0.3)}
            .ignoresSafeArea()
            .id(vm.dataScannerViewId)
            .sheet(isPresented: .constant(true)) {
                bottomContainerView
                    .background(.ultraThinMaterial)
                    .presentationDetents([.medium, .fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
                    .onAppear {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                            return
                        }
                        controller.view.backgroundColor = .clear
                    }
                
            }
            .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
            .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
            .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }
        
    }
    
    // Aggiungi altre visualizzazioni e metodi se necessario
    private var headerView: some View {
        
        //Funzione per cambiare il colore al pulsante
        struct MyToggleStyle: ToggleStyle {
            func makeBody(configuration: Configuration) -> some View {
                HStack {
                    configuration.label
                    Spacer()
                    Toggle("", isOn: configuration.$isOn)
                        .tint(frameYellow) // Imposta il colore del toggle a giallo
                }
            }
        }
        
        
        return VStack{
            HStack{
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems).toggleStyle(MyToggleStyle())
            }.padding(.top)
            
            if vm.scanType == .text{
                
                Picker("Text content type", selection: $vm.textContentType){
                    
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                    
                    
                }.pickerStyle(.segmented)
            }
            
            Text(vm.headerText).padding(.top)
            
            Button("Go Back") {
                presentationMode.wrappedValue.dismiss()
            }.accentColor(frameYellow)
        }.padding(.horizontal)
    }
    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            VStack(alignment: .leading) {
                                Text(barcode.payloadStringValue ?? "Unknown barcode")
                                Button("Add") {
                                    if let barcode = scannedBarcode, let productName = findFoodItem(forScannedBarcode: barcode, in: myData.barcodeFoodItem), let foundFood = myData.foodItem.first(where: { $0.name == productName }) {
                                        // Trovato un alimento corrispondente al codice a barre scansionato
                                        selectedFood = foundFood
                                        
                                    } else {
                                        print("Product not found for barcode:", scannedBarcode ?? "")
                                    }
                                    addProductToMyFridge()
                                    isAddScreenPresented.toggle()
                                    scannedBarcode = barcode.payloadStringValue
                                    
                                }.accentColor(frameYellow)
                                    .padding()
                                    .background(frameYellow)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        case .text(let text):
                            Text(text.transcript)
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                    .padding()
                }
            }
        }.sheet(isPresented: $isAddScreenPresented) {
            AddFoodView(selectedFood: $selectedFood, isAddingFood: $isAddingFood, quantity: $quantity, expirationDate: $expirationDate) { name, expirationDate, quantity, image in
                let imageName = image.flatMap { uiImage in
                    uiImage.pngData()?.base64EncodedString()
                }
                addFood(name: "Cookie", expirationDate: expirationDate, quantity: quantity, image: "cookie")
            }
        }
    }

    
    struct AddFoodView: View {
        @Binding var selectedFood: Food?
        @Binding var isAddingFood: Bool
        @Binding var quantity: Int
        @Binding var expirationDate: Date
        var myData = sharedData
        var addFood: (String, Date, Int, UIImage?) -> Void // Aggiorna il tipo del parametro immagine
        
        var body: some View {
            VStack {
                Text("\(selectedFood?.name ?? "")")
                    .foregroundColor(frameYellow)
                
                Image("cookie") // Usa l'immagine UI dell'alimento
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                
                Stepper("Quantity: \(quantity)", value: $quantity)
                    .padding()
                
                DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                    .padding().accentColor(frameYellow)
                
                Button(action: {
                    addFood(selectedFood?.name ?? "", expirationDate, quantity, selectedFood?.uiImage) // Passa l'immagine UI dell'alimento
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
    }
}

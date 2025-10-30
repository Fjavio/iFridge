
//
//  AppViewModel.swift
//  iFridge
//
//  Created by Pia Forte on 02/05/24.
//
import AVKit
import Foundation
import SwiftUI
import VisionKit

enum ScanType: String {
    case barcode, text
}

enum DataScannerAccessStatusType{
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvaiable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class AppViewModel: ObservableObject{
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true
    
     var recognizedDataType: DataScannerViewController.RecognizedDataType{
        scanType == .barcode ? .barcode(): .text(textContentType: textContentType)
    }
    
    var headerText: String {
        if recognizedItems.isEmpty {
            return "Scanning \(scanType.rawValue)"
        }else{
            return "Recognized \(recognizedItems.count) item(s) "
        }
    }
    
    var dataScannerViewId: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
    
    private var isScannerAvaiable: Bool{
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccesStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvaiable
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .authorized:
            dataScannerAccessStatus = isScannerAvaiable ? .scannerAvailable : .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvaiable ? .scannerAvailable : .scannerNotAvailable
            }else{
                dataScannerAccessStatus = .cameraAccessNotGranted
                
            }
        default: break
        }
    }
    
}

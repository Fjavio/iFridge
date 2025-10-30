//
//  NotificationView.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 05/05/24.
//

import SwiftUI

enum NotificationAction: String{
    case dimiss
    case reminder
}

enum NotificationCategory: String{
    case general
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.banner, .sound, .badge])
        
    }

}

struct NotificationView: View {
    var body: some View {
        VStack{
            Button("Schedule Notification"){
                
                let center = UNUserNotificationCenter.current()
                
                //create content
                let content = UNMutableNotificationContent()
                content.title = "LAST CALL!!"
                content.body = "Your apples are going to expire soon. Please eat them."
                content.categoryIdentifier = NotificationCategory.general.rawValue
                content.userInfo = ["customData": "Some Data"]
                content.sound = UNNotificationSound.default
                
                if let image = UIImage(named: "apple"),  // Carica l'immagine dall'asset
                   let imageData = image.pngData(),      // Ottieni i dati PNG dell'immagine
                   let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first { // Ottieni la directory cache
                    let fileURL = cachesDirectory.appendingPathComponent("apple.png") // Crea l'URL per il file immagine nella directory cache
                    do {
                        try imageData.write(to: fileURL) // Scrivi i dati dell'immagine nel file URL
                        if let attachment = try? UNNotificationAttachment(identifier: "image", url: fileURL, options: nil) {
                            content.attachments = [attachment] // Aggiungi l'allegato alla notifica
                        }
                    } catch {
                        print("Errore durante la scrittura dell'immagine nella directory cache: \(error)")
                    }
                }

                
                //create trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                
                //create a request
                let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
                
                //define action
                let dismiss = UNNotificationAction(identifier: NotificationAction.dimiss.rawValue , title: "Dismiss", options: [])
                
                let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue , title: "Reminder", options: [])
                
                let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue , actions: [dismiss, reminder], intentIdentifiers: [], options: [])
                
                center.setNotificationCategories([generalCategory])
                
                //add request to notification center
                center.add(request){ error in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationView()
}


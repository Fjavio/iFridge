//
//  iFridgeApp.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 30/04/24.
//

import SwiftUI

@main
struct iFridgeApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    private var delegate: NotificationDelegate = NotificationDelegate()
    
    init(){
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .sound, .badge]){ result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
                    if isOnboarding{
                        GetStartedView()
                    }else{
                        ContainerView()
                    }
                            
                }
    }
}

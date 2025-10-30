//
//  ContainerView.swift
//  iFridge
//
//  Created by Chiara Disegni on 02/05/24.
//

import SwiftUI

struct ContainerView: View {
    
    var body: some View {
        TabView {
            MyFridgeView()
                .tabItem {
                    Label ("My Fridge", systemImage: "refrigerator")
                }
            RecipesView()
                .tabItem {
                    Label ("Recipes", systemImage: "fork.knife")
                }
            ExpiredView()
                .tabItem {
                    Label ("Expired", systemImage: "hourglass.tophalf.filled")
                }
        }.accentColor(frameYellow)
    }
}
    
#Preview {
    ContainerView()
}

//
//  RecipeDetailView.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 08/05/24.
//

import SwiftUI

struct RecipeDetailView: View {
    var currentRecipe: Recipe
    var body: some View {
        ScrollView{
            VStack{
                Text(currentRecipe.title)
                    .font(.largeTitle)
                    .bold()
                
                Image(currentRecipe.image)
                    .resizable() //dimensiona secondo lo schermo
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 20)
                    .padding() //lascia piu spazio tra foto e nome
                Text("INGREDIENTS:").padding()
                ForEach(currentRecipe.ingredients, id: \.self) { ingredientsItem in
                    Text(ingredientsItem)
                }
                Text("PREPARATION:").padding()
                ForEach(currentRecipe.directions, id: \.self) { directionsItem in
                    Text(directionsItem).padding(.horizontal)
                }
                
            }
        }
    }
}

#Preview {
    RecipeDetailView(currentRecipe: Recipe(title: "Unknown", image: "noimage", category: "Unknown", ingredients: ["Unknown"], directions: ["Unknown"], Foods: ["Unknown"], description: ["Unknown"]))
}

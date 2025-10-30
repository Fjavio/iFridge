//
//  RecipesView.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 08/05/24.
//

import SwiftUI

struct RecipesView: View {
    var sharedDataRecipe = SharedDataRecipe()
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var selectedCategory = ""
    
    let categories = ["🥘Easy Dinner", "🍳Fridge Recipes", "🥣 5 Ingredients Or Less"]
    var filteredRecipes: [Recipe] {
            if isSearching {
                return sharedDataRecipe.recipeItem.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            } else if !selectedCategory.isEmpty {
                return sharedDataRecipe.recipeItem.filter { $0.category == selectedCategory }
            } else {
                return []
            }
        }
    
    var body: some View {
        NavigationView {
            VStack {
                if !isSearching {
                    CategoriesListView(categories: categories, selectedCategory: $selectedCategory, searchText: $searchText, isSearching: $isSearching)
                }else {
                    SearchBar(searchText: $searchText, isSearching: $isSearching)
                }
                ScrollView {
                    ForEach(filteredRecipes) { recipe in
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .overlay(
                            VStack(alignment: .leading){
                                HStack(){
                                 Image(recipe.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:150, height: 50)
                                VStack(alignment: .leading){
                                    Text(recipe.title).foregroundColor(Color.black)
                                    if recipe.isExpanded {
                                        VStack(alignment: .leading, spacing: 4) {
                                            ForEach(recipe.description, id: \.self) { descriptionItem in
                                                Text(descriptionItem)
                                            }
                                        }
                                        NavigationLink(destination: RecipeDetailView(currentRecipe: recipe)){
                                        Text("DETAILS")
                                    }
                                                }
                                            }
                                    Spacer()
                                        Image(systemName: recipe.isExpanded ? "chevron.up" : "chevron.down")
                                            .foregroundColor(frameYellow)
                                            .frame(width: 24, height: 24)
                                        }
                                    }
                                ).frame(height: recipe.isExpanded ? 300 : 120)
                                .onTapGesture {
                                    withAnimation {
                                        toggleExpansion(of: recipe)
                                    }
                                }
                        }
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                }
                    .scrollContentBackground(.hidden)
                    .padding(.top, 0)
                }.navigationTitle("Recipes")
            }
        }
        func toggleExpansion(of recipe: Recipe) {
            if let index = sharedDataRecipe.recipeItem.firstIndex(where: { $0.id == recipe.id }) {
                sharedDataRecipe.recipeItem[index].isExpanded.toggle()
            }
        }
}

struct CategoriesListView: View {
    var sharedDataRecipe = SharedDataRecipe()
    let categories: [String]
    @Binding var selectedCategory: String
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: { //action of the button
                    isSearching.toggle()
                    searchText = ""
                }){ //name of the button
                    Image(systemName: "magnifyingglass").foregroundColor(Color.black)
                }
        
                ForEach(categories, id: \.self) { category in
                    CategoryButton(category: category, isSelected: category == selectedCategory) {
                        if selectedCategory == category {
                            selectedCategory = ""
                        } else {
                        selectedCategory = category
                        }
                    }
                }
            }
            .padding()
        }
        .background(frameYellow)
    }
}

struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category)
                .font(.headline)
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .foregroundColor(isSelected ? .white: .primary)
                .background(isSelected ? Color.blue : Color.gray)
                .cornerRadius(20)
        }
    }
}

#Preview {
    RecipesView()
}

//
//  DataRecipes.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 08/05/24.
//

import Foundation

import SwiftUI

@Observable class SharedDataRecipe {
    
    var recipeItem: [Recipe] = [
        Recipe(
            title: "No-Bake Nut Cookies",
            image: "nutcookies",
            category: "🍳Fridge Recipes",
            ingredients: [
                "1 c. firmly packed brown sugar",
                "1/2 c. evaporated milk",
                "1/2 tsp. vanilla",
                "1/2 c. broken nuts (pecans)",
                "2 Tbsp. butter or margarine",
                "3 1/2 c. bite size shredded rice biscuits"
            ],
            directions: [
                "In a heavy 2-quart saucepan, mix brown sugar, nuts, evaporated milk and butter or margarine.",
                "Stir over medium heat until mixture bubbles all over top.",
                "Boil and stir 5 minutes more. Take off heat.",
                "Stir in vanilla and cereal; mix well.",
                "Using 2 teaspoons, drop and shape into 30 clusters on wax paper.",
                "Let stand until firm, about 30 minutes."
            ],
            Foods: [
                "brown sugar",
                "milk",
                "vanilla",
                "nuts",
                "butter",
                "bite size shredded rice biscuits"
            ],
            description: ["🍳 Difficulty: Easy",
                          "🍴 Preparation: 20 min",
                          "🥘 Cooking: 55 min",
                          "⚖️ Serving for: 8 people",
                          "€ Price: Low"]
        ),
        Recipe(
                title: "Creamy Corn",
                image: "creamycorn",
                category: "🥘Easy Dinner",
                ingredients: [
                    "2 (16 oz.) pkg. frozen corn",
                    "1 (8 oz.) pkg. cream cheese, cubed",
                    "1/3 c. butter, cubed",
                    "1/2 tsp. garlic powder",
                    "1/2 tsp. salt",
                    "1/4 tsp. pepper"
                ],
                directions: [
                    "In a slow cooker, combine all ingredients. Cover and cook on low for 4 hours or until heated through and cheese is melted. Stir well before serving. Yields 6 servings."
                ],
                Foods: [
                    "frozen corn",
                    "cream cheese",
                    "butter",
                    "garlic powder",
                    "salt",
                    "pepper"
                ],
                description: ["🍳 Difficulty: Easy",
                              "🍴 Preparation: 20 min",
                              "🥘 Cooking: 55 min",
                              "⚖️ Serving for: 8 people",
                              "€ Price: Low"]
            ),
            Recipe(
                title: "Cheeseburger Potato Soup",
                image: "potatosoup",
                category: "🥘Easy Dinner",
                ingredients: [
                    "6 baking potatoes",
                    "1 lb. of extra lean ground beef",
                    "2/3 c. butter or margarine",
                    "6 c. milk",
                    "3/4 tsp. salt",
                    "1/2 tsp. pepper",
                    "1 1/2 c (6 oz.) shredded Cheddar cheese, divided",
                    "12 sliced bacon, cooked, crumbled and divided",
                    "4 green onion, chopped and divided",
                    "1 (8 oz.) carton sour cream (optional)"
                ],
                directions: [
                    "Wash potatoes; prick several times with a fork.",
                    "Microwave them with a wet paper towel covering the potatoes on high for 6-8 minutes.",
                    "The potatoes should be soft, ready to eat.",
                    "Let them cool enough to handle.",
                    "Cut in half lengthwise; scoop out pulp and reserve.",
                    "Discard shells.",
                    "Brown ground beef until done.",
                    "Drain any grease from the meat.",
                    "Set aside when done.",
                    "Meat will be added later.",
                    "Melt butter in a large kettle over low heat; add flour, stirring until smooth.",
                    "Cook 1 minute, stirring constantly. Gradually add milk; cook over medium heat, stirring constantly, until thickened and bubbly.",
                    "Stir in potato, ground beef, salt, pepper, 1 cup of cheese, 2 tablespoons of green onion and 1/2 cup of bacon.",
                    "Cook until heated (do not boil).",
                    "Stir in sour cream if desired; cook until heated (do not boil).",
                    "Sprinkle with remaining cheese, bacon and green onions."
                ],
                Foods: [
                    "baking potatoes",
                    "extra lean ground beef",
                    "butter",
                    "milk",
                    "salt",
                    "pepper",
                    "Cheddar cheese",
                    "bacon",
                    "green onion",
                    "sour cream"
                ],
                description: ["🍳 Difficulty: Easy",
                              "🍴 Preparation: 20 min",
                              "🥘 Cooking: 55 min",
                              "⚖️ Serving for: 8 people",
                              "€ Price: Low"]
            ),
        Recipe(title: "Apple Pie",
               image: "apple pie",
               ingredients: ["930g Rennet apple",
                            " 2 1/4 cups flour 00",
                            "2/3 cup whole milk",
                            "1 lemon",
                            "1 tsp Cinnamon powder",
                            "1 cup sugar",
                             "1/2 cup butter",
                            "2 eggs",
                            "1 tbsp Baking powder",
                            "1 pinch Fine salt"],
               directions: ["To make the apple cake, first melt the butter in the microwave or over a bain-marie, and set aside. Grate the lemon zest and squeeze the juice out of it to obtain around 2 tbsp (30 g), then set both the zest and the juice aside. Slice the apples in half and remove the cores",
                    "Peel the apples, then cut them into quarters, and slice them down the short side",
                    "Place the sliced apples in a bowl, sprinkle them with the lemon juice, and mix well. This will help prevent them from going brown. Next, sift the cake flour with the baking powder. Then, pour the eggs and some of the sugar into a large bowl. Start beating with a hand mixer and continue pouring in the sugar a little at a time",
                           "When the mixture begins to lighten, add a pinch of salt and continue whisking until the mixture is light and fluffy. At this point, add the melted butter, now at room temperature. Flavor with the cinnamon powder and add the grated lemon peel. Add the sifted flour and baking powder a spoonful at a time, continuing to whisk as you do so. Once the dry ingredients are thoroughly mixed in, lower the speed of the hand mixer and drizzle in the milk, which should also be at room temperature",
                            "Once the milk is thoroughly mixed in, turn off the mixer; the cake batter is ready. Drain the apples in a colander to remove the lemon juice and add them to the mixture",
                           "Gently mix from the bottom up to ensure the ingredients are thoroughly incorporated. Butter and sprinkle with sugar a 9-inch (22-cm) cake pan and pour in the batter with the help of a spatula. The cake is ready to be baked in a conventional oven preheated to 350°F (180°C) for around 55 minutes",
                           "Once baked, take it out of the oven and leave to cool completely before removing it from the pan. Dust the cake with powdered sugar and serve: Your apple cake is ready to be enjoyed!"],
               Foods: ["apple",
                      "flour",
                      "milk",
                      "lmeon",
                      "cinnamon powder",
                      "sugar",
                      "butter",
                      "eggs",
                      "baking powder",
                      "salt"],
               description: ["🍳 Difficulty: Easy",
                             "🍴 Preparation: 20 min",
                             "🥘 Cooking: 55 min",
                             "⚖️ Serving for: 8 people",
                             "€ Price: Low"]
              )
    ]
}

var sharedDataRecipe = SharedDataRecipe()

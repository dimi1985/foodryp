import 'package:flutter/material.dart';

class Constants {
  static final List<String> menuItems = [
    'Home',
    'Creators',
    'Recipes',
    'My Fridge',
    'Login/Register'
  ];

  static final List<Map<String, dynamic>> categories = [
    {
      'title': 'Italian',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.red, // Red color for Italian category
    },
    {
      'title': 'Vegetarian',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.green, // Green color for Vegetarian category
    },
    {
      'title': 'Asian',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.yellow, // Yellow color for Asian category
    },
    {
      'title': 'Mexican',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.orange, // Orange color for Mexican category
    },
    {
      'title': 'American',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.blue, // Blue color for American category
    },
    {
      'title': 'Seafood',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.teal, // Teal color for Seafood category
    },
    {
      'title': 'Breakfast',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.pink, // Pink color for Breakfast category
    },
    {
      'title': 'Desserts',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.purple, // Purple color for Desserts category
    },
    {
      'title': 'Soups & Salads',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color':
          Colors.lightGreen, // Light green color for Soups & Salads category
    },
    {
      'title': 'Drinks',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.lightBlue, // Light blue color for Drinks category
    },
    // Add 5 more items here
    {
      'title': 'Indian',
      'image': 'https://picsum.photos/200/300',
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Chinese',
      'image': 'https://picsum.photos/200/300',
      'color': Colors.redAccent,
    },
    {
      'title': 'French',
      'image': 'https://picsum.photos/200/300',
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Thai',
      'image': 'https://picsum.photos/200/300',
      'color': Colors.lightGreenAccent,
    },
    {
      'title': 'Middle Eastern',
      'image': 'https://picsum.photos/200/300',
      'color': Colors.yellowAccent,
    },
  ];

  static final List<Map<String, dynamic>> regularRecipes = [
    {
      'image': 'https://picsum.photos/200/300',
      'title': 'Spicy Chicken Curry',
      'ingredients': [
        '1 kg boneless, skinless chicken thighs',
        '2 tbsp curry powder',
        '1 tsp turmeric',
        '1 tsp ground ginger',
        '1 tsp ground cumin',
        '1/2 tsp chili powder (optional)',
        '1 (400ml) can coconut milk',
        '1 onion, chopped',
        '2 cloves garlic, minced',
        '1 green bell pepper, chopped',
        '1 (400g) can chopped tomatoes',
        'Cilantro, chopped (for garnish)',
        'Cooked rice (for serving)',
      ],
      'duration': '45 minutes',
      'difficulty': 'Medium',
      'username': 'JohnDoe123',
      'date': DateTime(2024, 3, 30),
      'color': Colors.orangeAccent,
    },
    {
      'image': 'https://picsum.photos/200/300',
      'title': 'Creamy Tomato Pasta',
      'ingredients': [
        '500g pasta of your choice',
        '2 tbsp olive oil',
        '1 onion, chopped',
        '2 cloves garlic, minced',
        '400g can chopped tomatoes',
        '1 tbsp tomato paste',
        '1/2 cup heavy cream',
        '1/4 cup grated Parmesan cheese',
        'Fresh basil leaves (for garnish)',
        'Salt and pepper to taste',
      ],
      'duration': '30 minutes',
      'difficulty': 'Easy',
      'username': 'JaneSmith87',
      'date': DateTime(2024, 3, 29),
      'color': Colors.redAccent,
    },
    {
      'image': 'https://picsum.photos/200/300',
      'title': 'Cheesy Baked Broccoli',
      'ingredients': [
        '1 head broccoli, cut into florets',
        '2 tbsp olive oil',
        '1/2 onion, chopped',
        '2 cloves garlic, minced',
        '1/4 cup all-purpose flour',
        '2 cups milk',
        '1 cup shredded cheddar cheese',
        '1/4 cup grated Parmesan cheese',
        'Salt and pepper to taste',
        'Breadcrumbs (optional, for topping)',
      ],
      'duration': '40 minutes',
      'difficulty': 'Easy',
      'username': 'HealthyEater2020',
      'date': DateTime(2024, 3, 28),
      'color': Colors.purpleAccent,
    },
    {
      'image': 'https://picsum.photos/200/300',
      'title': 'Black Bean Burgers',
      'ingredients': [
        '1 (15-oz) can black beans, rinsed and drained',
        '1/2 cup cooked brown rice',
        '1/4 cup breadcrumbs',
        '1/4 cup chopped onion',
        '1 egg, beaten',
        '1 tbsp olive oil',
        '1 tsp chili powder',
        '1/2 tsp cumin',
        '1/4 tsp salt',
        'Hamburger buns',
        'Your favorite burger toppings (optional)',
      ],
      'duration': '30 minutes',
      'difficulty': 'Medium',
      'username': 'TheGreenChef',
      'date': DateTime(2024, 3, 27),
      'color': Colors.lightBlue,
    },
    // ... add more regular recipes
  ];

  static final List<Map<String, dynamic>> topCreators = [
    {
      'image': 'https://picsum.photos/200/300', // Replace with image URL
      'user': 'dimi85',
      'totalRecipes': '30',
    },
    {
      'image': 'https://picsum.photos/200/300', // Replace with image URL
      'user': 'Rina90',
      'totalRecipes': '25',
    },
    {
      'image': 'https://picsum.photos/200/300', // Replace with image URL
      'user': 'skwtsias',
      'totalRecipes': '24',
    },
    {
      'image': 'https://picsum.photos/200/300', // Replace with image URL
      'user': 'kark90',
      'totalRecipes': '20',
    },
    {
      'image': 'https://picsum.photos/200/300', // Replace with image URL
      'user': 'baggelas',
      'totalRecipes': '15',
    },
  ];
}

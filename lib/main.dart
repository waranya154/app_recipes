import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red,
          secondary: Colors.orange,
        ),
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.yellow[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardColor: Colors.orange[50],
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.brown[900],
              displayColor: Colors.red[900],
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const RecipesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  Future<List<dynamic>> fetchRecipes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สูตรอาหาร'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text('เกิดข้อผิดพลาด', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'ไม่พบข้อมูลสูตรอาหาร',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeCard(recipe: recipe);
              },
            );
          }
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final dynamic recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe['image'] != null && recipe['image'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.orange[100],
                    child: const Icon(Icons.image_not_supported, color: Colors.orange),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              recipe['name'] ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ประเภท: ${recipe['cuisine'] ?? '-'}',
              style: TextStyle(color: Colors.orange[800]),
            ),
            const SizedBox(height: 4),
            Text(
              'เวลาเตรียม: ${recipe['prepTimeMinutes'] ?? '-'} นาที | ทำอาหาร: ${recipe['cookTimeMinutes'] ?? '-'} นาที',
              style: TextStyle(color: Colors.brown[700]),
            ),
            const SizedBox(height: 8),
            const Text('ส่วนผสม:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            ...((recipe['ingredients'] as List<dynamic>? ?? []).map((ing) => Text('- $ing')).toList()),
            const SizedBox(height: 8),
            const Text('คำแนะนำ:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ...((recipe['instructions'] as List<dynamic>? ?? []).map((step) => Text('• $step')).toList()),
          ],
        ),
      ),
    );
  }
}

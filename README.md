# app_recipes

# 🍽️ แอปสูตรอาหาร (Recipes App)
แอปพลิเคชัน Flutter สำหรับแสดงสูตรอาหารจาก API สาธารณะ พร้อมการออกแบบ UI ที่

แอป **Recipes** เป็นแอปพลิเคชัน Flutter ที่ดึงข้อมูลสูตรอาหารจาก [DummyJSON Recipes API](https://dummyjson.com/recipes) มาแสดงในรูปแบบการ์ด (Card) สวยงาม พร้อมรายละเอียด เช่น  
- รูปภาพอาหาร  
- ชื่อเมนู  
- ประเภทอาหาร  
- เวลาการเตรียมและทำอาหาร  
- ส่วนผสม  
- คำแนะนำในการทำ  

---

## ✨ คุณสมบัติ (Features)

- 📡 **ดึงข้อมูลจาก API แบบเรียลไทม์**  
- 🖼️ **แสดงรูปภาพอาหาร** (รองรับ placeholder กรณีโหลดภาพไม่ได้)  
- 🗂️ **แยกรายการอาหารออกเป็นการ์ด** เพื่อให้อ่านง่าย  
- 🛠️ **ใช้ FutureBuilder** จัดการสถานะการโหลด  
- 🎨 **ธีมสีสันสดใส** (โทนแดง-ส้ม-เหลือง)  

---

## 🛠️ เทคโนโลยีที่ใช้

- **[Flutter](https://flutter.dev/)** – Framework สำหรับพัฒนา Mobile App  
- **[HTTP](https://pub.dev/packages/http)** – สำหรับการดึงข้อมูลจาก API  
- **[DummyJSON API](https://dummyjson.com/)** – แหล่งข้อมูลสูตรอาหาร  

---

## 📂 โครงสร้างไฟล์ (Project Structure)

```plaintext
lib/
 ├── main.dart             # จุดเริ่มต้นของแอป
 ├── screens/
 │     └── recipes_screen.dart  # หน้าหลักสำหรับแสดงสูตรอาหาร
 ├── widgets/
 │     └── recipe_card.dart     # UI การ์ดสูตรอาหาร

---
## 🚀 การติดตั้งและใช้งาน
1. Clone โปรเจกต์
    git clone https://github.com/yourusername/recipes_app.git
    cd recipes_app
2. ติดตั้ง Dependencies
    flutter pub get
3. รันโปรเจกต์
    flutter run

🔗 API Endpoint ที่ใช้
URL: https://dummyjson.com/recipes
Method: GET
Response ตัวอย่าง:
    {
  "recipes": [
    {
      "name": "Spaghetti Carbonara",
      "image": "https://example.com/image.jpg",
      "cuisine": "Italian",
      "prepTimeMinutes": 15,
      "cookTimeMinutes": 20,
      "ingredients": ["Spaghetti", "Eggs", "Bacon"],
      "instructions": ["Boil pasta", "Cook bacon", "Mix together"]
    }
  ]
}
---
## 📦 Dependencies ที่ใช้
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2
  http: ^1.5.0
---
## 🧪 ตัวอย่างโค้ด
🔹 ดึงข้อมูลสูตรอาหารจาก API
Future<List<dynamic>> fetchRecipes() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['recipes'];
  } else {
    throw Exception('Failed to load recipes');
  }
}
---
🔹 แสดงการ์ดสูตรอาหาร
class RecipeCard extends StatelessWidget {
  final dynamic recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(recipe['image']),
          Text(recipe['name']),
          Text('ประเภท: ${recipe['cuisine']}'),
        ],
      ),
    );
  }
}
---

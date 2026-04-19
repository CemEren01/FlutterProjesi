import 'package:flutter/material.dart'; //Fluuter'ın temel kütüphanesi
import 'screens/giris_sayfasi.dart'; //Giriş sayfasını kullanabilmek için ekledim. Uygulama başladığında bu sayfa açılacak.

void main() { //Uygulamanın başlangıç noktası.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //MyApp sınıfı, uygulamanın temel yapısını tanımlar. StatelessWidget olduğu için bu widget'ın durumu değişmez.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { //build metodu, widget'ın nasıl görüneceğini tanımlar. MaterialApp widget'ı, uygulamanın genel teması ve yönlendirmesi gibi özellikleri sağlar.
    return MaterialApp(
      title: 'AI Model Hub & Performance Estimator', //Uygulanamanın başlığı
      debugShowCheckedModeBanner: false, //Debug modunda sağ üst köşede çıkan "Debug" etiketini kaldırır.
      theme: ThemeData( //Uygulamanın genel temasını tanımlar. Renkler, yazı tipleri ve diğer görsel özellikler burada belirlenir.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6FA5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6F8), //Uygulamanın genel arka plan rengini belirler.
        appBarTheme: const AppBarTheme( //AppBar'ın temasını tanımlar. Arka plan rengi, yazı rengi, gölge ve diğer özellikler burada belirlenir.
          backgroundColor: Color(0xFF4A6FA5),
          foregroundColor: Colors.white,
          elevation: 0, //AppBar'ın gölgesiz görünmesini sağlar.
          centerTitle: true, //AppBar başlığının ortalanmasını sağlar.
          titleTextStyle: TextStyle( //AppBar başlığının yazı stilini belirler. Renk, boyut ve kalınlık gibi özellikler burada tanımlanır.
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( //ElevatedButton'ların temasını tanımlar. Arka plan rengi, yazı rengi, padding, şekil ve yazı stili gibi özellikler burada belirlenir.
          style: ElevatedButton.styleFrom( //Bu kısım ElevatedButton'ların genel görünümünü belirler. Renkler, padding, şekil ve yazı stili gibi özellikler burada tanımlanır.
            backgroundColor: const Color(0xFF4A6FA5), //Butonun arka plan rengini belirler.
            foregroundColor: Colors.white, //Butonun yazı rengini belirler.
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder( //Butonun şeklini belirler. Burada köşeleri yuvarlatılmış bir dikdörtgen kullanılmıştır.
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle( //Butonun yazı stilini belirler. Renk, boyut ve kalınlık gibi özellikler burada tanımlanır.
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme( //TextField'ların temasını tanımlar. Dolgu, kenarlık, padding ve diğer görsel özellikler burada belirlenir.
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A6FA5), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        useMaterial3: true,
      ),
      home: const GirisSayfasi(),
    );
  }
}

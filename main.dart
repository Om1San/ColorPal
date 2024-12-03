import 'package:flutter/material.dart';
//import 'package:flutter/services.dart'; // Importar para funcionalidad de clipboard
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:math';

void main() {//funcion principal
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(), //primera al abrir la app 
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // Efecto Fade-in para la pantalla de carga
      });
    });

    // After 3 seconds, navigate to the main screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F5DC),
              Color(0xFFE1C8A3), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 2), // Duracion del Fade in
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.palette,
                  color: Colors.brown.shade900,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.brown.shade900,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF5F5DC), 
                  ),
                  child: Text(
                    'Welcome to ColorPal',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown.shade900),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6d4217),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,//elimina sombra abajo del app bar
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(109, 67, 25, 1),
      title: const Text(
        "Color Pal",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: Color(0xffcab19d),//color del titulo
        ),
      ),
      leading: const Icon(
        Icons.settings,
        color: Color(0xffcbb29e),//color del icono de settings
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,//expande para la patalla completa
      height: MediaQuery.of(context).size.height * 0.87,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(100.0)),
        border: Border.all(color: const Color(0x4d9e9e9e)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(50),
        itemCount: 10,
        
        itemBuilder: (context, index) {
          return _buildPaletteItem(index, context);
        },
      ),
    );
  }

  Widget _buildPaletteItem(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 60),
            height: 130,
            width: 250,
            decoration: BoxDecoration(
              color: Color(0xff6d4319 + index),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 10, 0),
              child: MaterialButton(
                onPressed: () {},
                color: const Color.fromRGBO(109, 67, 25, 1),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textColor: Colors.black,
                child: Text(
                  "${index + 1}. Palette",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const Image(
            image: AssetImage("assets/images/wheel.png"),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  
}

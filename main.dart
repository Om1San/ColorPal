import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import services for clipboard functionality
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorPal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
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
        _opacity = 1.0; // Fade-in effect for the splash screen
      });
    });

    // After 3 seconds, navigate to the main screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PalettePage()),
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
              Color(0xFFF5F5DC), // Beige
              Color(0xFFE1C8A3), // Light warm brownish yellow
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 2), // Fade duration
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
                    color: const Color(0xFFF5F5DC), // Beige color inside container
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

class PalettePage extends StatefulWidget {
  @override
  _PalettePageState createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> {

  // Declare new variables for the color mixing section
  Color _mixColor1 = Colors.red; // Slot 1 default color for mixing
  Color _mixColor2 = Colors.blue; // Slot 2 default color for mixing
  Color? _mixedColor; // The resulting mixed color

  // Function to mix two colors and return the result
  Color _mixColors(Color color1, Color color2) {
    int red = ((color1.red + color2.red) / 2).toInt();
    int green = ((color1.green + color2.green) / 2).toInt();
    int blue = ((color1.blue + color2.blue) / 2).toInt();

    return Color.fromRGBO(red, green, blue, 1.0); // Mix colors and return
  }

  // Function to open color picker for Slot 1
  void _pickColor1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick First Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _mixColor1,
              onColorChanged: (Color color) {
                setState(() {
                  _mixColor1 = color;
                });
              },
              labelTypes: const [],
              // No labels
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Set Color'),
              onPressed: () {
                setState(() {
                  _mixedColor = _mixColors(
                      _mixColor1, _mixColor2); // Recalculate mixed color
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Function to open color picker for Slot 2
  void _pickColor2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Second Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _mixColor2,
              onColorChanged: (Color color) {
                setState(() {
                  _mixColor2 = color;
                });
              },
              labelTypes: [],
              // No labels
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Set Color'),
              onPressed: () {
                setState(() {
                  _mixedColor = _mixColors(
                      _mixColor1, _mixColor2); // Recalculate mixed color
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // Function to copy the mixed color to the clipboard
  void _copyMixedColorToClipboard() {
    if (_mixedColor != null) {
      String hexColor = '#${_mixedColor!.value.toRadixString(16).padLeft(8, '0').substring(2)}';
      Clipboard.setData(ClipboardData(text: hexColor)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Color copied: $hexColor')),
        );
      });
    }
  }

  // Function to display the Color Mixing section
  Widget _buildColorMixingSection() {
    return Align(
      alignment: Alignment.topCenter,  // Align the section to the top
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),  // Adjust this value to move it up
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            // First two slots for picking colors
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
              children: [
                // Slot 1 for picking color
                GestureDetector(
                  onTap: _pickColor1, // Open color picker for Slot 1
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      color: _mixColor1, // Default to light grey if null
                      border: Border.all(
                        color: Colors.brown.shade900,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _mixColor1 == false
                          ? Icon(Icons.color_lens, color: Colors.brown.shade900) // Show color lens icon when empty
                          : null,
                    ),
                  ),
                ),

                const SizedBox(width: 20), // Space between the color pickers

                // Slot 2 for picking color
                GestureDetector(
                  onTap: _pickColor2, // Open color picker for Slot 2
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      color: _mixColor2, // Default to light grey if null
                      border: Border.all(
                        color: Colors.brown.shade900,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _mixColor2 == false
                          ? Icon(Icons.color_lens, color: Colors.brown.shade900) // Show color lens icon when empty
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Space between the color pickers and mixed color slot

            // Slot for the mixed color
            GestureDetector(
              onTap: _mixedColor == null ? null : _copyMixedColorToClipboard, // Disable click if no mixed color
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  color: _mixedColor ?? Colors.grey[200], // Default to light grey if null
                  border: Border.all(
                    color: Colors.brown.shade900,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _mixedColor == null
                      ? Icon(Icons.palette, color: Colors.brown.shade900) // Default palette icon
                      : const Text(
                    'Mixed Color',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFF5F5DC)), // Light beige color for text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _color1 = Colors.blue;
  Color _color2 = Colors.red;
  String _color1Hex = "#0000FF";
  String _color2Hex = "#FF0000";

  // Renamed the function for gradient color picker
  void _openColorPickerForGradient(int colorSlot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: colorSlot == 1 ? _color1 : _color2,
              onColorChanged: (Color color) {
                setState(() {
                  if (colorSlot == 1) {
                    _color1 = color;
                    _color1Hex = '#${color.value.toRadixString(16).padLeft(
                        8, '0').substring(2)}';
                  } else {
                    _color2 = color;
                    _color2Hex = '#${color.value.toRadixString(16).padLeft(
                        8, '0').substring(2)}';
                  }
                });
              },
              labelTypes: [],
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Set Color'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradientColorSelector() {
    return Column(
      children: [
        // Color 1 Slot
        GestureDetector(
          onTap: () => _openColorPickerForGradient(1),
          // Call the renamed function here
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: _color1,
              border: Border.all(
                color: Colors.brown.shade900,
                // Border color set to the same brown as the custom palette
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _color1Hex,
                style: const TextStyle(
                  color: Color(0xFFF5F5DC),
                  // Change hex color to the same brown as the border
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Color 2 Slot
        GestureDetector(
          onTap: () => _openColorPickerForGradient(2),
          // Call the renamed function here
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: _color2,
              border: Border.all(
                color: Colors.brown.shade900,
                // Border color set to the same brown as the custom palette
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _color2Hex,
                style: const TextStyle(
                  color: Color(0xFFF5F5DC),
                  // Change hex color to the same brown as the border
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Gradient Preview Slot
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.brown.shade900,
              // Border color set to match the other slots
              width: 3,
            ),
            gradient: LinearGradient(
              colors: [_color1, _color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              "Gradient Preview",
              style: TextStyle(
                color: Color(0xFFF5F5DC),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularColors() {
    // List of 10 rows with 6 colors in each row (colors in hex format)
    final List<List<Color>> popularColors = [
      // Reds and Pinks (Vibrant and attention-grabbing)
      [
        const Color(0xFFFF0000),
        const Color(0xFFFF6347),
        const Color(0xFFDC143C),
        const Color(0xFFFF1493),
        const Color(0xFFFF69B4),
        const Color(0xFFB22222)
      ],

      // Oranges and Yellows (Warm and energetic colors)
      [
        const Color(0xFFFFA500),
        const Color(0xFFFFE4B5),
        const Color(0xFFFFD700),
        const Color(0xFFF0E68C),
        const Color(0xFFDAA520),
        const Color(0xFFFF4500)
      ],

      // Greens (Nature-inspired and calming)
      [
        const Color(0xFF32CD32),
        const Color(0xFF228B22),
        const Color(0xFF00FF7F),
        const Color(0xFF7FFF00),
        const Color(0xFF006400),
        const Color(0xFF8FBC8F)
      ],

      // Blues (Serene and trustworthy)
      [
        const Color(0xFF0000FF),
        const Color(0xFF1E90FF),
        const Color(0xFF4682B4),
        const Color(0xFF00CED1),
        const Color(0xFF1C39BB),
        const Color(0xFF5F9EA0)
      ],

      // Purples and Violets (Creative and elegant)
      [
        const Color(0xFF800080),
        const Color(0xFF8A2BE2),
        const Color(0xFF9370DB),
        const Color(0xFF6A5ACD),
        const Color(0xFF4B0082),
        const Color(0xFF9B30B0)
      ],

      // Pastels (Soft, light colors for modern UI design)
      [
        const Color(0xFFFAEBD7),
        const Color(0xFFFFF0F5),
        const Color(0xFFEEE8AA),
        const Color(0xFF98FB98),
        const Color(0xFFBDB76B),
        const Color(0xFFF5F5DC)
      ],

      // Teals and Turquoises (Fresh and cool tones)
      [
        const Color(0xFF00FFFF),
        const Color(0xFF40E0D0),
        const Color(0xFF48D1CC),
        const Color(0xFF20B2AA),
        const Color(0xFF008080),
        const Color(0xFF66CDAA)
      ],

      // Neutrals (Modern, sleek, and professional)
      [
        const Color(0xFFC0C0C0),
        const Color(0xFF808080),
        const Color(0xFF000000),
        const Color(0xFFBEBEBE),
        const Color(0xFFD3D3D3),
        const Color(0xFF708090)
      ],

      // Browns and Earthy Tones (Grounded and cozy)
      [
        const Color(0xFF8B4513),
        const Color(0xFFD2691E),
        const Color(0xFFCD853F),
        const Color(0xFFD2B48C),
        const Color(0xFFBC8F8F),
        const Color(0xFF6B4226)
      ],

      // Dark and Moody Blues (Sophisticated and sleek)
      [
        const Color(0xFF191970),
        const Color(0xFF00008B),
        const Color(0xFF0000CD),
        const Color(0xFF003366),
        const Color(0xFF8B0000),
        const Color(0xFF3B4C6B)
      ],
    ];

    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // 6 colors per row
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: popularColors.length * 6, // 6 colors per row
      itemBuilder: (context, index) {
        int rowIndex = index ~/ 6; // Get the row index
        int colIndex = index % 6; // Get the column index
        Color color = popularColors[rowIndex][colIndex];

        return GestureDetector(
          onTap: () {
            _copyColorToClipboard(
                color); // Copy the color to clipboard when tapped
          },
          child: Container(
            width: 50, // Fixed width of each color box
            height: 50, // Fixed height of each color box
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        );
      },
    );
  }

  // Default color palettes (10 rows of organized colors)
  List<List<Color>> _defaultPalettes = [
    // Row 1: Primary colors
    [Colors.red, Colors.blue, Colors.yellow],

    // Row 2: Secondary colors
    [Colors.orange, Colors.green, Colors.purple],

    // Row 3: Neutral tones
    [Colors.black, Colors.white, Colors.grey],

    // Row 4: Warm tones
    [Colors.orangeAccent, Colors.deepOrange, Colors.amber],

    // Row 5: Cool tones
    [Colors.cyan, Colors.teal, Colors.indigo],

    // Row 6: Pastel colors
    [
      Colors.pink.shade100,
      Colors.lightBlue.shade100,
      Colors.lightGreen.shade100
    ],

    // Row 7: Earth tones
    [Colors.brown, Colors.green.shade800, Colors.yellow.shade700],

    // Row 8: Blue shades
    [Colors.blueAccent, Colors.lightBlue, Colors.blueGrey],

    // Row 9: Purple & pink shades
    [Colors.purple.shade300, Colors.pinkAccent, Colors.pink.shade300],

    // Row 10: Miscellaneous tones
    [Colors.lime, Colors.deepPurpleAccent, Colors.pink],
  ];

  // Customizable palette (10 rows of 3 empty slots)
  List<List<Color?>> _customPalette = List.generate(
    10, // 10 rows
        (index) =>
        List.generate(3, (index) => null), // 3 columns per row, initially empty
  );

  Color _currentColor = Colors.blue;
  int? _selectedRow;
  int? _selectedCol;

// Variable to track the selected section: 0 for Default, 1 for Customizable, 2 for Random Color
  int _selectedSection = 0;

  Color? _randomColor;

  @override
  void initState() {
    super.initState();
    _loadCustomPalette();
  }

// Load the custom palette from SharedPreferences
  void _loadCustomPalette() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? customPaletteData = prefs.getStringList('customPalette');

    if (customPaletteData != null) {
      for (int i = 0; i < customPaletteData.length; i++) {
        if (customPaletteData[i] != 'null') {
          _customPalette[i ~/ 3][i % 3] =
              Color(int.parse(customPaletteData[i]));
        }
      }
    }
    setState(() {});
  }

// Save the custom palette to SharedPreferences
  void _saveCustomPalette() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> customPaletteData = [];

    for (var row in _customPalette) {
      for (var color in row) {
        customPaletteData.add(color?.value.toString() ?? 'null');
      }
    }

    prefs.setStringList('customPalette', customPaletteData);
  }

// Function to open color picker dialog
  void _openCustomColorPicker(int rowIndex, int colIndex) {
    setState(() {
      _selectedRow = rowIndex;
      _selectedCol = colIndex;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  _currentColor = color;
                });
              },
              labelTypes: [],
              // Use empty list to disable labels
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Set Color'),
              onPressed: () {
                setState(() {
                  _customPalette[_selectedRow!][_selectedCol!] = _currentColor;
                });
                _saveCustomPalette(); // Save the palette after selecting a color
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Function to copy color to clipboard
  void _copyColorToClipboard(Color color) {
    String hexColor = '#${color.value.toRadixString(16)
        .padLeft(8, '0')
        .substring(2)}';
    Clipboard.setData(ClipboardData(text: hexColor)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Color copied: $hexColor')),
      );
    });
  }

// Function to delete color in the selected slot
  void _deleteColor() {
    setState(() {
      if (_selectedRow != null && _selectedCol != null) {
        _customPalette[_selectedRow!][_selectedCol!] =
        null; // Reset the color slot
        _selectedRow = null; // Clear the selection
        _selectedCol = null;
      }
    });
    _saveCustomPalette(); // Save the updated palette after deletion
  }

// Function to generate a random color
  Color _generateRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
      1, // Full opacity
    );
  }

// Function to generate a random color and set it to a single slot
  void _generateRandomColorSlot() {
    setState(() {
      _randomColor = _generateRandomColor();
    });
  }

// Function to build the default palette (Popular Colors section) with bigger slots
  Widget _buildDefaultPalette() {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double slotSize = (screenWidth - 32) /
        3; // Adjust slot size for the Popular Colors section

    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns per row
        crossAxisSpacing: 8.0, // Horizontal space between items
        mainAxisSpacing: 8.0, // Vertical space between items
      ),
      itemCount: _defaultPalettes.length * 3, // 3 colors per row
      itemBuilder: (context, index) {
        int rowIndex = index ~/ 3; // Get the row index
        int colIndex = index % 3; // Get the column index

        // Get the color for this slot
        Color color = _defaultPalettes[rowIndex][colIndex];

        return GestureDetector(
          onTap: () {
            _copyColorToClipboard(
                color); // Copy the color to clipboard when tapped
          },
          child: Container(
            width: slotSize, // Dynamically set the width of each slot
            height: slotSize, // Dynamically set the height of each slot
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.brown.shade900,
                width: 3,
              ),
            ),
          ),
        );
      },
    );
  }

// Function to build the custom palette with editable slots
  Widget _buildCustomPalette() {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns per row
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 30, // 10 rows * 3 columns = 30 slots
            itemBuilder: (context, index) {
              int rowIndex = index ~/ 3; // Get the row index
              int colIndex = index % 3; // Get the column index

              // Get the color for this slot
              Color? color = _customPalette[rowIndex][colIndex];

              return GestureDetector(
                onTap: () {
                  if (color == null) {
                    // If the slot is empty, open the color picker
                    _openCustomColorPicker(
                        rowIndex, colIndex); // Updated method call here
                  } else {
                    // Copy the color if the slot is filled
                    setState(() {
                      _selectedRow = rowIndex;
                      _selectedCol = colIndex;
                    });
                    _copyColorToClipboard(color);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? Colors.grey[100],
                    // Empty slots have a light grey background
                    border: Border.all(
                      color: Colors.brown.shade900,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: color == null
                      ? Center(
                    child: Icon(
                      Icons.add, // Plus symbol to add a custom color
                      color: Colors.brown.shade700,
                      size: 24,
                    ),
                  )
                      : null, // Show the color if it's already set
                ),
              );
            },
          ),
        ),
        // Show the delete button if a slot is selected
        if (_selectedRow != null && _selectedCol != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: _deleteColor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade800,
                // Match button background with beige theme
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30.0), // Rounded corners for elegance
                ),
                elevation: 5,
              ),
              child: Text(
                "Delete Color",
                style: TextStyle(
                  color: Colors.brown.shade50,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          // Make the app bar transparent
          iconTheme: IconThemeData(color: Colors.brown.shade50),
          // Change the hamburger menu color
          title: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown.shade900, width: 3),
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF5F5DC), // Beige color for the title background
            ),
            child: Text(
              'ColorPal 🎨',
              style: TextStyle(
                color: Colors.brown.shade800,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF5F5DC), // Beige
                  Color(0xFFE1C8A3), // Light warm brownish yellow
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade800,
                    // Darker background for the header
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)), // Rounded top corners
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    // Align the content to the left (same as ListTiles)
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      // Padding around the text
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.brown.shade900, width: 3),
                        // Border around the text
                        borderRadius: BorderRadius.circular(10),
                        // Rounded corners
                        color: const Color(
                            0xFFF5F5DC), // Beige background to match ColorPal style
                      ),
                      child: Text(
                        'Menu 🖌️',
                        style: TextStyle(
                          color: Colors.brown.shade800,
                          // Dark brown text color to match the theme
                          fontSize: 24,
                          // Font size for the text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.palette, color: Colors.brown.shade900),
                  title: Text(
                    'Default Colors',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => _onMenuItemSelected(0),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.brown.shade900),
                  title: Text(
                    'Popular Colors',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => _onMenuItemSelected(
                      3), // Choose index 3 for Popular Colors
                ),
                ListTile(
                  leading: Icon(Icons.brush, color: Colors.brown.shade900),
                  title: Text(
                    'Color Mixing',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => _onMenuItemSelected(5), // New index for Color Mixing
                ),
                ListTile(
                  leading: Icon(Icons.gradient, color: Colors.brown.shade900),
                  title: Text(
                    'Gradient Colors Preview',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => _onMenuItemSelected(
                      4), // New index for Gradient Color Selector
                ),
                ListTile(
                  leading: Icon(Icons.create, color: Colors.brown.shade900),
                  title: Text(
                    'Customizable Colors',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => _onMenuItemSelected(1),
                ),
                ListTile(
                  leading: Icon(Icons.shuffle, color: Colors.brown.shade900),
                  title: Text(
                    'Random Color Generator',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => _onMenuItemSelected(2),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF5F5DC), // Beige
                Color(0xFFE1C8A3), // Light warm brownish yellow
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display Default Palettes, Custom Palettes, Random Color Generator, Popular Colors, or Gradient Color Selector based on the selected section
              Expanded(
                child: _selectedSection == 0
                    ? _buildDefaultPalette()
                    : _selectedSection == 1
                    ? _buildCustomPalette()
                    : _selectedSection == 2
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_randomColor != null) {
                            _copyColorToClipboard(_randomColor!);
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: _randomColor ?? Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.brown.shade900,
                              width: 3,
                            ),
                          ),
                          child: _randomColor == null
                              ? Icon(Icons.refresh,
                              color: Colors.brown.shade900)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: _generateRandomColorSlot,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade800,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Generate",
                        style: TextStyle(
                          color: Colors.brown.shade50,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                    : _selectedSection == 3
                    ? _buildPopularColors() // Display the popular colors grid
                    : _selectedSection == 4
                    ? _buildGradientColorSelector() // Display gradient color selector
                    :_selectedSection == 5
                    ? _buildColorMixingSection() // Show the color mixing section
                    : const SizedBox
                    .shrink(), // Default empty widget for other states
              ),
            ],
          ),
        )
    );
  }

  // Function to handle selecting a menu item
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedSection = index;
    });
    Navigator.pop(context); // Close the drawer
  }
}
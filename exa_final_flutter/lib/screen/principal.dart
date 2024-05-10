import 'package:flutter/material.dart';
import 'package:exa_final_flutter/screen/categorie_page.dart';
import 'package:exa_final_flutter/screen/supplier_page.dart';
import 'package:exa_final_flutter/screen/products_page.dart';
import 'package:exa_final_flutter/screen/login_screen.dart'; // Importa correctamente la pantalla de inicio de sesión

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Esto oculta el banner de modo debug
      home: HomeScreen(),
      routes: {
        '/login_screen': (context) =>
            LoginScreen(), // Ruta para la pantalla de inicio de sesión
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    SuppliersPage(),
    CategoriesPage(),
    ProductsPage(),
    Text('Cerrar Sesión'), // Placeholder visual para la opción de cerrar sesión
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _logout(context); // Lógica para manejar el cierre de sesión
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Sistema'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey[600],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Proveedores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Productos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

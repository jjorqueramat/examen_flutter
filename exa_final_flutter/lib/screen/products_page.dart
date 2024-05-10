import 'package:flutter/material.dart';
import 'package:exa_final_flutter/services/product_service.dart';
import '../providers/product.dart'; // Asegúrate de que esta ruta de importación es correcta.

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Product product = snapshot.data![index];
                return Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditProductDialog(product),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(),
        tooltip: 'Agregar Producto',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nuevo Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nombre",
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: "Precio",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    hintText: "URL Imagen",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Product newProduct = Product(
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  imageUrl: imageUrlController.text,
                  id: 0, // El ID se ajustará en la API si es necesario
                  state: 'Activo',
                );
                ProductService().addProduct(newProduct).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureProducts =
                        ProductService().fetchProducts(); // Recargar la lista
                  });
                }).catchError((error) {
                  print('Error: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(Product product) {
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController imageUrlController =
        TextEditingController(text: product.imageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nombre",
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: "Precio",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    hintText: "URL Imagen",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar Cambios'),
              onPressed: () {
                Product updatedProduct = Product(
                  id: product.id,
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  imageUrl: imageUrlController.text,
                  state: product.state,
                );
                ProductService().editProduct(updatedProduct).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureProducts =
                        ProductService().fetchProducts(); // Recargar la lista
                  });
                }).catchError((error) {
                  print('Error: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás de eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                ProductService().deleteProduct(product.id).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureProducts =
                        ProductService().fetchProducts(); // Recargar la lista
                  });
                }).catchError((error) {
                  print('Error: $error');
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:exa_final_flutter/providers/categorie.dart';
import 'package:exa_final_flutter/services/categorie_service.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
    futureCategories = CategoryService().fetchCategories();
  }

  void _refreshCategories() {
    setState(() {
      futureCategories = CategoryService().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Category category = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(241, 231, 245, 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(category.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(category.state),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: Colors.blue), // Icono de editar en celeste
                          onPressed: () => _showEditCategoryDialog(category),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: Colors.red), // Icono de eliminar en rojo
                          onPressed: () => _confirmDelete(category),
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
        onPressed: () => _showAddCategoryDialog(),
        tooltip: 'Agregar Categoría',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nueva Categoría'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Nombre",
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
                CategoryService()
                    .addCategory(
                  name: nameController.text,
                )
                    .then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureCategories = CategoryService().fetchCategories();
                  });
                }).catchError((error) {
                  print('Error : $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(Category category) {
    TextEditingController nameController =
        TextEditingController(text: category.name);
    String currentState = category.state;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Categoría'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Activo',
                        groupValue: currentState,
                        onChanged: (value) {
                          setState(() {
                            currentState = value!;
                          });
                        },
                      ),
                      Text('Activo'),
                      Radio<String>(
                        value: 'Inactivo',
                        groupValue: currentState,
                        onChanged: (value) {
                          setState(() {
                            currentState = value!;
                          });
                        },
                      ),
                      Text('Inactivo'),
                    ],
                  ),
                ],
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
                    CategoryService()
                        .editCategory(
                      categoryId: category.id,
                      name: nameController.text,
                      state: currentState,
                    )
                        .then((_) {
                      setState(() {
                        futureCategories = CategoryService().fetchCategories();
                      });
                      Navigator.of(context).pop();

                      _refreshCategories();
                    }).catchError((error) {
                      print('Error: $error');
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de eliminar esta categoría?'),
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
                CategoryService().deleteCategory(category.id).then((_) {
                  Navigator.of(context).pop(); // Corrected line
                  setState(() {
                    futureCategories = CategoryService().fetchCategories();
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

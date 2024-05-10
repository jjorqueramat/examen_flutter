import 'package:flutter/material.dart';
import 'package:exa_final_flutter/providers/supplier.dart';
import 'package:exa_final_flutter/services/supplier_service.dart';

class SuppliersPage extends StatefulWidget {
  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  late Future<List<Supplier>> futureSuppliers;

  @override
  void initState() {
    super.initState();
    refreshSuppliers();
  }

  void refreshSuppliers() {
    setState(() {
      futureSuppliers = SupplierService().fetchSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedores'),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: futureSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Supplier supplier = snapshot.data![index];
                return Card(
                  elevation: 4.0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(supplier.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(supplier.lastName),
                        Text(supplier.email),
                        Text('Estado: ${supplier.state}')
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditSupplierDialog(supplier),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(supplier),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('sin disponibles.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSupplierDialog(),
        tooltip: 'Agregar Proveedor',
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddSupplierDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    String currentState = "Activo";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Nuevo Proveedor'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: "Nombre")),
                    TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(hintText: "Apellido")),
                    TextField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: "Email")),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RadioListTile<String>(
                          title: const Text('Activo'),
                          value: 'Activo',
                          groupValue: currentState,
                          onChanged: (String? newValue) {
                            setState(() {
                              currentState = newValue!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Inactivo'),
                          value: 'Inactivo',
                          groupValue: currentState,
                          onChanged: (String? newValue) {
                            setState(() {
                              currentState = newValue!;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    SupplierService()
                        .addSupplier(
                      name: nameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      state: currentState,
                    )
                        .then((_) {
                      Navigator.of(context).pop();
                      refreshSuppliers();
                    }).catchError((error) {
                      print('Error al agregar proveedor: $error');
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

  void _showEditSupplierDialog(Supplier supplier) {
    TextEditingController nameController =
        TextEditingController(text: supplier.name);
    TextEditingController lastNameController =
        TextEditingController(text: supplier.lastName);
    TextEditingController emailController =
        TextEditingController(text: supplier.email);
    String currentState = supplier.state;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Proveedor'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: "Nombre")),
                    TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(hintText: "Apellido")),
                    TextField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: "Email")),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RadioListTile<String>(
                          title: const Text('Activo'),
                          value: 'Activo',
                          groupValue: currentState,
                          onChanged: (String? newValue) {
                            setState(() {
                              currentState = newValue!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Inactivo'),
                          value: 'Inactivo',
                          groupValue: currentState,
                          onChanged: (String? newValue) {
                            setState(() {
                              currentState = newValue!;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Guardar Cambios'),
                  onPressed: () {
                    SupplierService()
                        .editSupplier(
                      supplierId: supplier.id,
                      name: nameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      state: currentState,
                    )
                        .then((_) {
                      Navigator.of(context).pop();
                      refreshSuppliers();
                    }).catchError((error) {
                      print('Error : $error');
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

  void _confirmDelete(Supplier supplier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro en eliminar este proveedor?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                SupplierService().deleteSupplier(supplier.id).then((_) {
                  Navigator.of(context).pop();
                  refreshSuppliers();
                }).catchError((error) {
                  print('Error al eliminar proveedor: $error');
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

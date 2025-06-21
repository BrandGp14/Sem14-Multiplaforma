import 'package:flutter/material.dart';
import 'package:laboratorio_crud/product_database.dart';
import 'package:laboratorio_crud/product_details_view.dart';
import 'package:laboratorio_crud/product_model.dart';
import 'package:intl/intl.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late ProductDatabase productDatabase;
  List<ProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    productDatabase = ProductDatabase.instance;
    refreshProducts();
  }

  Future<void> refreshProducts() async {
    setState(() => isLoading = true);
    final data = await productDatabase.readAll();
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  void goToProductDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsView(productId: id)),
    );
    refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario Local'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshProducts,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('No hay productos. Añade uno nuevo.'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        onTap: () => goToProductDetailsView(id: product.id),
                        title: Text(product.description, style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Text('Precio: S/. ${product.price.toStringAsFixed(2)} - Registrado: ${DateFormat.yMMMd().format(product.createdTime)}'),
                        trailing: Text(
                          product.isAvailable ? 'Disponible' : 'Agotado',
                          style: TextStyle(color: product.isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToProductDetailsView(),
        child: const Icon(Icons.add),
        tooltip: 'Crear Producto',
      ),
    );
  }
}
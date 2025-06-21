import 'package:flutter/material.dart';
import 'package:laboratorio_crud/product_database.dart';
import 'package:laboratorio_crud/product_model.dart';

class ProductDetailsView extends StatefulWidget {
  final int? productId;
  const ProductDetailsView({super.key, this.productId});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final ProductDatabase productDatabase = ProductDatabase.instance;

  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late bool isAvailable;
  ProductModel? product; // Hacemos que el producto pueda ser nulo

  bool isLoading = false;
  bool isNewProduct = true;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    isAvailable = true;

    if (widget.productId != null) {
      isNewProduct = false;
      loadProductData();
    }
  }

  Future<void> loadProductData() async {
    setState(() => isLoading = true);
    product = await productDatabase.read(widget.productId!);
    descriptionController.text = product!.description;
    priceController.text = product!.price.toString();
    isAvailable = product!.isAvailable;
    setState(() => isLoading = false);
  }

  Future<void> saveProduct() async {
    if (descriptionController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() => isLoading = true);

    final productToSave = ProductModel(
      id: isNewProduct ? null : product!.id,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      isAvailable: isAvailable,
      createdTime: isNewProduct ? DateTime.now() : product!.createdTime,
    );

    if (isNewProduct) {
      await productDatabase.create(productToSave);
    } else {
      await productDatabase.update(productToSave);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> deleteProduct() async {
    if (!isNewProduct) {
      await productDatabase.delete(product!.id!);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewProduct ? 'Nuevo Producto' : 'Editar Producto'),
        actions: [
          if (!isNewProduct)
            IconButton(onPressed: deleteProduct, icon: const Icon(Icons.delete)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Precio', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Disponible'),
                    value: isAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        isAvailable = value;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade400)),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar Producto'),
                    onPressed: saveProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pantry_pal/features/pantry/api_service.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/shared/loader.dart';
import 'package:provider/provider.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final nameController = TextEditingController();
  ProductInformationResponse? _productInfo;
  final _formKey = GlobalKey<FormState>();

  Future<String> scanBarcode() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
        "#${Theme.of(context).primaryColor.value.toRadixString(16)}",
        "Cancel",
        false,
        ScanMode.BARCODE);

    return result;
  }

  Future fetchProductInformation(String barcode) async {
    try {
      final info = await PantryService.getProductInformation(barcode);

      setState(() {
        nameController.text = info.product.productName;
        _productInfo = info;
      });
    } catch (error) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Product not found"),
          content: const SingleChildScrollView(
            child: Text(
              "Product information not found for this item. Please enter manually.",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        ),
      );
    }
  }

  void createItemClick() async {
    if (_formKey.currentState!.validate()) {
      Loader(context).startLoading();
      await PantryService.createPantryItem(
          CreatePantryItem(name: nameController.text));

      if (mounted) {
        Loader(context).stopLoading();
        Provider.of<PantryStore>(context, listen: false).refreshPantryItems();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () async {
                    Loader(context).startLoading();

                    // final barcode = await scanBarcode();
                    final barcode = "9400547001811";

                    if (barcode != "-1") {
                      await fetchProductInformation(barcode);
                    }

                    if (mounted) {
                      Loader(context).stopLoading();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  child: const Text("Scan Item"),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                ElevatedButton(
                  onPressed: () {
                    createItemClick();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("Add Item"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

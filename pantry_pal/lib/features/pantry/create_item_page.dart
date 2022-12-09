import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pantry_pal/features/pantry/api_service.dart';
import 'package:pantry_pal/shared/loader.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _productNameController = TextEditingController();
  ProductInformationResponse? _productInfo;

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
      final info = await ApiService.getProductInformation(barcode);

      setState(() {
        _productNameController.text = info.product.productName;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
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
              TextField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Add Item"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

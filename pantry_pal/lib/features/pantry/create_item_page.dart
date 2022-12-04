import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pantry_pal/features/pantry/api_service.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final productNameController = TextEditingController();

  Future<String> scanBarcode() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
        "#${Theme.of(context).primaryColor.value.toRadixString(16)}",
        "Cancel",
        false,
        ScanMode.BARCODE);

    return result;
  }

  void fetchProductInformation(String barcode) async {
    try {
      final productInfo = await ApiService.getProductInformation(barcode);

      setState(() {
        productNameController.text = productInfo.productName;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => const Dialog(
          child: Text(
            "Product information not found for this item. Please enter manually.",
          ),
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
                  // final barcode = await scanBarcode();
                  final barcode = "5000157024671";

                  fetchProductInformation(barcode);
                },
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                child: const Text("Scan Item"),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: productNameController,
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
                  minimumSize: const Size.fromHeight(46),
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateItemPage extends StatefulWidget {
  final PantryItem? item;

  const CreateItemPage({super.key, this.item});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _nameController = TextEditingController();
  final _formatter = DateFormat("dd/MM/yyyy");
  final _expiryDateController = TextEditingController();
  var _barcode = "";
  final _formKey = GlobalKey<FormState>();
  var _updateLocalItem = false;
  var _isLoadingItem = false;

  late DateTime _expiryDate;

  @override
  initState() {
    super.initState();

    final plusSevenDays = DateTime.now().add(const Duration(days: 7));

    if (widget.item != null) {
      _expiryDateController.text = _formatDate(widget.item!.expiryDate);
      _expiryDate = widget.item!.expiryDate;
      _nameController.text = widget.item!.name;
      _barcode = widget.item!.barcode;
    } else {
      _expiryDateController.text = _formatDate(plusSevenDays);
      _expiryDate = plusSevenDays;
    }
  }

  Future<String> _scanBarcode() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      "#${Theme.of(context).primaryColor.value.toRadixString(16)}",
      "Cancel",
      false,
      ScanMode.BARCODE,
    );

    return result;
  }

  Future _fetchProductInformation(String barcode) async {
    try {
      setState(() {
        _isLoadingItem = true;
      });
      final info = await ApiHttp().getProductInformation(barcode);

      setState(() {
        _nameController.text = info.name;
        _barcode = barcode;
      });
    } catch (error) {
      log(error.toString());

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
                child: const Text("OK")),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoadingItem = false;
      });
    }
  }

  void _createItemClick() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.item == null) {
          await ApiHttp().createPantryItem(UpdatePantryItem(
            id: 0,
            name: _nameController.text,
            expiryDate: _expiryDate,
            updateLocalItem: _updateLocalItem,
            barcode: _barcode,
          ));
        } else {
          final item = widget.item!;
          await ApiHttp().updatePantryItem(
            UpdatePantryItem(
              id: item.id,
              name: _nameController.text,
              expiryDate: _expiryDate,
              barcode: _barcode,
              updateLocalItem: _updateLocalItem,
            ),
          );
        }

        if (mounted) {
          Provider.of<PantryStore>(context, listen: false).refreshPantryItems();
          Navigator.of(context).pop();
        }
      } catch (error) {
        log(error.toString());
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const SingleChildScrollView(
              child: Text(
                "An error occurred while creating the item. Please try again.",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK")),
            ],
          ),
        );
      }
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final dateDiff = dateTime.difference(startOfToday).inDays;
    final dayLabel = dateDiff == 1 ? "day" : "days";

    return "${_formatter.format(dateTime)} (in $dateDiff $dayLabel)";
  }

  void _expiryDateClick() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 5),
      ),
    );

    if (result != null) {
      setState(() {
        _expiryDateController.text = _formatDate(result);
        _expiryDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? "Add Item" : "Edit Item"),
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
                    final barcode = await _scanBarcode();
                    // final barcode = "3017620422003";

                    if (barcode != "-1") {
                      await _fetchProductInformation(barcode);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoadingItem)
                        const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                      else
                        const Icon(
                          Icons.photo_camera,
                          size: 20,
                        ),
                      const SizedBox(width: 6),
                      const Text("Scan Item"),
                    ],
                  ),
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextFormField(
                    readOnly: true,
                    controller: _expiryDateController,
                    onTap: _expiryDateClick,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Expiry Date",
                    ),
                  ),
                ),
                _barcode.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SwitchListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    value: _updateLocalItem,
                    onChanged: (newValue) {
                      setState(() {
                        _updateLocalItem = newValue;
                      });
                    },
                    title: const Text("Update barcode information"),
                    subtitle: const Text(
                        "Attach the updated details to this barcode for next time (this affects all items with this barcode)"),
                  ),
                ) : const SizedBox.shrink(),
                const Spacer(
                  flex: 1,
                ),
                FilledButton(
                  onPressed: () {
                    _createItemClick();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(widget.item == null ? "Add" : "Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

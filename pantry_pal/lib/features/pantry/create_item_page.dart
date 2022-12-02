import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
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
              ElevatedButton(
                onPressed: () {},
                child: const Text("Scan Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

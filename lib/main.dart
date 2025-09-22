// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();

  double? normalGst;
  double? exclusiveGst;
  double? inclusiveGst;
  double? inclusiveBase;

  void calculateNormalGst() {
    double? num = double.tryParse(numberController.text);
    double? per = double.tryParse(percentageController.text);

    if (num == null || per == null) {
      showSnackBar('Please enter both correct values');
      return;
    }

    double result = num * per / 100;
    setState(() {
      normalGst = result;
      exclusiveGst = null;
      inclusiveGst = null;
      inclusiveBase = null;
    });
  }

  void calculateExclusiveGst() {
    double? num = double.tryParse(numberController.text);
    double? per = double.tryParse(percentageController.text);

    if (num == null || per == null) {
      showSnackBar('Please enter both correct values');
      return;
    }

    double gstAmount = num * per / 100;
    double totalAmount = num + gstAmount;

    setState(() {
      exclusiveGst = totalAmount;
      normalGst = null;
      inclusiveGst = null;
      inclusiveBase = null;
    });
  }

  void calculateInclusiveGst() {
    double? num = double.tryParse(numberController.text);
    double? per = double.tryParse(percentageController.text);

    if (num == null || per == null) {
      showSnackBar('Please enter both correct values');
      return;
    }

    double baseAmount = num / (1 + per / 100);
    double gstAmount = num - baseAmount;

    setState(() {
      inclusiveGst = gstAmount;
      inclusiveBase = baseAmount;
      normalGst = null;
      exclusiveGst = null;
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.grey.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GST Calculator"),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Enter the Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: percentageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'GST %',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: calculateNormalGst,
                  child: const Text('Normal GST'),
                ),
                ElevatedButton(
                  onPressed: calculateExclusiveGst,
                  child: const Text('Exclusive GST'),
                ),
                ElevatedButton(
                  onPressed: calculateInclusiveGst,
                  child: const Text('Inclusive GST'),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Display Results
            if (normalGst != null)
              Text(
                'GST Amount: ${normalGst!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (exclusiveGst != null)
              Text(
                'Total Amount (Exclusive GST): ${exclusiveGst!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (inclusiveGst != null && inclusiveBase != null)
              Column(
                children: [
                  Text(
                    'Base Amount (Without GST): ${inclusiveBase!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'GST Amount: ${inclusiveGst!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

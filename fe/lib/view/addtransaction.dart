import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int? _selectedCategoryId;
  String? _selectedType;
  bool _isLoading = false;

  final List<Map<String, dynamic>> allCategories = [
    {"id": 1, "name": "Food & Beverage", "type": "Expense"},
    {"id": 2, "name": "Transportation", "type": "Expense"},
    {"id": 3, "name": "Entertainment", "type": "Expense"},
    {"id": 4, "name": "Bills & Utilities", "type": "Expense"},
    {"id": 5, "name": "Shopping", "type": "Expense"},
    {"id": 6, "name": "Health", "type": "Expense"},
    {"id": 7, "name": "Education", "type": "Expense"},
    {"id": 8, "name": "Others (Expense)", "type": "Expense"},
    {"id": 9, "name": "Salary", "type": "Income"},
    {"id": 10, "name": "Bonus", "type": "Income"},
    {"id": 11, "name": "Investment", "type": "Income"},
    {"id": 12, "name": "Gift", "type": "Income"},
    {"id": 13, "name": "Others (Income)", "type": "Income"},
  ];

  List<Map<String, dynamic>> get filteredCategories {
    if (_selectedType == null) return [];
    return allCategories.where((cat) => cat["type"] == _selectedType).toList();
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final res = await http.post(
        Uri.parse("http://10.0.2.2:3000/insert-transaction"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "date": DateFormat('yyyy-MM-dd').format(_selectedDate),
          "categoryid": _selectedCategoryId,
          "amount": double.tryParse(_amountController.text) ?? 0,
          "note": _noteController.text,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  void _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Add Transaction",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.7),
          child: Divider(height: 0.5, thickness: 0.1, color: Colors.grey),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// DATE PICKER
                      const Text("Date",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDate),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _pickDate,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: const Text("Choose Date",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// TYPE DROPDOWN
                      const Text("Type",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Select Type"),
                        value: _selectedType,
                        validator: (value) =>
                            value == null ? "Please select type" : null,
                        items: const [
                          DropdownMenuItem(
                              value: "Expense", child: Text("Expense")),
                          DropdownMenuItem(
                              value: "Income", child: Text("Income")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                            _selectedCategoryId = null;
                          });
                        },
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      /// CATEGORY DROPDOWN
                      const Text("Category",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<int>(
                        decoration: _inputDecoration("Select Category"),
                        value: _selectedCategoryId,
                        validator: (value) =>
                            value == null ? "Please select category" : null,
                        items: filteredCategories.map((cat) {
                          return DropdownMenuItem<int>(
                            value: cat["id"],
                            child: Text(cat["name"]),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategoryId = value);
                        },
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      /// AMOUNT
                      const Text("Amount",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _amountController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter amount";
                          }
                          return null;
                        },
                        decoration: _inputDecoration("Enter amount"),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// NOTE
                      const Text("Note (Optional)",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _noteController,
                        decoration: _inputDecoration("Enter note"),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 32),

                      /// BUTTON
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _submitTransaction,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Transaction",
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/history-transaction');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: "New"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

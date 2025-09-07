import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  double amount = 0;
  double remaining = 0;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadBudget();
    _loadTransactions();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? "User";
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/logout"),
        headers: {"Authorization": "Bearer $token"},
      );

      if(response.statusCode == 200){
         ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Logout Successful")));
      }
      else{
        print("Logout gagal: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception logout: $e");
    }
    
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/get-budget"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          amount =
              double.tryParse(data["result"][0]["amount"].toString()) ?? 0.0;
          remaining =
              double.tryParse(data["result"][0]["remaining"].toString()) ?? 0.0;
        });
      } else if (response.statusCode == 404) {
        print("Budget not found for this month.");
      } else {
        print("Error load budget: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception load budget: $e");
    }
  }

  Future<void> _saveBudget(double newBudget) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.patch(
        Uri.parse("http://10.0.2.2:3000/update-budget"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"amount": newBudget}),
      );

      if (response.statusCode == 200) {
        print("Budget updated!");
        await _loadBudget();
      } else {
        print("Error save budget: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final month = DateFormat("yyyy-MM").format(DateTime.now());

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/view-month-tr"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"month": month}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          transactions = List<Map<String, dynamic>>.from(
            data["result"].map((tr) {
              return {
                "date": tr["date"],
                "category": tr["category"],
                "type": tr["type"],
                "note": tr["note"],
                "amount": double.tryParse(tr["amount"].toString()) ?? 0.0,
                "remaining_after":
                    double.tryParse(tr["remaining_after"].toString()) ?? 0.0,
              };
            }),
          );
        });
      } else if (response.statusCode == 404) {
        setState(() {
          transactions = [];
        });
        print("No transactions found.");
      } else {
        print("Error load transactions: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception load transactions: $e");
    }
  }

  void _editBudget() {
    final controller = TextEditingController(text: amount.toStringAsFixed(0));
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Budget"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Enter new budget"),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newBudget = double.tryParse(controller.text) ?? amount;
                  _saveBudget(newBudget);
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  Future<void> _refreshPage() async {
    await _loadBudget();
    await _loadTransactions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'id_ID');
    String currentMonth = DateFormat("MMMM yyyy").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("J E N C E ", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.3),
          child: Divider(height: 0.1, thickness: 0.1, color: Colors.grey),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $username!",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp ${formatter.format(remaining)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Budget: Rp. ${formatter.format(amount)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _editBudget,
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currentMonth,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                "This Month Transaction",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    transactions.isEmpty
                        ? const Center(
                          child: Text(
                            "No Transaction for This Month!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final t = transactions[index];
                            return Card(
                              color: Colors.white.withOpacity(0.8),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Icon(
                                  t['type'] == 'income'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color:
                                      t['type'] == 'income'
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                title: Text("${t['category']} - ${t['type']}"),
                                subtitle: Text(
                                  "${t['date']} • ${t['note']} \nRemaining: Rp. ${formatter.format(t['remaining_after'])}",
                                ),
                                trailing: Text(
                                  "Rp. ${formatter.format(t['amount'])}",
                                  style: TextStyle(
                                    color:
                                        t['type'] == 'income'
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 3) {
            Navigator.pushNamed(context, '/profile').then((_) {
              _loadUser();
            });
          } else if (index == 1) {
            Navigator.pushNamed(context, '/new-transaction');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/history-transaction');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "New"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

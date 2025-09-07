import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> transactions = [];
  double totalExpense = 0;
  double totalIncome = 0;
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = false;
  bool _isChartLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadChartData();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final month = DateFormat("yyyy-MM").format(_selectedMonth);

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
      }
    } catch (e) {
      print("Exception load transactions: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadChartData() async {
    setState(() => _isChartLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final month = DateFormat("yyyy-MM").format(_selectedMonth);

    try {
      final response = await http.post(
        Uri.parse("https://316342f5e1be.ngrok-free.app/pie-chart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"month": month}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalExpense =
              double.tryParse(data["result"][0]["total_expense"].toString()) ??
                  0.0;
          totalIncome =
              double.tryParse(data["result"][0]["total_income"].toString()) ??
                  0.0;
        });
      } else {
        setState(() {
          totalExpense = 0.0;
          totalIncome = 0.0;
        });
      }
    } catch (e) {
      print("Exception load chart: $e");
    }

    setState(() => _isChartLoading = false);
  }

  Future<void> _pickMonth() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
      await _loadTransactions();
      await _loadChartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'id_ID');
    String selectedMonthLabel = DateFormat("MMMM yyyy").format(_selectedMonth);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text("Transaction History", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.7),
          child: Divider(
            height: 0.5,
            thickness: 0.1,
            color: Colors.grey,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadTransactions();
          await _loadChartData();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedMonthLabel,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickMonth,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Choose Month",
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isChartLoading)
                const Center(child: CircularProgressIndicator())
              else if (totalExpense > 0 || totalIncome > 0)
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: totalExpense,
                              title: "Expense",
                              color: Colors.red,
                              radius: 60,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: totalIncome,
                              title: "Income",
                              color: Colors.green,
                              radius: 60,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Total Expense: Rp ${formatter.format(totalExpense)}",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total Income: Rp ${formatter.format(totalIncome)}",
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : transactions.isEmpty
                        ? const Center(
                            child: Text(
                              "No Transaction for this month!",
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Icon(
                                    t['type'] == 'income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: t['type'] == 'income'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title:
                                      Text("${t['category']} - ${t['type']}"),
                                  subtitle: Text(
                                    "${t['date']} • ${t['note']}\nRemaining: Rp. ${formatter.format(t['remaining_after'])}",
                                  ),
                                  trailing: Text(
                                    "Rp. ${formatter.format(t['amount'])}",
                                    style: TextStyle(
                                      color: t['type'] == 'income'
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
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/new-transaction');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
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

import 'package:flutter/material.dart';
import 'database.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  double totalIncome = 0;
  double totalExpense = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.getTransactions();

    double income = 0;
    double expense = 0;

    for (var item in data) {
      final type = item['type'] as String?;
      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;

      if (type == 'Thu nhập') {
        income += amount;
      } else if (type == 'Chi tiêu') {
        expense += amount;
      }
    }

    if (mounted) {
      setState(() {
        totalIncome = income;
        totalExpense = expense;
        isLoading = false;
      });
    }
  }

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllRegExp(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), r'\1.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Thống kê', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: loadStatistics,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.south_west, color: Colors.green),
                        const SizedBox(height: 8),
                        const Text('Tổng thu nhập', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          formatMoney(totalIncome),
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.north_east, color: Colors.red),
                        const SizedBox(height: 8),
                        const Text('Tổng chi tiêu', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          formatMoney(totalExpense),
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Text('Số dư hiện tại', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    formatMoney(totalIncome - totalExpense),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringFormat on String {
  String replaceAllRegExp(RegExp source, String replacement) {
    return replaceAllMapped(source, (match) => replacement.replaceAll(r'\1', match.group(1)!));
  }
}
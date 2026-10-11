
import 'package:flutter/material.dart';
import 'database.dart';
import 'edit_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String searchText = '';
  String selectedType = 'Tất cả';

  static const Color primaryColor = Color(0xFF2674D9);

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final data = await DatabaseHelper.instance.getTransactions();

      if (!mounted) return;

      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải giao dịch: $e')),
      );
    }
  }

  String formatMoney(num amount) {
    final text = amount.toStringAsFixed(0);
    final result = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      result.write(text[i]);

      final remaining = text.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        result.write('.');
      }
    }

    return '${result.toString()} đ';
  }

  List<Map<String, dynamic>> get filteredTransactions {
    return transactions.where((item) {
      final category = (item['category'] ?? '').toString();
      final note = (item['note'] ?? '').toString();
      final type = (item['type'] ?? '').toString();

      final matchesSearch =
          category.toLowerCase().contains(searchText.toLowerCase()) ||
              note.toLowerCase().contains(searchText.toLowerCase());

      final matchesType =
          selectedType == 'Tất cả' || type == selectedType;

      return matchesSearch && matchesType;
    }).toList();
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Mua sắm':
        return Icons.shopping_bag;
      default:
        return Icons.receipt_long;
    }
  }

  Future<void> _editTransaction(
      Map<String, dynamic> transaction,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(
          transaction: transaction,
        ),
      ),
    );

    if (!mounted) return;
    await _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF17243A),
        elevation: 0,
        title: const Text(
          'Giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _loadTransactions,
            icon: const Icon(Icons.refresh, color: primaryColor),
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm theo danh mục hoặc ghi chú',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip('Tất cả'),
                _filterChip('Thu nhập'),
                _filterChip('Chi tiêu'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : data.isEmpty
                ? const Center(
              child: Text(
                'Không có giao dịch phù hợp',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadTransactions,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = data[index];
                  final isIncome =
                      item['type'] == 'Thu nhập';
                  final amount =
                  (item['amount'] as num).toDouble();
                  final category =
                  (item['category'] ?? 'Khác').toString();
                  final note =
                  (item['note'] ?? '').toString();
                  final date =
                  (item['date'] ?? '').toString();
                  final color = isIncome
                      ? const Color(0xFF36A852)
                      : const Color(0xFFFF6268);

                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: ListTile(
                      onTap: () => _editTransaction(item),
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                        color.withAlpha(25),
                        child: Icon(
                          _categoryIcon(category),
                          color: color,
                        ),
                      ),
                      title: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        note.isEmpty ? date : '$note • $date',
                      ),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}${formatMoney(amount)}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String type) {
    final selected = selectedType == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(type),
        selected: selected,
        selectedColor: const Color(0xFF2674D9),
        labelStyle: TextStyle(
          color: selected ? Colors.white : const Color(0xFF526174),
        ),
        onSelected: (_) {
          setState(() {
            selectedType = type;
          });
        },
      ),
    );
  }
}

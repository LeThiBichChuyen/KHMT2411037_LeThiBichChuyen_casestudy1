
import 'package:flutter/material.dart';
import 'database.dart';
import 'add_transaction_screen.dart';
import 'edit_transaction_screen.dart';
import 'statistics_screen.dart';
import 'transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  int _currentIndex = 0;

  static const Color primaryColor = Color(0xFF2674D9);
  static const Color backgroundColor = Color(0xFFF6F8FC);

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

      // Kiểm tra dữ liệu lấy từ SQLite.
      debugPrint('Số giao dịch: ${data.length}');
      debugPrint(
        'KIỂM TRA LOẠI GIAO DỊCH: '
            '${data.map((item) => item['type']).toList()}',
      );
      debugPrint('Tổng thu nhập: $totalIncome');
      debugPrint('Tổng chi tiêu: $totalExpense');
      debugPrint('Số dư: $balance');
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

  // Chuẩn hóa loại giao dịch để tránh sai khác do viết hoa,
  // khoảng trắng hoặc cách ghi tiếng Anh.
  String _normalizeType(dynamic value) {
    return value
        ?.toString()
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('_', '')
        .replaceAll('-', '') ??
        '';
  }

  bool _isIncome(Map<String, dynamic> item) {
    final type = _normalizeType(item['type']);

    return type == 'thunhập' ||
        type == 'thunhap' ||
        type == 'income' ||
        type == 'thu';
  }

  bool _isExpense(Map<String, dynamic> item) {
    final type = _normalizeType(item['type']);

    return type == 'chitiêu' ||
        type == 'chitieu' ||
        type == 'expense' ||
        type == 'chi';
  }

  double _amountOf(Map<String, dynamic> item) {
    final value = item['amount'];

    if (value is num) {
      return value.toDouble();
    }

    final text = value?.toString().trim() ?? '';

    if (text.isEmpty) return 0;

    // Hỗ trợ dữ liệu số dạng chuỗi như 80000 hoặc 80.000.
    final cleaned = text.replaceAll(RegExp(r'[^\d\-]'), '');

    return double.tryParse(cleaned) ?? 0;
  }

  double get totalIncome {
    return transactions
        .where(_isIncome)
        .fold<double>(0, (sum, item) => sum + _amountOf(item));
  }

  double get totalExpense {
    return transactions
        .where(_isExpense)
        .fold<double>(0, (sum, item) => sum + _amountOf(item));
  }

  double get balance => totalIncome - totalExpense;

  String formatMoney(num amount) {
    final value = amount.round().toString();
    final isNegative = value.startsWith('-');
    final digits = isNegative ? value.substring(1) : value;
    final result = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      result.write(digits[i]);

      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        result.write('.');
      }
    }

    return '${isNegative ? '-' : ''}${result.toString()} đ';
  }

  Future<void> _openAddTransaction() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (!mounted) return;

    await _loadTransactions();
  }

  Future<void> _openEditTransaction(
      Map<String, dynamic> transaction,
      ) async {
    await Navigator.push<bool>(
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

  Widget _summaryCard({
    required String title,
    required double amount,
    required bool income,
  }) {
    final color = income
        ? const Color(0xFF36A852)
        : const Color(0xFFFF6268);

    return Expanded(
      child: Container(
        height: 76,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: income
              ? const Color(0xFFE9F7EC)
              : const Color(0xFFFFEEF0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                income ? Icons.arrow_downward : Icons.arrow_upward,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.toUpperCase(),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF526174),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatMoney(amount),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionItem(Map<String, dynamic> item) {
    final isIncome = _isIncome(item);
    final amount = _amountOf(item);
    final category = item['category']?.toString() ?? 'Khác';
    final note = item['note']?.toString() ?? '';
    final date = item['date']?.toString() ?? '';

    final color = isIncome
        ? const Color(0xFF36A852)
        : const Color(0xFFFF6268);

    return InkWell(
      onTap: () => _openEditTransaction(item),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _categoryIcon(category),
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17243A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.isEmpty ? date : '$note • $date',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8491A5),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isIncome ? 'Thu nhập' : 'Chi tiêu',
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${isIncome ? '+' : '-'}${formatMoney(amount)}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    final recentTransactions = transactions.take(5).toList();

    return RefreshIndicator(
      onRefresh: _loadTransactions,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8491A5),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Expense Manager',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF17243A),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _loadTransactions,
                icon: const Icon(
                  Icons.refresh,
                  color: primaryColor,
                ),
                tooltip: 'Làm mới giao dịch',
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4785F5),
                  Color(0xFF1760EB),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SỐ DƯ HIỆN TẠI',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  formatMoney(balance),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _summaryCard(
                title: 'Tổng thu nhập',
                amount: totalIncome,
                income: true,
              ),
              const SizedBox(width: 8),
              _summaryCard(
                title: 'Tổng chi tiêu',
                amount: totalExpense,
                income: false,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17243A),
                ),
              ),
              Text(
                '${transactions.length} giao dịch',
                style: const TextStyle(
                  fontSize: 11,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (isLoading)
            const SizedBox(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (recentTransactions.isEmpty)
            Container(
              height: 125,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 34,
                    color: Color(0xFF9AA6B8),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chưa có giao dịch nào',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8491A5),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Nhấn nút + để thêm giao dịch',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8491A5),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  for (int i = 0;
                  i < recentTransactions.length;
                  i++) ...[
                    _transactionItem(recentTransactions[i]),
                    if (i < recentTransactions.length - 1)
                      const Divider(
                        height: 1,
                        indent: 66,
                        endIndent: 12,
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedPage() {
    switch (_currentIndex) {
      case 1:
        return TransactionListScreen();
      case 2:
        return StatisticsScreen();
      default:
        return _buildHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: _buildSelectedPage(),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: _openAddTransaction,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF8491A5),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}

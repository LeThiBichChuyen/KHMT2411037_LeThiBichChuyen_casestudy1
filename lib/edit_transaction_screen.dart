
import 'package:flutter/material.dart';
import 'database.dart';

class EditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  bool isExpense = true;
  bool isSaving = false;

  String selectedCategory = 'Ăn uống';
  DateTime selectedDate = DateTime.now();

  final TextEditingController amountController =
  TextEditingController();

  final TextEditingController noteController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = widget.transaction;

    isExpense = data['type'] == 'Chi tiêu';

    selectedCategory = data['category'] ?? 'Ăn uống';

    amountController.text =
        (data['amount'] ?? '').toString();

    noteController.text = data['note'] ?? '';

    final dateText = data['date']?.toString() ?? '';

    try {
      final parts = dateText.split('/');
      if (parts.length == 3) {
        selectedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {
      selectedDate = DateTime.now();
    }

    if (![
      'Ăn uống',
      'Di chuyển',
      'Mua sắm',
    ].contains(selectedCategory)) {
      selectedCategory = 'Ăn uống';
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> updateTransaction() async {
    final amount = double.tryParse(
      amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ'),
        ),
      );
      return;
    }

    final id = widget.transaction['id'];

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy mã giao dịch'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await DatabaseHelper.instance.updateTransaction(
        id as int,
        {
          'type': isExpense ? 'Chi tiêu' : 'Thu nhập',
          'category': selectedCategory,
          'amount': amount,
          'date': formatDate(selectedDate),
          'note': noteController.text.trim(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật giao dịch thành công'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi cập nhật giao dịch: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF17243A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chỉnh sửa giao dịch',
          style: TextStyle(
            color: Color(0xFF17243A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isExpense = true);
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: isExpense
                            ? const Color(0xFFFF6268)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isExpense
                              ? const Color(0xFFFF6268)
                              : const Color(0xFFE1E5EB),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Chi tiêu',
                          style: TextStyle(
                            color: isExpense
                                ? Colors.white
                                : const Color(0xFF17243A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isExpense = false);
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: !isExpense
                            ? const Color(0xFF4CAF50)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: !isExpense
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE1E5EB),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Thu nhập',
                          style: TextStyle(
                            color: !isExpense
                                ? Colors.white
                                : const Color(0xFF17243A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Danh mục',
              style: TextStyle(
                color: Color(0xFF17243A),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE1E5EB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'Ăn uống',
                      child: Row(
                        children: [
                          Icon(Icons.restaurant,
                              color: Color(0xFFFF6268)),
                          SizedBox(width: 10),
                          Text('Ăn uống'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Di chuyển',
                      child: Row(
                        children: [
                          Icon(Icons.directions_car,
                              color: Color(0xFFFF6268)),
                          SizedBox(width: 10),
                          Text('Di chuyển'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Mua sắm',
                      child: Row(
                        children: [
                          Icon(Icons.shopping_bag,
                              color: Color(0xFFFF6268)),
                          SizedBox(width: 10),
                          Text('Mua sắm'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Số tiền',
              style: TextStyle(
                color: Color(0xFF17243A),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập số tiền',
                suffixText: 'đ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE1E5EB),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF2674D9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ngày giao dịch',
              style: TextStyle(
                color: Color(0xFF17243A),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: selectDate,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE1E5EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDate(selectedDate),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF17243A),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month,
                      color: Color(0xFF526174),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ghi chú',
              style: TextStyle(
                color: Color(0xFF17243A),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú (tùy chọn)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE1E5EB),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2674D9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Cập nhật',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

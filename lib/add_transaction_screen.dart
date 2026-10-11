import 'package:flutter/material.dart';
import 'database.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;
  bool isSaving = false;

  String selectedCategory = 'Ăn uống';
  DateTime selectedDate = DateTime.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  static const Color primaryColor = Color(0xFF2674D9);
  static const Color textColor = Color(0xFF17243A);
  static const Color borderColor = Color(0xFFE1E5EB);

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDateDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatDateForDb(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  double? _parseAmount(String input) {
    final cleaned = input.trim().replaceAll(RegExp(r'[\s.,]'), '');
    if (cleaned.isEmpty || !RegExp(r'^\d+$').hasMatch(cleaned)) {
      return null;
    }
    return double.tryParse(cleaned);
  }

  Future<void> _saveTransaction() async {
    if (isSaving) return;

    final amount = _parseAmount(amountController.text);

    if (amount == null || amount <= 0 || amount > 100000000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ (> 0 và < 100 tỷ).'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final data = <String, dynamic>{
      'type': isExpense ? 'Chi tiêu' : 'Thu nhập',
      'category': selectedCategory,
      'amount': amount,
      'date': formatDateForDb(selectedDate),
      'note': noteController.text.trim(),
    };

    try {
      final id = await DatabaseHelper.instance.insertTransaction(data);

      if (!mounted) return;

      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu giao dịch thành công!')),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được giao dịch.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  InputDecoration _inputDecoration({required String hint, String? suffix}) {
    return InputDecoration(
      hintText: hint,
      suffixText: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
  }

  Widget _buildTypeButton({
    required String title,
    required bool selected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? selectedColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? selectedColor : borderColor),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(
            color: textColor,
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
                _buildTypeButton(
                  title: 'Chi tiêu',
                  selected: isExpense,
                  selectedColor: const Color(0xFFFF6268),
                  onTap: () => setState(() => isExpense = true),
                ),
                const SizedBox(width: 8),
                _buildTypeButton(
                  title: 'Thu nhập',
                  selected: !isExpense,
                  selectedColor: const Color(0xFF4CAF50),
                  onTap: () => setState(() => isExpense = false),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              isExpanded: true,
              decoration: _inputDecoration(hint: 'Chọn danh mục'),
              items: const [
                DropdownMenuItem(value: 'Ăn uống', child: Text('Ăn uống')),
                DropdownMenuItem(value: 'Di chuyển', child: Text('Di chuyển')),
                DropdownMenuItem(value: 'Mua sắm', child: Text('Mua sắm')),
                DropdownMenuItem(value: 'Lương', child: Text('Lương')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedCategory = val);
              },
            ),
            const SizedBox(height: 20),
            const Text('Số tiền', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(hint: 'Ví dụ: 50000', suffix: 'đ'),
            ),
            const SizedBox(height: 20),
            const Text('Ngày giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDisplayDate(selectedDate),
                        style: const TextStyle(fontSize: 15, color: textColor),
                      ),
                    ),
                    const Icon(Icons.calendar_month, color: Color(0xFF526174)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: _inputDecoration(hint: 'Nhập ghi chú (tùy chọn)'),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Lưu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDisplayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
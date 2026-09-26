import 'package:flutter/material.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  bool isExpense = true;

  String selectedCategory = 'Ăn uống';

  DateTime selectedDate = DateTime(2025, 4, 12);

  final TextEditingController amountController =
  TextEditingController(text: '50000');

  final TextEditingController noteController =
  TextEditingController(text: 'Ăn trưa');

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
          onPressed: () {
            Navigator.pop(context);
          },
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
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // CHI TIÊU / THU NHẬP
            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpense = true;
                      });
                    },

                    child: Container(
                      height: 42,

                      decoration: BoxDecoration(
                        color: isExpense
                            ? const Color(0xFFFF6268)
                            : Colors.white,

                        borderRadius:
                        BorderRadius.circular(8),

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
                      setState(() {
                        isExpense = false;
                      });
                    },

                    child: Container(
                      height: 42,

                      decoration: BoxDecoration(
                        color: !isExpense
                            ? const Color(0xFF4CAF50)
                            : Colors.white,

                        borderRadius:
                        BorderRadius.circular(8),

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

            // DANH MỤC
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

              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE1E5EB),
                ),
                borderRadius:
                BorderRadius.circular(10),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,

                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF526174),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 'Ăn uống',
                      child: Row(
                        children: [
                          Icon(
                            Icons.restaurant,
                            color: Color(0xFFFF6268),
                          ),
                          SizedBox(width: 10),
                          Text('Ăn uống'),
                        ],
                      ),
                    ),

                    DropdownMenuItem(
                      value: 'Di chuyển',
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: Color(0xFFFF6268),
                          ),
                          SizedBox(width: 10),
                          Text('Di chuyển'),
                        ],
                      ),
                    ),

                    DropdownMenuItem(
                      value: 'Mua sắm',
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Color(0xFFFF6268),
                          ),
                          SizedBox(width: 10),
                          Text('Mua sắm'),
                        ],
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SỐ TIỀN
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
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                hintText: 'Nhập số tiền',
                suffixText: 'đ',

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),

                  borderSide: const BorderSide(
                    color: Color(0xFFE1E5EB),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),

                  borderSide: const BorderSide(
                    color: Color(0xFF2674D9),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NGÀY
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

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE1E5EB),
                  ),

                  borderRadius:
                  BorderRadius.circular(10),
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

            // GHI CHÚ
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
                  borderRadius:
                  BorderRadius.circular(10),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),

                  borderSide: const BorderSide(
                    color: Color(0xFFE1E5EB),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // NÚT CẬP NHẬT
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Đã cập nhật giao dịch',
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF2674D9),

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                child: const Text(
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
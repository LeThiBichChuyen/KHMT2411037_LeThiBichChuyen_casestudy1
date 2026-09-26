import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      // =========================
      // THANH ĐIỀU HƯỚNG DƯỚI
      // =========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2674D9),
        unselectedItemColor: const Color(0xFF17243A),
        selectedFontSize: 12,
        unselectedFontSize: 12,
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // =========================
              // THANH TRÊN
              // =========================
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  12,
                ),
                child: Row(
                  children: [

                    const Icon(
                      Icons.menu,
                      size: 28,
                      color: Color(0xFF17243A),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Text(
                        'Quản lý thu chi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF17243A),
                        ),
                      ),
                    ),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 30,
                          color: Color(0xFF17243A),
                        ),

                        Positioned(
                          right: -3,
                          top: -5,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4D5A),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =========================
              // THẺ SỐ DƯ
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4B86F7),
                        Color(0xFF1462E8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Stack(
                    children: [

                      const Positioned(
                        left: 0,
                        right: 0,
                        top: 38,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SỐ DƯ HIỆN TẠI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 7),
                                Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            Text(
                              '5.000.000 đ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Icon minh họa ví tiền
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Container(
                          width: 68,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2863D0),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFFFFD54F),
                            size: 42,
                          ),
                        ),
                      ),

                      // Dấu slide
                      const Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(width: 6),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor:
                              Color(0xFF8FB4FF),
                            ),
                            SizedBox(width: 6),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor:
                              Color(0xFF8FB4FF),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // THU NHẬP / CHI TIÊU
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [

                    Expanded(
                      child: _summaryCard(
                        title: 'TỔNG THU NHẬP',
                        amount: '8.000.000 đ',
                        icon: Icons.arrow_downward,
                        iconColor: const Color(0xFF4CAF50),
                        backgroundColor:
                        const Color(0xFFEAF7EC),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _summaryCard(
                        title: 'TỔNG CHI TIÊU',
                        amount: '3.000.000 đ',
                        icon: Icons.arrow_upward,
                        iconColor: const Color(0xFFFF6268),
                        backgroundColor:
                        const Color(0xFFFFEEF0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // GIAO DỊCH GẦN ĐÂY
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [

                    const Expanded(
                      child: Text(
                        'Giao dịch gần đây',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF17243A),
                        ),
                      ),
                    ),

                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2674D9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // =========================
              // DANH SÁCH GIAO DỊCH
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [

                      _transactionItem(
                        icon: Icons.restaurant,
                        iconColor: const Color(0xFFFF7A1A),
                        title: 'Ăn trưa',
                        category: 'Ăn uống',
                        date: '03/09/2024',
                        amount: '-50.000 đ',
                        amountColor:
                        const Color(0xFFFF3F4F),
                      ),

                      _transactionItem(
                        icon: Icons.directions_car,
                        iconColor: const Color(0xFF2685E8),
                        title: 'Xăng xe',
                        category: 'Di chuyển',
                        date: '03/09/2024',
                        amount: '-100.000 đ',
                        amountColor:
                        const Color(0xFFFF3F4F),
                      ),

                      _transactionItem(
                        icon: Icons.attach_money,
                        iconColor: const Color(0xFF27AE4B),
                        title: 'Lương tháng 9',
                        category: 'Thu nhập',
                        date: '01/09/2024',
                        amount: '+8.000.000 đ',
                        amountColor:
                        const Color(0xFF27AE4B),
                      ),

                      _transactionItem(
                        icon: Icons.shopping_cart,
                        iconColor: const Color(0xFF9B45F2),
                        title: 'Mua sắm',
                        category: 'Mua sắm',
                        date: '31/08/2024',
                        amount: '-300.000 đ',
                        amountColor:
                        const Color(0xFFFF3F4F),
                      ),

                      _transactionItem(
                        icon: Icons.school,
                        iconColor: const Color(0xFF159D9D),
                        title: 'Học phí',
                        category: 'Giáo dục',
                        date: '30/08/2024',
                        amount: '-500.000 đ',
                        amountColor:
                        const Color(0xFFFF3F4F),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),

      // =========================
      // NÚT +
      // =========================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2674D9),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  // =========================
  // CARD THU NHẬP / CHI TIÊU
  // =========================
  static Widget _summaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      height: 75,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: iconColor,
                width: 4,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF526174),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // MỘT GIAO DỊCH
  // =========================
  static Widget _transactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required String date,
    required String amount,
    required Color amountColor,
    bool isLast = false,
  }) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
          bottom: BorderSide(
            color: Color(0xFFE9ECF1),
          ),
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17243A),
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7D8797),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7D8797),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
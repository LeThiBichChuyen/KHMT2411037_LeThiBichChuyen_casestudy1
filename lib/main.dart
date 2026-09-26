import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';

void main() {
  runApp(const ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 120),

              // LOGO
              SizedBox(
                width: 120,
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 30,
                      child: Container(
                        width: 70,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF81C784),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 18,
                      left: 20,
                      child: Container(
                        width: 70,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 8,
                      child: Container(
                        width: 105,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 43,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0756A6),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Center(
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // TÊN ỨNG DỤNG
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10233F),
                ),
              ),

              const SizedBox(height: 18),

              // MÔ TẢ
              const Text(
                'Quản lý chi tiêu cá nhân',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8993A4),
                ),
              ),

              const Text(
                'đơn giản và hiệu quả',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8993A4),
                ),
              ),

              const Spacer(),

              // NÚT BẮT ĐẦU
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AddTransactionScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
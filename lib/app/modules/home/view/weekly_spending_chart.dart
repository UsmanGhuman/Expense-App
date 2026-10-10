import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../transactions/controllers/transaction_controller.dart';

class WeeklySpendingChart extends StatelessWidget {
  const WeeklySpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    //  Controller ko find kiya
    final TransactionController txController =
        Get.find<TransactionController>();

    return SizedBox(
      height: Get.height * 0.25,
      child: Obx(() {
        //  Haftay ke 7 dino ke liye expenses calculate karne ka logic
        List<FlSpot> dynamicSpots = [];
        DateTime now = DateTime.now();

        // Is haftay ka Monday nikalain
        DateTime monday = now.subtract(Duration(days: now.weekday - 1));
        DateTime cleanMonday = DateTime(monday.year, monday.month, monday.day);

        for (int i = 0; i < 7; i++) {
          DateTime targetDay = cleanMonday.add(Duration(days: i));

          // Is din ke saare expenses ka total sum nikalain
          double dayTotal = txController.recentTransactions
              .where((tx) {
                if (tx.isIncome) return false;

                // Apne model ki timestamp parse karein (Agar millisecondsSinceEpoch id hai to):
                DateTime txDate = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(tx.id),
                );
                return txDate.year == targetDay.year &&
                    txDate.month == targetDay.month &&
                    txDate.day == targetDay.day;
              })
              .fold(0.0, (sum, item) => sum + item.amount);

          dynamicSpots.add(FlSpot(i.toDouble(), dayTotal));
        }

        return LineChart(
          LineChartData(
            minY: -20,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppColors.offGreyColor1.withAlpha(40),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              leftTitles: AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 25,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ];
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      return Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          days[value.toInt()],
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: AppColors.greenColor,
                barWidth: 3,
                spots:
                    dynamicSpots, //  Static spots ki jagah dynamic spots lag gaye!
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.offGreenColor1,
                      AppColors.offGreenColor2,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        );
      }),
    );
  }
}

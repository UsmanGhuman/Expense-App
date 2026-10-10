import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../transactions/controllers/transaction_controller.dart';

class MonthlyFlowChart extends StatelessWidget {
  const MonthlyFlowChart({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController txController = Get.put(TransactionController());

    return SizedBox(
      height: Get.height * 0.25,
      child: Obx(() {
        DateTime now = DateTime.now();

        DateTime m3 = DateTime(now.year, now.month - 2, 1);
        DateTime m2 = DateTime(now.year, now.month - 1, 1);
        DateTime m1 = DateTime(now.year, now.month, 1);

        List<String> dynamicMonths = [
          DateFormat('MMMM').format(m3),
          DateFormat('MMMM').format(m2),
          DateFormat('MMMM').format(m1),
        ];

        double getMonthlyData(DateTime targetMonth, bool isIncome) {
          return txController.recentTransactions
              .where((tx) {
                if (tx.isIncome != isIncome) return false;

                try {
                  DateTime txDate = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(tx.id),
                  );
                  return txDate.month == targetMonth.month &&
                      txDate.year == targetMonth.year;
                } catch (e) {
                  String lowerTime = tx.time.toLowerCase();
                  String monthName = DateFormat(
                    'MMM',
                  ).format(targetMonth).toLowerCase();

                  if (lowerTime.contains('today') &&
                      targetMonth.month == now.month &&
                      targetMonth.year == now.year) {
                    return true;
                  }
                  return lowerTime.contains(monthName);
                }
              })
              .fold(0.0, (sum, item) => sum + item.amount);
        }

        double m3Income = getMonthlyData(m3, true);
        double m3Expense = getMonthlyData(m3, false);

        double m2Income = getMonthlyData(m2, true);
        double m2Expense = getMonthlyData(m2, false);

        double m1Income = getMonthlyData(m1, true);
        double m1Expense = getMonthlyData(m1, false);

        //  FIX 1: Dummy fallback layout placeholder ko mukammal hata diya gaya hai!

        return BarChart(
          BarChartData(
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            // 🚀 FIX 2: Agar max data 0 ho to chart crash na kare, baseline 10 set ki
            maxY:
                (m1Income == 0 &&
                    m1Expense == 0 &&
                    m2Income == 0 &&
                    m2Expense == 0 &&
                    m3Income == 0 &&
                    m3Expense == 0)
                ? 10
                : null,
            titlesData: FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              leftTitles: AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < dynamicMonths.length) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          dynamicMonths[index],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ),
            barGroups: [
              // Group 0: 2 Months Ago
              BarChartGroupData(
                x: 0,
                barsSpace: 4,
                barRods: [
                  // FIX 3: toY ko direct value di taake data na hone par bar zero rahe, 1 par na jaye
                  BarChartRodData(
                    toY: m3Income,
                    color: AppColors.onboardGreenColor,
                    width: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: m3Expense,
                    color: AppColors.offGreyColor2,
                    width: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              // Group 1: 1 Month Ago
              BarChartGroupData(
                x: 1,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: m2Income,
                    color: AppColors.onboardGreenColor,
                    width: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: m2Expense,
                    color: AppColors.offGreyColor2,
                    width: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              // Group 2: Current Month
              BarChartGroupData(
                x: 2,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: m1Income,
                    color: AppColors.onboardGreenColor,
                    width: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: m1Expense,
                    color: AppColors.offGreyColor2,
                    width: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // For bar charts
import 'dart:math' as math; // For circular progress painter

// Ensure this import path is correct based on your folder structure
import 'screens/chat_screen.dart';

void main() {
  runApp(const VitaSyncApp());
}

class VitaSyncApp extends StatelessWidget {
  const VitaSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitaSync',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Or your custom purple
        scaffoldBackgroundColor: const Color(0xFFF0F2F8), // Light greyish background
        fontFamily: 'Poppins', // Make sure to add this font to your project
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF666666)),
          labelSmall: TextStyle(color: Color(0xFF888888)),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        // Define colorScheme if not using primarySwatch to ensure consistent colors
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const VitaSyncDashboardScreen(),
    );
  }
}

class VitaSyncDashboardScreen extends StatefulWidget {
  const VitaSyncDashboardScreen({super.key});

  @override
  State<VitaSyncDashboardScreen> createState() => _VitaSyncDashboardScreenState();
}

class _VitaSyncDashboardScreenState extends State<VitaSyncDashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final int currentSteps = 8742;
  final int goalSteps = 10000;
  final int currentCalories = 1650;
  final int goalCalories = 2600;
  final double currentSleep = 7.3;
  final double goalSleep = 8.0;
  final List<double> weeklyStepsData = [6500, 8200, 7000, 9500, 10200, 8800, 7500];
  final int weeklyStepsGoal = 10000;
  final List<double> weeklySleepData = [6.5, 7.2, 6.8, 8.1, 7.3, 7.8, 6.0];
  final double weeklySleepGoal = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use theme colors for consistency where possible
    final primaryColor = theme.primaryColor; // Or your specific Color(0xFF6A11CB)
    final secondaryColor = const Color(0xFF2575FC);
    final stepsColor = const Color(0xFF6A11CB);
    final caloriesColor = const Color(0xFF00BFA6);
    final sleepColor = const Color(0xFF8E2DE2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.bolt, color: Colors.white, size: 30),
        ),
        title: const Text('VitaSync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
            label: Text(
              DateFormat('MMM d').format(_selectedDate),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('JS', style: TextStyle(color: Color(0xFF6A11CB), fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Dashboard', style: theme.textTheme.titleLarge?.copyWith(fontSize: 26)),
            const SizedBox(height: 4),
            Text('Track your daily progress and weekly trends', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            _buildDailyActivitySection(theme, stepsColor, caloriesColor, sleepColor),
            const SizedBox(height: 24),
            _buildWeeklyStepsSection(theme, stepsColor),
            const SizedBox(height: 24),
            _buildWeeklySleepSection(theme, sleepColor),
            const SizedBox(height: 24),
            _buildFeatureCardsSection(theme, stepsColor, caloriesColor, sleepColor),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        label: const Text('VitaBot', style: TextStyle(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.chat_bubble_outline_rounded),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDailyActivitySection(ThemeData theme, Color stepsColor, Color caloriesColor, Color sleepColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Activity', style: theme.textTheme.titleMedium?.copyWith(fontSize: 20)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActivityRing(
                  context : context,
                  title: 'Steps',
                  currentValue: currentSteps.toDouble(),
                  goalValue: goalSteps.toDouble(),
                  color: stepsColor,
                  valueString: NumberFormat.decimalPattern().format(currentSteps),
                  unit: 'of $goalSteps',
                ),
                _buildActivityRing(
                  context : context,
                  title: 'Calories',
                  currentValue: currentCalories.toDouble(),
                  goalValue: goalCalories.toDouble(),
                  color: caloriesColor,
                  valueString: NumberFormat.decimalPattern().format(currentCalories),
                  unit: 'of $goalCalories',
                ),
                _buildActivityRing(
                  context : context,
                  title: 'Sleep',
                  currentValue: currentSleep,
                  goalValue: goalSleep,
                  color: sleepColor,
                  valueString: '${currentSleep}h',
                  unit: 'of ${goalSleep}h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRing({
    required BuildContext context,
    required String title,
    required double currentValue,
    required double goalValue,
    required Color color,
    required String valueString,
    required String unit,
  }) {
    final theme = Theme.of(context);
    double percentage = (currentValue / goalValue).clamp(0.0, 1.0);

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: CircularProgressPainter(
                    progress: percentage,
                    color: color,
                    backgroundColor: color.withAlpha(50), // Softer background
                    strokeWidth: 10,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(valueString, style: theme.textTheme.titleMedium?.copyWith(fontSize: 20, color: color)),
                  Text(unit, style: theme.textTheme.labelSmall?.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 16)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
                '${(percentage * 100).toStringAsFixed(0)}% ${title == 'Calories' ? 'Consumed' : (title == 'Sleep' ? 'of Goal' : 'Complete')}',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)
            ),
          ],
        )
      ],
    );
  }

  Widget _buildWeeklyStepsSection(ThemeData theme, Color stepsColor) {
    double averageSteps = weeklyStepsData.isNotEmpty
        ? weeklyStepsData.reduce((a, b) => a + b) / weeklyStepsData.length
        : 0;
    double weeklyGoalProgress = weeklyStepsData.isNotEmpty
        ? (averageSteps * 7) / (weeklyStepsGoal * 7)
        : 0;
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Steps', style: theme.textTheme.titleMedium?.copyWith(fontSize: 20)),
                Text('Goal: ${NumberFormat.decimalPattern().format(weeklyStepsGoal)}/day', style: theme.textTheme.bodySmall?.copyWith(color: stepsColor)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: weeklyStepsGoal * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${days[groupIndex]}\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY).toInt().toString(),
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text(days[value.toInt()], style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value == 0) return const Text('');
                          if (value % 3000 == 0) {
                            return Text('${(value / 1000).toStringAsFixed(0)}k', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withAlpha(50),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: List.generate(weeklyStepsData.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                            toY: weeklyStepsData[index],
                            color: stepsColor,
                            width: 12,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)
                            )
                        ),
                      ],
                    );
                  }),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: weeklyStepsGoal.toDouble(),
                        color: stepsColor.withAlpha(128),
                        strokeWidth: 2,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 5, bottom:2),
                          style: TextStyle(color: stepsColor, fontSize: 10),
                          labelResolver: (line) => 'Goal: ${weeklyStepsGoal ~/ 1000}k',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Average',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${NumberFormat.decimalPattern().format(averageSteps.toInt())} steps',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: stepsColor),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: weeklyGoalProgress,
              backgroundColor: stepsColor.withAlpha(50),
              valueColor: AlwaysStoppedAnimation<Color>(stepsColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(weeklyGoalProgress * 100).toStringAsFixed(0)}% of weekly goal',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySleepSection(ThemeData theme, Color sleepColor) {
    double averageSleep = weeklySleepData.isNotEmpty
        ? weeklySleepData.reduce((a, b) => a + b) / weeklySleepData.length
        : 0;
    double weeklyGoalProgress = weeklySleepData.isNotEmpty
        ? (averageSleep * 7) / (weeklySleepGoal * 7)
        : 0;
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Sleep', style: theme.textTheme.titleMedium?.copyWith(fontSize: 20)),
                Text('Goal: ${weeklySleepGoal.toStringAsFixed(1)} hours/day', style: theme.textTheme.bodySmall?.copyWith(color: sleepColor)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: weeklySleepGoal * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${days[groupIndex]}\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${rod.toY.toStringAsFixed(1)}h',
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text(days[value.toInt()], style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value == 0) return const Text('');
                          if (value % 2 == 0 || value == weeklySleepGoal) {
                            return Text('${value.toInt()}h', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10));
                          }
                          return const Text('');
                        },
                        interval: 2,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withAlpha(128),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: List.generate(weeklySleepData.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                            toY: weeklySleepData[index],
                            color: sleepColor,
                            width: 12,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)
                            )
                        ),
                      ],
                    );
                  }),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: weeklySleepGoal.toDouble(),
                        color: sleepColor.withAlpha(128),
                        strokeWidth: 2,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 5, bottom:2),
                          style: TextStyle(color: sleepColor, fontSize: 10),
                          labelResolver: (line) => 'Goal: ${weeklySleepGoal}h',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Average',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${averageSleep.toStringAsFixed(1)} hours',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: sleepColor),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: weeklyGoalProgress,
              backgroundColor: sleepColor.withAlpha(50),
              valueColor: AlwaysStoppedAnimation<Color>(sleepColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(weeklyGoalProgress * 100).toStringAsFixed(0)}% of weekly goal',
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sleepColor.withAlpha(25), // Softer background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: sleepColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your deep sleep increased by 12% this week. Keep maintaining a consistent sleep schedule.',
                      style: theme.textTheme.bodySmall?.copyWith(color: sleepColor.withAlpha(230)), // Darker text
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCardsSection(ThemeData theme, Color stepsColor, Color caloriesColor, Color sleepColor) {
    final pedometerColor = stepsColor;
    final calorieColor = caloriesColor;
    final injuryColor = sleepColor;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _buildFeatureCard(
            context: context,
            icon: Icons.directions_walk,
            title: 'Pedometer',
            subtitle: 'Track your steps in real-time',
            color: pedometerColor,
            onTap: () { /* Navigate to Pedometer screen */ }
        ),
        _buildFeatureCard(
            context: context,
            icon: Icons.restaurant_menu,
            title: 'Calorie Counter',
            subtitle: 'Log and track your daily calories',
            color: calorieColor,
            onTap: () { /* Navigate to Calorie Counter screen */ }
        ),
        _buildFeatureCard(
            context: context,
            icon: Icons.healing,
            title: 'Injury Assessment',
            subtitle: 'Get help with injuries and recovery',
            color: injuryColor,
            onTap: () { /* Navigate to Injury Assessment screen */ }
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withAlpha(200), fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Circular Progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

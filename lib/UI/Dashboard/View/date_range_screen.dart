import 'package:gmart/Core/application_base.dart';

class DateRangeScreen extends StatefulWidget {
  const DateRangeScreen({super.key});

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  DateTimeRange? selectedRange;

  Future<void> pickDateRange() async {
    final now = DateTime.now();

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5, now.month, now.day), // last 5 years
      lastDate: now, // today
      initialDateRange: selectedRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    String fromDate = selectedRange != null
        ? formatDate(selectedRange!.start)
        : "Select From Date";

    String toDate = selectedRange != null
        ? formatDate(selectedRange!.end)
        : "Select To Date";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // From Date
          Text(
            "From: $fromDate",
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 10),

          // To Date
          Text(
            "To: $toDate",
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 30),

          // Button
          ElevatedButton(
            onPressed: pickDateRange,
            child: const Text("Select Date Range"),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/models/station.dart';
import 'package:quick_ticket/repositories/schedule_repository.dart';
import 'package:quick_ticket/screens/booking_screen.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSection();
}

class _SearchSection extends State<SearchSection> {
  DateTime? selectedDate;
  Station? _fromStation;
  Station? _toStation;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  ScheduleRepository repo = ScheduleRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimary,
              onPrimary: Colors.white,
              onSurface: kTextDark,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black54,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  dynamic code1 = 1;
  dynamic code2 = 2;

  Future<void> _openSearch(bool isFrom) async {
    final result = await context.push<Station>(
      "/home/search",
      extra: isFrom ? "from" : "to",
    );

    if (result != null) {
      setState(() {
        final name = result.name ?? "";
        final code = result.code ?? "";
        if (isFrom) {
          if (_toStation?.code == code && code.isNotEmpty) {
            _showError("From and To stations cannot be same");
            return;
          }

          _fromStation = result;
          fromController.text = code.isNotEmpty ? "$name ($code)" : name;
        } else {
          if (_fromStation?.code == code && code.isNotEmpty) {
            _showError("From and To stations cannot be same");
            return;
          }

          _toStation = result;
          toController.text = code.isNotEmpty ? "$name ($code)" : name;
        }
      });
    }
  }

  Future<void> _onSearch() async {
    if (_fromStation == null) {
      _showError("Please enter from station");
      return;
    }
    if (_toStation == null) {
      _showError("Please enter to station");
      return;
    }
    if (selectedDate == null) {
      _showError("please enter travel date");
      return;
    }

    final formatedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    try {
      final result = await repo.getAllSchedules(
        _fromStation!.id,
        _toStation!.id,
        formatedDate,
      );
      print("RESULT------- $result");
    } catch (e) {
      print("ERROR----------$e");
      _showError("Something went wrong");
    }

    context.push(
      "/home/schedules",
      extra: {
        'srcStationId': _fromStation!.id,
        'dstStationId': _toStation!.id,
        'srcStationName': _fromStation!.name,
        'dstStationName': _toStation!.name,
        'travelDate': formatedDate,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey, width: 0.4),
          color: Colors.white
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 35),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Book Train Tickets",
                        style: TextStyle(
                          color: kPrimary,
                          fontSize: 22,
                          // fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Pill(label: "Fast"),
                          const SizedBox(width: 6),
                          _Pill(label: "Easy"),
                          const SizedBox(width: 6),
                          _Pill(label: "Secure"),
                        ],
                      ),
                    ],
                  ),
                ),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black.withOpacity(0.2))
                      ),
                    ),
                    const Icon(
                        Icons.train_rounded,
                        size: 42,
                        color: kPrimary
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 45),
            GestureDetector(
              onTap: () => _openSearch(true),
              child: AbsorbPointer(
                child: TextField(
                  controller: fromController,
                  decoration: InputDecoration(
                    hintText: "From Station",
                    icon: Icon(Icons.train),
                    iconColor: Colors.black.withOpacity(0.7),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () => _openSearch(false),
              child: AbsorbPointer(
                child: TextField(
                  controller: toController,
                  decoration: InputDecoration(
                    hintText: "To Station",
                    icon: Icon(Icons.train),
                    iconColor: Colors.black.withOpacity(0.7),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: "Select Travel Date",
                    icon: Icon(Icons.calendar_month_rounded),
                    iconColor: Colors.black.withOpacity(0.7),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _onSearch(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A80D8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(6),
                  ),
                ),
                child: Text("SEARCH TRAINS",style: TextStyle(fontSize: 17)),
              ),
            ),
            SizedBox(height: 20),
            Text("IRCTC Authorised Partner", style: TextStyle(color: Colors.black))
          ],
        ),
      ),
    );
  }
}


class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: Colors.black,width: 0.2)
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
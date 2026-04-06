import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/models/station.dart';
import 'package:quick_ticket/repositories/schedule_repository.dart';

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
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2A80D8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  dynamic code1 = 1;
  dynamic code2 = 2;

  Future<void> _openSearch(bool isFrom) async {
    final result = await context.push<Station>("/home/search",extra: isFrom ? "from" : "to",);

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
    if(_fromStation == null) {
      _showError("Please enter from station");
      return;
    }
    if(_toStation == null) {
      _showError("Please enter to station");
      return;
    }
    if(selectedDate == null) {
      _showError("please enter travel date");
      return;
    }

    final formatedDate = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    try {
      final result = await repo.getAllSchedules(_fromStation!.id, _toStation!.id, formatedDate);
      print("RESULT------- $result");
    } catch(e) {
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
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8FF), width: 1.2),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _openSearch(true),
              child: AbsorbPointer(
                child: TextField(
                  controller: fromController,
                  decoration: InputDecoration(
                    hintText: "From Station",
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
                    iconColor: const Color(0xFF2A80D8),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: 350,
              child: ElevatedButton(
                onPressed: () => _onSearch(),
                child: Text("SEARCH TRAINS"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A80D8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(14),
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

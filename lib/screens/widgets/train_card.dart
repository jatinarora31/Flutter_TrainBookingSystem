import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/network/token_service.dart';
import '../../models/schedule.dart';
import '../schedule_screen.dart';

class TrainCard extends StatelessWidget {
  final Schedule schedule;
  final String srcStationId;
  final String dstStationId;
  final String srcStationName;
  final String dstStationName;
  final String travelDate;

  const TrainCard({
    super.key,
    required this.schedule,
    required this.srcStationId,
    required this.dstStationId,
    required this.srcStationName,
    required this.dstStationName,
    required this.travelDate,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFF16A34A);
      case 'delayed':
        return const Color(0xFFD97706);
      case 'cancelled':
        return const Color(0xFFDC2626);
      default:
        return kTextMuted;
    }
  }

  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFFDCFCE7);
      case 'delayed':
        return const Color(0xFFFEF3C7);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  void _showLoginDialog(BuildContext context) {
    const primaryColor = Color(0xFF2A80D8);

    // Store data in a static variable or pass through route
    final bookingData = {
      'scheduleId': schedule.id,
      'srcStationId': srcStationId,
      'dstStationId': dstStationId,
      'srcStationName': srcStationName,
      'dstStationName': dstStationName,
      'travelDate': travelDate,
    };

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Login Required",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please login to continue booking.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Use push with extra data
                          context.push(
                            '/login',
                            extra: {
                              'redirect': '/home/schedules/book',
                              'data': bookingData,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onContinue(BuildContext context) async {
    final token = await TokenService.getToken();
    if (token == null) {
      _showLoginDialog(context);
      return;
    }
    // Use the correct nested path - note: no leading slash
    context.push(
      '/home/schedules/book',
      extra: {
        'scheduleId': schedule.id,
        'srcStationId': srcStationId,
        'dstStationId': dstStationId,
        'srcStationName': srcStationName,
        'dstStationName': dstStationName,
        'travelDate': travelDate,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.train, color: kPrimary, size: 22),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.train.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '#${schedule.train.trainNumber}',
                            style: const TextStyle(
                              color: kTextMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBg(schedule.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    schedule.status[0].toUpperCase() +
                        schedule.status.substring(1),
                    style: TextStyle(
                      color: _statusColor(schedule.status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.formattedDeparture,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      "Departure",
                      style: TextStyle(color: kTextMuted, fontSize: 11),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        schedule.duration,
                        style: const TextStyle(
                          color: kPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 1.5,
                            color: Colors.grey.shade200,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          const Icon(Icons.train, color: kPrimary, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      schedule.formattedArrival,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      "Arrival",
                      style: TextStyle(color: kTextMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => _onContinue(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // if (schedule.delayMinutes > 0)
          //   Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //     decoration: const BoxDecoration(
          //       color: Color(0xFFFFFBEB),
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(18),
          //         bottomRight: Radius.circular(18),
          //       ),
          //     ),
          //     child: Row(
          //       children: [
          //         const Icon(
          //           Icons.access_time,
          //           size: 14,
          //           color: Color(0xFFD97706),
          //         ),
          //         const SizedBox(width: 6),
          //         Text(
          //           // "Delayed by ${schedule.delayMinutes} min",
          //           "",
          //           style: const TextStyle(
          //             color: Color(0xFFD97706),
          //             fontSize: 12,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}

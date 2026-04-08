// my_bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/repositories/booking_repository.dart';
import 'package:quick_ticket/screens/booking_success_screen.dart';

import 'booking_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late BookingRepository _bookingRepo;

  List<dynamic> allBookings = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _bookingRepo = BookingRepository();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _bookingRepo.fetchUserBookings();

      setState(() {
        allBookings = response['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchBookings,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: kPrimary),
      )
          : errorMessage != null
          ? _buildErrorView()
          : allBookings.isEmpty
          ? _buildEmptyView()
          : RefreshIndicator(
        onRefresh: _fetchBookings,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: allBookings.length,
          itemBuilder: (context, index) {
            final booking = allBookings[index];
            return _BookingCard(booking: booking);
          },
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: kTextMuted),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            style: const TextStyle(color: kTextMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchBookings,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: kTextMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No bookings found',
            style: TextStyle(
              fontSize: 16,
              color: kTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.go("/home");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Book a Train'),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final schedule = booking['schedule'];
    final train = schedule['train'];
    final srcStation = booking['src_station'];
    final dstStation = booking['dst_station'];
    final passengers = booking['passengers'];
    final payment = booking['payment'];
    final ticketAllocations = booking['ticket_allocations'];

    final travelDate = DateTime.parse(schedule['travel_date']);
    final isUpcoming = travelDate.isAfter(DateTime.now()) && booking['status'] != 'cancelled';
    final isCancelled = booking['status'] == 'cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? Colors.red
                        : isUpcoming
                        ? Colors.orange
                        : Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: Text(
                    isCancelled ? 'CANCELLED' : (isUpcoming ? 'UPCOMING' : 'COMPLETED'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      // backgroundColor: isCancelled ? Colors.red : (isUpcoming ? Colors.orange : Colors.green),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  booking['booking_ref'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.train_rounded,
                        color: kPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            train['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                            ),
                          ),
                          Text(
                            '${train['train_number']} • ${train['train_type']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Journey Details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatTime(schedule['departure_time']),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                            ),
                          ),
                          Text(
                            srcStation['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            srcStation['code'],
                            style: TextStyle(
                              fontSize: 11,
                              color: kPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _formatDuration(schedule['departure_time'], schedule['expected_arrival_time']),
                            style: TextStyle(
                              fontSize: 11,
                              color: kTextMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: kPrimary.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: kPrimary,
                                  size: 14,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: kPrimary.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(schedule['expected_arrival_time']),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                            ),
                          ),
                          Text(
                            dstStation['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            dstStation['code'],
                            style: TextStyle(
                              fontSize: 11,
                              color: kPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Date and Passengers
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: kTextMuted),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(schedule['travel_date']),
                      style: TextStyle(
                        fontSize: 12,
                        color: kTextMuted,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.people_rounded, size: 14, color: kTextMuted),
                    const SizedBox(width: 6),
                    Text(
                      '${passengers.length} Passenger${passengers.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: kTextMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Passenger names with seats
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(passengers.length, (index) {
                    final passenger = passengers[index];
                    final allocation = ticketAllocations.firstWhere(
                          (a) => a['passenger_id'] == passenger['id'],
                      orElse: () => ticketAllocations[0],
                    );
                    final seat = allocation['seat'];

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${passenger['first_name']} ${passenger['last_name']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kTextDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: kTextMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Seat: ${seat['seat_number']} (${seat['seat_type']})',
                            style: TextStyle(
                              fontSize: 11,
                              color: kPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // Payment Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            payment['payment_method'] == 'UPI' ? Icons.qr_code_scanner_rounded :
                            payment['payment_method'] == 'CARD' ? Icons.credit_card :
                            Icons.account_balance,
                            size: 18,
                            color: kPrimary,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Paid via ${payment['payment_method']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kTextMuted,
                                ),
                              ),
                              Text(
                                payment['gateway_txn_id'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: kTextMuted.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '₹${double.parse(booking['total_fare']).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // View Details Button
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => BookingSuccessScreen(
                //             apiResponse: {'data': [booking]},
                //             srcStationName: srcStation['name'],
                //             dstStationName: dstStation['name'],
                //             travelDate: schedule['travel_date'],
                //             totalFare: double.parse(booking['total_fare']),
                //             seatCount: passengers.length,
                //             scheduleId: booking['schedule_id'],
                //             coachType: 'N/A',
                //             selectedSeatIds: {},
                //             passengersData: [],
                //             paymentMethod: payment['payment_method'],
                //             transactionId: payment['gateway_txn_id'],
                //           ),
                //         ),
                //       );
                //     },
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: kPrimary,
                //       side: BorderSide(color: kPrimary),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     child: const Text('View Details'),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length < 3) return date;
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[int.tryParse(parts[1]) ?? 0];
    return '${parts[2]} $month ${parts[0]}';
  }

  static String _formatTime(String datetime) {
    if (datetime.isEmpty) return 'N/A';
    try {
      final timePart = datetime.split('T')[1].split('.')[0];
      final parts = timePart.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:$minute $period';
    } catch (e) {
      return datetime;
    }
  }

  static String _formatDuration(String departure, String arrival) {
    try {
      final depTime = DateTime.parse(departure);
      final arrTime = DateTime.parse(arrival);
      final diff = arrTime.difference(depTime);
      return '${diff.inHours}h ${diff.inMinutes % 60}m';
    } catch (e) {
      return 'N/A';
    }
  }
}
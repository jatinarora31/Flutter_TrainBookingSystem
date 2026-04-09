// my_bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/repositories/booking_repository.dart';
import 'package:quick_ticket/network/token_service.dart';
import 'package:quick_ticket/screens/widgets/login_dialog.dart';

import 'booking_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late BookingRepository _bookingRepo;

  List<dynamic> allBookings = [];
  List<dynamic> upcomingBookings = [];
  List<dynamic> pastBookings = [];

  bool isLoading = true;
  String? errorMessage;
  int _selectedTabIndex = 0;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _bookingRepo = BookingRepository();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await TokenService.isLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });

    if (loggedIn) {
      _fetchBookings();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Please login to view your bookings";
      });
    }
  }

  Future<void> _fetchBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _bookingRepo.fetchUserBookings();
      final bookings = response['data'] ?? [];

      setState(() {
        allBookings = bookings;
        _filterBookings(bookings);
        isLoading = false;
      });
    } catch (e) {
      String error = e.toString().replaceAll('Exception: ', '');

      if (error.contains('401') || error.contains('unauthorized') || error.contains('token')) {
        error = "Session expired. Please login again.";
        await TokenService.clearToken();
      } else if (error.contains('403')) {
        error = "You don't have permission to view bookings";
      } else if (error.contains('500')) {
        error = "Server error. Please try again later.";
      } else if (error.contains('No token found') || error.contains('not logged in')) {
        error = "Please login to view your bookings";
        setState(() {
          isLoggedIn = false;
        });
      }

      setState(() {
        isLoading = false;
        errorMessage = error;
      });
    }
  }

  void _filterBookings(List<dynamic> bookings) {
    final now = DateTime.now();

    upcomingBookings = bookings.where((booking) {
      final schedule = booking['schedule'];
      final travelDate = DateTime.parse(schedule['travel_date']);
      final isCancelled = booking['status'] == 'cancelled';
      return travelDate.isAfter(now) && !isCancelled;
    }).toList();

    pastBookings = bookings.where((booking) {
      final schedule = booking['schedule'];
      final travelDate = DateTime.parse(schedule['travel_date']);
      final isCancelled = booking['status'] == 'cancelled';
      return travelDate.isBefore(now) || isCancelled;
    }).toList();

    upcomingBookings.sort((a, b) {
      final dateA = DateTime.parse(a['schedule']['travel_date']);
      final dateB = DateTime.parse(b['schedule']['travel_date']);
      return dateA.compareTo(dateB);
    });

    pastBookings.sort((a, b) {
      final dateA = DateTime.parse(a['schedule']['travel_date']);
      final dateB = DateTime.parse(b['schedule']['travel_date']);
      return dateB.compareTo(dateA);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width:0.1
          )
        ),
        toolbarOpacity: 0.8,
        centerTitle: true,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: kPrimary),
      )
          : errorMessage != null
          ? _buildErrorView()
          : Column(
        children: [
          if (upcomingBookings.isNotEmpty || pastBookings.isNotEmpty)
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 0 ? kPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kPrimary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upcoming,
                              size: 18,
                              color: _selectedTabIndex == 0 ? Colors.white : kPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Upcoming',
                              style: TextStyle(
                                color: _selectedTabIndex == 0 ? Colors.white : kPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_selectedTabIndex == 0 && upcomingBookings.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _selectedTabIndex == 0 ? Colors.white : kPrimary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${upcomingBookings.length}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTabIndex == 0 ? kPrimary : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 1 ? kPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kPrimary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 18,
                              color: _selectedTabIndex == 1 ? Colors.white : kPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Past',
                              style: TextStyle(
                                color: _selectedTabIndex == 1 ? Colors.white : kPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_selectedTabIndex == 1 && pastBookings.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _selectedTabIndex == 1 ? Colors.white : kPrimary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${pastBookings.length}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTabIndex == 1 ? kPrimary : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _selectedTabIndex == 0
                ? (upcomingBookings.isEmpty
                ? _buildEmptyView('No upcoming bookings', Icons.upcoming)
                : RefreshIndicator(
              onRefresh: _fetchBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: upcomingBookings.length,
                itemBuilder: (context, index) {
                  final booking = upcomingBookings[index];
                  return _BookingCard(booking: booking);
                },
              ),
            ))
                : (pastBookings.isEmpty
                ? _buildEmptyView('No past bookings', Icons.history)
                : RefreshIndicator(
              onRefresh: _fetchBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pastBookings.length,
                itemBuilder: (context, index) {
                  final booking = pastBookings[index];
                  return _BookingCard(booking: booking);
                },
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    final isNotLoggedIn = errorMessage?.contains('login') ?? false;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              isNotLoggedIn ? Icons.lock_outline : Icons.error_outline,
              size: 64,
              color: kTextMuted
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            style: const TextStyle(color: kTextMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (isNotLoggedIn)
            ElevatedButton(
              onPressed: () {
                _showLoginDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Login Now'),
            )
          else
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

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoginDialog(
          onLoginSuccess: () {
            _fetchBookings();
          },
        );
      },
    );
  }

  Widget _buildEmptyView(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: kTextMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
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

// Rest of the _BookingCard class remains the same...
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
    final now = DateTime.now();
    final isUpcoming = travelDate.isAfter(now) && booking['status'] != 'cancelled';
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
          // Header with status and booking ref
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
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    isCancelled ? 'CANCELLED' : (isUpcoming ? 'UPCOMING' : 'COMPLETED'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  booking['booking_ref'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Body content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Train info
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
                            decoration: const BoxDecoration(
                              color: kTextMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Seat: ${seat['seat_number']} (${_getSeatTypeName(seat['seat_type'])})',
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

                // PNR Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.confirmation_number, size: 18, color: kPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'PNR: ${ticketAllocations[0]['pnr']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

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
                            payment['payment_method'] == 'NET BANKING' ? Icons.account_balance :
                            Icons.payment,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSeatTypeName(String seatType) {
    switch(seatType) {
      case 'A': return 'AC';
      case 'B': return 'Sleeper';
      case 'C': return 'Chair';
      case 'LB': return 'Lower Berth';
      case 'UB': return 'Upper Berth';
      case 'MB': return 'Middle Berth';
      case 'W': return 'Window';
      default: return seatType;
    }
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
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return '$hours h ${minutes}m';
    } catch (e) {
      return 'N/A';
    }
  }
}
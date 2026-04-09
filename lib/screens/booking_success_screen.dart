// booking_success_screen.dart
import 'package:flutter/material.dart';
import 'package:quick_ticket/screens/booking_screen.dart';
import 'package:quick_ticket/screens/home_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> apiResponse;
  final String srcStationName;
  final String dstStationName;
  final String travelDate;
  final double totalFare;
  final int seatCount;
  final String scheduleId;
  final String coachType;
  final Set<String> selectedSeatIds;
  final List<Map<String, dynamic>> passengersData;
  final String paymentMethod;
  final String transactionId;

  const BookingSuccessScreen({
    super.key,
    required this.apiResponse,
    required this.srcStationName,
    required this.dstStationName,
    required this.travelDate,
    required this.totalFare,
    required this.seatCount,
    required this.scheduleId,
    required this.coachType,
    required this.selectedSeatIds,
    required this.passengersData,
    required this.paymentMethod,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {

    final message = apiResponse['message'] ?? 'Booking confirmed successfully';
    final booking = apiResponse['booking'] ?? {};
    final bookingRef = booking['booking_ref'] ?? 'BKG-${DateTime.now().millisecondsSinceEpoch}';
    final bookingStatus = booking['status'] ?? 'confirmed';
    final bookedAt = booking['booked_at'] ?? DateTime.now().toIso8601String();
    final totalFareFromApi = booking['total_fare'] ?? totalFare.toString();

    final schedule = booking['schedule'] ?? {};
    final train = schedule['train'] ?? {};
    final trainName = train['name'] ?? 'Train';
    final trainNumber = train['train_number'] ?? 'XXXX';
    final trainType = train['train_type'] ?? 'Express';
    final departureTime = schedule['departure_time'] ?? '';
    final arrivalTime = schedule['expected_arrival_time'] ?? '';

    // Extract station details
    final srcStation = booking['src_station'] ?? {};
    final dstStation = booking['dst_station'] ?? {};
    final srcName = srcStation['name'] ?? srcStationName;
    final srcCode = srcStation['code'] ?? '';
    final dstName = dstStation['name'] ?? dstStationName;
    final dstCode = dstStation['code'] ?? '';

    // Extract payment details
    final payment = booking['payment'] ?? {};
    final paymentMethodFromApi = payment['payment_method'] ?? paymentMethod;
    final transactionIdFromApi = payment['gateway_txn_id'] ?? transactionId;
    final paymentStatus = payment['status'] ?? 'paid';
    final amountPaid = payment['amount'] ?? totalFare.toString();

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Success Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: kSuccess.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: kSuccess,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Success Message
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Booking Ref: $bookingRef',
                      style: const TextStyle(
                        fontSize: 14,
                        color: kTextMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: kSuccess,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Train Details Card (if available from API)
                    if (trainName != 'Train') ...[
                      _buildInfoCard(
                        title: 'Train Details',
                        icon: Icons.train_rounded,
                        children: [
                          _buildInfoRow('Train Name', trainName),
                          _buildInfoRow('Train Number', trainNumber),
                          _buildInfoRow('Train Type', trainType),
                          _buildInfoRow('Status', schedule['status'] ?? 'Scheduled',
                              valueColor: kSuccess),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Journey Details Card
                    _buildInfoCard(
                      title: 'Journey Details',
                      icon: Icons.route_rounded,
                      children: [
                        _buildInfoRow('From', '$srcName${srcCode.isNotEmpty ? ' ($srcCode)' : ''}'),
                        _buildInfoRow('To', '$dstName${dstCode.isNotEmpty ? ' ($dstCode)' : ''}'),
                        _buildInfoRow('Date', _formatDate(travelDate)),
                        if (departureTime.isNotEmpty)
                          _buildInfoRow('Departure', _formatTime(departureTime)),
                        if (arrivalTime.isNotEmpty)
                          _buildInfoRow('Arrival', _formatTime(arrivalTime)),
                        _buildInfoRow('Coach Type', coachType.toUpperCase()),
                        const Divider(height: 16),
                        _buildInfoRow('Total Seats', '$seatCount seat(s)'),
                        _buildInfoRow('Total Fare', '₹${double.parse(totalFareFromApi).toStringAsFixed(2)}',
                            valueColor: kPrimary, isBold: true),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Passenger & Seat Details Card
                    _buildInfoCard(
                      title: 'Passenger & Seat Details',
                      icon: Icons.people_rounded,
                      children: [
                        ...List.generate(seatCount, (index) {
                          final passenger = passengersData[index];
                          final seatNumber = selectedSeatIds.toList()[index];

                          // Try to get PNR from API response if available
                          String pnr = '';
                          final ticketAllocations = booking['ticket_allocations'] ?? [];
                          if (ticketAllocations.isNotEmpty && index < ticketAllocations.length) {
                            pnr = ticketAllocations[index]['pnr'] ?? '';
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kPrimary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kPrimary.withOpacity(0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${passenger['first_name']} ${passenger['last_name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: kTextDark,
                                        ),
                                      ),
                                    ),
                                    if (pnr.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: kSuccess.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          pnr,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: kSuccess,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailChip(
                                        icon: Icons.cake_outlined,
                                        label: 'Age',
                                        value: '${passenger['age']}',
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDetailChip(
                                        icon: Icons.transgender,
                                        label: 'Gender',
                                        value: passenger['gender'],
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDetailChip(
                                        icon: Icons.airline_seat_recline_normal,
                                        label: 'Seat',
                                        value: seatNumber,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildDetailChip(
                                  icon: Icons.badge_outlined,
                                  label: 'ID',
                                  value: '${passenger['id_type']}: ${passenger['id_number']}',
                                  fullWidth: true,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Payment Details Card
                    _buildInfoCard(
                      title: 'Payment Details',
                      icon: Icons.payment_rounded,
                      children: [
                        _buildInfoRow('Payment Method', paymentMethodFromApi),
                        _buildInfoRow('Transaction ID', transactionIdFromApi),
                        _buildInfoRow('Amount Paid', '₹${double.parse(amountPaid).toStringAsFixed(2)}',
                            valueColor: kSuccess),
                        _buildInfoRow('Status', paymentStatus.toUpperCase(),
                            valueColor: paymentStatus == 'paid' ? kSuccess : kWarning),
                        _buildInfoRow('Booking Date', _formatDateTime(bookedAt)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Important Notes
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kWarning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kWarning.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: kWarning, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: const Text(
                              'Please carry a valid ID proof for verification. Reach the station at least 1 hour before departure.',
                              style: TextStyle(
                                fontSize: 12,
                                color: kTextDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: kCardBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: kPrimary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Go to Home'),
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _showShareDialog(context, bookingRef, srcName, dstName);
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: kPrimary,
                  //       foregroundColor: Colors.white,
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(14),
                  //       ),
                  //     ),
                  //     child: const Text('Share Ticket'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: kPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color valueColor = kTextDark, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: kTextMuted,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: isBold ? 14 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
  }) {
    if (fullWidth) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: kTextMuted),
            const SizedBox(width: 8),
            Text(
              '$label: ',
              style: const TextStyle(
                fontSize: 12,
                color: kTextMuted,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: kTextMuted),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, String bookingRef, String srcName, String dstName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code, size: 100, color: kPrimary),
            const SizedBox(height: 16),
            Text(
              'Booking Ref: $bookingRef',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total Passengers: $seatCount'),
            const SizedBox(height: 8),
            Text(
              'From: $srcName',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'To: $dstName',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${_formatDate(travelDate)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing ticket...'),
                  backgroundColor: kPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return 'N/A';
    final parts = date.split('-');
    if (parts.length < 3) return date;
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[int.tryParse(parts[1]) ?? 0];
    return '${parts[2]} $month ${parts[0]}';
  }

  String _formatTime(String datetime) {
    if (datetime.isEmpty) return 'N/A';
    try {
      final timePart = datetime.split('T')[1].split('.')[0];
      final parts = timePart.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$hour12:$minute $period';
      }
      return timePart;
    } catch (e) {
      return datetime;
    }
  }

  String _formatDateTime(String datetime) {
    if (datetime.isEmpty) return 'N/A';
    try {
      final datePart = datetime.split('T')[0];
      final timePart = datetime.split('T')[1].split('.')[0];
      final timeParts = timePart.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${_formatDate(datePart)} at $hour12:$minute $period';
    } catch (e) {
      return datetime;
    }
  }
}
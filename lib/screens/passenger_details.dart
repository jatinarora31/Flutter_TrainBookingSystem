
import 'package:flutter/material.dart';
import '../repositories/booking_repository.dart';
import 'booking_success_screen.dart';
import 'booking_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final int seatCount;
  final String scheduleId;
  final String srcStationId;
  final String dstStationId;
  final String srcStationName;
  final String dstStationName;
  final String travelDate;
  final String coachId;
  final String coachType;
  final Set<String> selectedSeatIds;
  final double totalFare;

  const PassengerDetailsScreen({
    super.key,
    required this.seatCount,
    required this.scheduleId,
    required this.srcStationId,
    required this.dstStationId,
    required this.srcStationName,
    required this.dstStationName,
    required this.travelDate,
    required this.coachId,
    required this.coachType,
    required this.selectedSeatIds,
    required this.totalFare,
  });

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final List<Passenger> _passengers = [];
  String _selectedPaymentMethod = 'UPI';
  final String _gatewayTxnId = 'TXN-${DateTime.now().millisecondsSinceEpoch}';
  final _formKey = GlobalKey<FormState>();
  late final BookingRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = BookingRepository();
    for (int i = 0; i < widget.seatCount; i++) {
      _passengers.add(Passenger(
        firstName: '',
        lastName: '',
        age: 0,
        gender: 'male',
        idType: 'Aadhaar',
        idNumber: '',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Passenger Details'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildJourneySummary(),
                    const SizedBox(height: 20),

                    _buildSectionHeader('Passenger Details'),
                    const SizedBox(height: 12),

                    ...List.generate(widget.seatCount, (index) {
                      return _PassengerDetailCard(
                        index: index + 1,
                        passenger: _passengers[index],
                        seatNumber: widget.selectedSeatIds.toList()[index],
                        onChanged: (key, value) {
                          setState(() {
                            _passengers[index] = _passengers[index].copyWith(
                              key: key,
                              value: value,
                            );
                          });
                        },
                      );
                    }),

                    const SizedBox(height: 20),

                    _buildSectionHeader('Payment Details'),
                    const SizedBox(height: 12),

                    _buildPaymentMethodCard(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneySummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.train_rounded, color: kPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Journey Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.srcStationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(widget.travelDate),
                      style: const TextStyle(
                        fontSize: 11,
                        color: kTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: kTextMuted, size: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.dstStationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.seatCount} seat(s)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: kTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Coach: ${widget.coachType.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kPrimary,
                  ),
                ),
                Text(
                  'Total: ₹${widget.totalFare.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: kPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kTextDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
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
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: kPrimary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PaymentMethodTile(
                  title: 'UPI',
                  icon: Icons.qr_code_scanner_rounded,
                  isSelected: _selectedPaymentMethod == 'UPI',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'UPI';
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentMethodTile(
                  title: 'Card',
                  icon: Icons.credit_card,
                  isSelected: _selectedPaymentMethod == 'Card',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Card';
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentMethodTile(
                  title: 'Net Banking',
                  icon: Icons.account_balance,
                  isSelected: _selectedPaymentMethod == 'Net Banking',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Net Banking';
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹${widget.totalFare.toStringAsFixed(0)} total',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kTextDark,
                  ),
                ),
                Text(
                  '${widget.seatCount} seat${widget.seatCount > 1 ? 's' : ''} selected',
                  style: const TextStyle(color: kTextMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _validateAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Proceed to Payment",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateAndProceed() async {
    if (_formKey.currentState!.validate()) {
      bool allValid = true;
      for (var passenger in _passengers) {
        if (passenger.firstName.isEmpty ||
            passenger.lastName.isEmpty ||
            passenger.age == 0 ||
            passenger.idNumber.isEmpty) {
          allValid = false;
          break;
        }
      }

      if (!allValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all passenger details'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      try {
        final bookingData = {
          "booking": {
            "schedule_id": widget.scheduleId,
            "src_station_id": widget.srcStationId,
            "dst_station_id": widget.dstStationId,
            "seat_ids": widget.selectedSeatIds.toList(),
            "coach_type": widget.coachType,
            "payment": {
              "payment_method": _selectedPaymentMethod.toUpperCase(),
              "gateway_txn_id": _gatewayTxnId,
            },
            "passengers": _passengers.map((p) => p.toJson()).toList(),
          }
        };

        print('Booking Data: $bookingData');

        final response = await _repo.createBooking(bookingData);
        print("Response --------========--------- $response");


        // In _validateAndProceed method, update the navigation:

        if (mounted) {
          Navigator.pop(context);

          final passengersList = _passengers.map((p) => {
            'first_name': p.firstName,
            'last_name': p.lastName,
            'age': p.age,
            'gender': p.gender,
            'id_type': p.idType,
            'id_number': p.idNumber,
          }).toList();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingSuccessScreen(
                apiResponse: response, // The Map from API
                srcStationName: widget.srcStationName,
                dstStationName: widget.dstStationName,
                travelDate: widget.travelDate,
                totalFare: widget.totalFare,
                seatCount: widget.seatCount,
                scheduleId: widget.scheduleId,
                coachType: widget.coachType,
                selectedSeatIds: widget.selectedSeatIds,
                passengersData: passengersList,
                paymentMethod: _selectedPaymentMethod.toUpperCase(),
                transactionId: _gatewayTxnId,
              ),
            ),
          );
        }
      } catch(e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }


    }
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length < 3) return date;
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[int.tryParse(parts[1]) ?? 0];
    return '${parts[2]} $month ${parts[0]}';
  }
}

class Passenger {
  String firstName;
  String lastName;
  int age;
  String gender;
  String idType;
  String idNumber;

  Passenger({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.idType,
    required this.idNumber,
  });

  Passenger copyWith({String? key, dynamic value}) {
    switch (key) {
      case 'firstName':
        return Passenger(
          firstName: value,
          lastName: lastName,
          age: age,
          gender: gender,
          idType: idType,
          idNumber: idNumber,
        );
      case 'lastName':
        return Passenger(
          firstName: firstName,
          lastName: value,
          age: age,
          gender: gender,
          idType: idType,
          idNumber: idNumber,
        );
      case 'age':
        return Passenger(
          firstName: firstName,
          lastName: lastName,
          age: value,
          gender: gender,
          idType: idType,
          idNumber: idNumber,
        );
      case 'gender':
        return Passenger(
          firstName: firstName,
          lastName: lastName,
          age: age,
          gender: value,
          idType: idType,
          idNumber: idNumber,
        );
      case 'idType':
        return Passenger(
          firstName: firstName,
          lastName: lastName,
          age: age,
          gender: gender,
          idType: value,
          idNumber: idNumber,
        );
      case 'idNumber':
        return Passenger(
          firstName: firstName,
          lastName: lastName,
          age: age,
          gender: gender,
          idType: idType,
          idNumber: value,
        );
      default:
        return this;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "age": age,
      "gender": gender,
      "id_type": idType,
      "id_number": idNumber,
    };
  }
}

class _PassengerDetailCard extends StatelessWidget {
  final int index;
  final Passenger passenger;
  final String seatNumber;
  final Function(String, dynamic) onChanged;

  const _PassengerDetailCard({
    required this.index,
    required this.passenger,
    required this.seatNumber,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
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
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passenger $index',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kTextDark,
                        ),
                      ),
                      Text(
                        'Seat: $seatNumber',
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
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // First Name
                TextFormField(
                  initialValue: passenger.firstName,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter first name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  onChanged: (value) => onChanged('firstName', value),
                ),
                const SizedBox(height: 10),

                // Last Name
                TextFormField(
                  initialValue: passenger.lastName,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter last name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  onChanged: (value) => onChanged('lastName', value),
                ),
                const SizedBox(height: 10),

                // Age
                TextFormField(
                  initialValue: passenger.age == 0 ? '' : passenger.age.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter age',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return 'Invalid age';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final age = int.tryParse(value) ?? 0;
                    onChanged('age', age);
                  },
                ),
                const SizedBox(height: 10),

                // Gender
                DropdownButtonFormField<String>(
                  value: passenger.gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) => onChanged('gender', value),
                ),
                const SizedBox(height: 10),

                // ID Type
                DropdownButtonFormField<String>(
                  value: passenger.idType,
                  decoration: const InputDecoration(
                    labelText: 'ID Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Aadhaar', child: Text('Aadhaar Card')),
                    DropdownMenuItem(value: 'Passport', child: Text('Passport')),
                    DropdownMenuItem(value: 'Voter ID', child: Text('Voter ID')),
                    DropdownMenuItem(value: 'Driving License', child: Text('Driving License')),
                  ],
                  onChanged: (value) => onChanged('idType', value),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  initialValue: passenger.idNumber,
                  decoration: const InputDecoration(
                    labelText: 'ID Number',
                    hintText: 'Enter ID number',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  onChanged: (value) => onChanged('idNumber', value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? kPrimary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? kPrimary : kTextMuted,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? kPrimary : kTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  import 'package:flutter/material.dart';
import 'package:quick_ticket/screens/passenger_details.dart';
  import '../models/availability.dart';
  import '../models/coach.dart';
  import '../models/fare.dart';
  import '../models/schedule_detail.dart';
  import '../models/seat.dart';
  import '../models/stop.dart';
  import '../repositories/schedule_repository.dart';

  const kPrimary = Color(0xFF2A80D8);
  const kPrimaryLight = Color(0xFF2A80D8);
  const kSecondaryLight = Color(0xFFC2E2FF);
  const kBackground = Color(0xFFF0F4FF);
  const kCardBg = Colors.white;
  const kTextDark = Color(0xFF1A1F36);
  const kTextMuted = Color(0xFF6B7280);
  const kSuccess = Color(0xFF16A34A);
  const kWarning = Color(0xFFD97706);
  const kDanger = Color(0xFFDC2626);

  class BookingScreen extends StatefulWidget {
    final String scheduleId;
    final String srcStationId;
    final String dstStationId;
    final String srcStationName;
    final String dstStationName;
    final String travelDate;

    const BookingScreen({
      super.key,
      required this.scheduleId,
      required this.srcStationId,
      required this.dstStationId,
      required this.srcStationName,
      required this.dstStationName,
      required this.travelDate,
    });

    @override
    State<BookingScreen> createState() => _BookingScreenState();
  }

  class _BookingScreenState extends State<BookingScreen>
      with SingleTickerProviderStateMixin {
    late final ScheduleRepository repo;
    late Future<ScheduleDetail> _future;
    late TabController _tabController;

    String? _selectedCoachId;
    String? _selectedCoachType;
    final Set<String> _selectedSeatIds = {};

    @override
    void initState() {
      super.initState();
      _tabController = TabController(length: 3,vsync: this);
      repo = ScheduleRepository();
      _future = repo.getSchedule(widget.scheduleId, widget.srcStationId, widget.dstStationId,);
    }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
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

    double _fareForCoachType(FareOptions fare, String? coachType) {
      switch (coachType) {
        case '1ac':
          return double.tryParse(fare.oneAc?.farePerSeat ?? '0') ?? 0;
        case '2ac':
          return double.tryParse(fare.twoAc?.farePerSeat ?? '0') ?? 0;
        case 'sleeper':
          return double.tryParse(fare.sleeper?.farePerSeat ?? '0') ?? 0;
        default:
          return 0;
      }
    }

    String _fareLabel(FareOptions fare, String? coachType) {
      final amount = _fareForCoachType(fare, coachType);
      if (amount == 0) return 'Select class';
      return '₹${amount.toStringAsFixed(0)} / seat';
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: kBackground,
        body: FutureBuilder<ScheduleDetail>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingView();
            }
            if (snapshot.hasError) {
              return _ErrorView(
                error: snapshot.error.toString(),
                onRetry: () => setState(() {
                  repo = ScheduleRepository();
                  _future = repo.getSchedule(widget.scheduleId, widget.srcStationId, widget.dstStationId,);
                }),
              );
            }
            final detail = snapshot.data!;
            return _buildContent(detail as ScheduleDetail);
          },
        ),
      );
    }

    Widget _buildContent(ScheduleDetail detail) {
      final selectedCoach = _selectedCoachId != null
          ? detail.coaches.firstWhere((c) => c.id == _selectedCoachId,
          orElse: () => detail.coaches.first)
          : null;

      final totalFare = _selectedSeatIds.length *
          _fareForCoachType(detail.fareOptions, _selectedCoachType);

      return Column(
        children: [
          _buildHeader(context, detail),

          Container(
            color: kCardBg,
            child: TabBar(
              controller: _tabController,
              labelColor: kPrimary,
              unselectedLabelColor: kTextMuted,
              indicatorColor: kPrimary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: "Coaches"),
                Tab(text: "Seats"),
                Tab(text: "Stops"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CoachTab(
                  coaches: detail.coaches,
                  availability: detail.availability,
                  fareOptions: detail.fareOptions,
                  selectedCoachId: _selectedCoachId,
                  onCoachSelected: (coach) {
                    setState(() {
                      _selectedCoachId = coach.id;
                      _selectedCoachType = coach.coachType;
                      _selectedSeatIds.clear();
                    });
                    _tabController.animateTo(1);
                  },
                ),
                _SeatTab(
                  coach: selectedCoach,
                  unavailableSeatIds: detail.seatMap.unavailableSeatIds,
                  selectedSeatIds: _selectedSeatIds,
                  onSeatToggled: (seatId) {
                    setState(() {
                      if (_selectedSeatIds.contains(seatId)) {
                        _selectedSeatIds.remove(seatId);
                      } else {
                        _selectedSeatIds.add(seatId);
                      }
                    });
                  },
                ),
                _StopsTab(stops: detail.stops),
              ],
            ),
          ),

          _BottomBar(
            selectedCount: _selectedSeatIds.length,
            totalFare: totalFare,
            fareLabel: _fareLabel(detail.fareOptions, _selectedCoachType),
            onBook: _selectedSeatIds.isNotEmpty
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassengerDetailsScreen(
                    seatCount: _selectedSeatIds.length,
                    scheduleId: widget.scheduleId,
                    srcStationId: widget.srcStationId,
                    dstStationId: widget.dstStationId,
                    srcStationName: widget.srcStationName,
                    dstStationName: widget.dstStationName,
                    travelDate: widget.travelDate,
                    coachId: _selectedCoachId!,
                    coachType: _selectedCoachType!,
                    selectedSeatIds: _selectedSeatIds,
                    totalFare: totalFare,
                  ),
                ),
              );
            }
                : null,
          ),
        ],
      );
    }

    Widget _buildHeader(BuildContext context, ScheduleDetail detail) {
      final info = detail.schedule;
      String departureTime = '';
      String arrivalTime = '';

      if (detail.stops.isNotEmpty) {
        final firstStop = detail.stops.first;
        final lastStop = detail.stops.last;
        departureTime = firstStop.formattedDeparture;
        arrivalTime = lastStop.formattedArrival;
      }

      return Container(
        decoration: const BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.train.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '#${info.train.trainNumber} · ${info.train.trainType}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        info.status[0].toUpperCase() +
                            info.status.substring(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(16),
                    border:
                    Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            departureTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            widget.srcStationName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                      height: 1.5,
                                      color:
                                      Colors.white.withOpacity(0.4)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  child: Icon(Icons.train_rounded,
                                      color:
                                      Colors.white.withOpacity(0.9),
                                      size: 16),
                                ),
                                Expanded(
                                  child: Container(
                                      height: 1.5,
                                      color:
                                      Colors.white.withOpacity(0.4)),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            arrivalTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            widget.dstStationName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.white60, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      _formatDate(widget.travelDate),
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }


  class _CoachTab extends StatelessWidget {
    final List<Coach> coaches;
    final Availability availability;
    final FareOptions fareOptions;
    final String? selectedCoachId;
    final ValueChanged<Coach> onCoachSelected;

    const _CoachTab({
      required this.coaches,
      required this.availability,
      required this.fareOptions,
      required this.selectedCoachId,
      required this.onCoachSelected,
    });

    int _availableForType(String coachType) {
      switch (coachType) {
        case '1ac':
          return availability.coachTypeAvailability.oneAc.availableSeats;
        case '2ac':
          return availability.coachTypeAvailability.twoAc.availableSeats;
        case 'sleeper':
          return availability.coachTypeAvailability.sleeper.availableSeats;
        default:
          return 0;
      }
    }

    double _fareForType(String coachType) {
      switch (coachType) {
        case '1ac':
          return double.tryParse(fareOptions.oneAc?.farePerSeat ?? '0') ?? 0;
        case '2ac':
          return double.tryParse(fareOptions.twoAc?.farePerSeat ?? '0') ?? 0;
        case 'sleeper':
          return double.tryParse(fareOptions.sleeper?.farePerSeat ?? '0') ?? 0;
        default:
          return 0;
      }
    }

    @override
    Widget build(BuildContext context) {
      final Map<String, List<Coach>> grouped = {};
      for (final c in coaches) {
        grouped.putIfAbsent(c.coachType, () => []).add(c);
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          const _SectionHeader(label: "Select Coach Class"),
          const SizedBox(height: 12),
          ...grouped.entries.map((entry) {
            final coachType = entry.key;
            final coachList = entry.value;
            final available = _availableForType(coachType);
            final fare = _fareForType(coachType);

            return _CoachClassCard(
              coachType: coachType,
              coaches: coachList,
              availableSeats: available,
              farePerSeat: fare,
              selectedCoachId: selectedCoachId,
              onCoachSelected: onCoachSelected,
            );
          }),
        ],
      );
    }
  }

  class _CoachClassCard extends StatelessWidget {
    final String coachType;
    final List<Coach> coaches;
    final int availableSeats;
    final double farePerSeat;
    final String? selectedCoachId;
    final ValueChanged<Coach> onCoachSelected;

    const _CoachClassCard({
      required this.coachType,
      required this.coaches,
      required this.availableSeats,
      required this.farePerSeat,
      required this.selectedCoachId,
      required this.onCoachSelected,
    });

    String get _typeLabel {
      switch (coachType) {
        case 'one_ac':
          return 'First AC (1A)';
        case 'two_ac':
          return 'Second AC (2A)';
        case 'sleeper':
          return 'Sleeper (SL)';
        default:
          return coachType;
      }
    }

    IconData get _typeIcon {
      switch (coachType) {
        case 'one_ac':
          return Icons.star_rounded;
        case 'two_ac':
          return Icons.airline_seat_recline_extra_rounded;
        case 'sleeper':
          return Icons.airline_seat_flat_rounded;
        default:
          return Icons.train;
      }
    }

    Color get _typeColor {
      switch (coachType) {
        case 'one_ac':
          return const Color(0xFFD97706);
        case 'two_ac':
          return kPrimary;
        case 'sleeper':
          return kSuccess;
        default:
          return kPrimary;
      }
    }

    @override
    Widget build(BuildContext context) {
      final isAnySelected = coaches.any((c) => c.id == selectedCoachId);

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isAnySelected ? kPrimary : Colors.transparent,
            width: 2,
          ),
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_typeIcon, color: _typeColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _typeLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: kTextDark,
                          ),
                        ),
                        Text(
                          '$availableSeats seats available',
                          style: TextStyle(
                            color: availableSeats > 0
                                ? kSuccess
                                : kDanger,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${farePerSeat.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: kTextDark,
                        ),
                      ),
                      const Text(
                        'per seat',
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
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: coaches
                          .map((coach) => _CoachChip(
                        coach: coach,
                        isSelected: coach.id == selectedCoachId,
                        onTap: () => onCoachSelected(coach),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  class _CoachChip extends StatelessWidget {
    final Coach coach;
    final bool isSelected;
    final VoidCallback onTap;

    const _CoachChip({
      required this.coach,
      required this.isSelected,
      required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? kPrimary : const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimary : const Color(0xFFD1D9F0),
            ),
          ),
          child: Text(
            coach.coachNumber,
            style: TextStyle(
              color: isSelected ? Colors.white : kTextDark,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      );
    }
  }


  class _SeatTab extends StatelessWidget {
    final Coach? coach;
    final List<String> unavailableSeatIds;
    final Set<String> selectedSeatIds;
    final ValueChanged<String> onSeatToggled;

    const _SeatTab({
      required this.coach,
      required this.unavailableSeatIds,
      required this.selectedSeatIds,
      required this.onSeatToggled,
    });

    @override
    Widget build(BuildContext context) {
      if (coach == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.airline_seat_recline_normal_rounded,
                  size: 52, color: kTextMuted.withOpacity(0.4)),
              const SizedBox(height: 16),
              const Text(
                "Select a coach first",
                style: TextStyle(
                    color: kTextMuted,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                "Go to Coaches tab to pick a coach",
                style: TextStyle(color: kTextMuted, fontSize: 13),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kPrimary.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.train_rounded, color: kPrimary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Coach ${coach!.coachNumber} · ${coach!.displayType}',
                  style: const TextStyle(
                    color: kPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${coach!.totalSeats} seats',
                  style: const TextStyle(color: kTextMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              _LegendDot(color: const Color(0xFFEEF2FF), label: "Available"),
              const SizedBox(width: 16),
              _LegendDot(color: kPrimary, label: "Selected"),
              const SizedBox(width: 16),
              _LegendDot(color: Colors.grey.shade300, label: "Booked"),
            ],
          ),
          const SizedBox(height: 16),

          const _SectionHeader(label: "Select Seats"),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: coach!.seats.length,
            itemBuilder: (context, index) {
              final seat = coach!.seats[index];
              final isUnavailable =
                  unavailableSeatIds.contains(seat.id) || !seat.isActive;
              final isSelected = selectedSeatIds.contains(seat.id);

              return _SeatTile(
                seat: seat,
                isUnavailable: isUnavailable,
                isSelected: isSelected,
                onTap: isUnavailable
                    ? null
                    : () => onSeatToggled(seat.id),
              );
            },
          ),
        ],
      );
    }
  }

  class _SeatTile extends StatelessWidget {
    final Seat seat;
    final bool isUnavailable;
    final bool isSelected;
    final VoidCallback? onTap;

    const _SeatTile({
      required this.seat,
      required this.isUnavailable,
      required this.isSelected,
      this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      Color bg;
      Color textColor;
      Color border;

      if (isUnavailable) {
        bg = Colors.grey.shade200;
        textColor = Colors.grey.shade400;
        border = Colors.grey.shade200;
      } else if (isSelected) {
        bg = kPrimary;
        textColor = Colors.white;
        border = kPrimary;
      } else {
        bg = const Color(0xFFEEF2FF);
        textColor = kTextDark;
        border = const Color(0xFFD1D9F0);
      }

      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                seat.seatNumber,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                seat.seatType,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white70
                      : (isUnavailable
                      ? Colors.grey.shade400
                      : kTextMuted),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  class _LegendDot extends StatelessWidget {
    final Color color;
    final String label;

    const _LegendDot({required this.color, required this.label});

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(color: kTextMuted, fontSize: 12)),
        ],
      );
    }
  }

  class _StopsTab extends StatelessWidget {
    final List<Stop> stops;
    const _StopsTab({required this.stops});

    @override
    Widget build(BuildContext context) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          const _SectionHeader(label: "Train Route"),
          const SizedBox(height: 16),
          ...List.generate(stops.length, (index) {
            final stop = stops[index];
            final isFirst = index == 0;
            final isLast = index == stops.length - 1;
            return _StopRow(
              stop: stop,
              isFirst: isFirst,
              isLast: isLast,
            );
          }),
        ],
      );
    }
  }

  class _StopRow extends StatelessWidget {
    final Stop stop;
    final bool isFirst;
    final bool isLast;

    const _StopRow({
      required this.stop,
      required this.isFirst,
      required this.isLast,
    });

    @override
    Widget build(BuildContext context) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  if (!isFirst)
                    Container(
                      width: 2,
                      height: 16,
                      color: kPrimary.withOpacity(0.3),
                    )
                  else
                    const SizedBox(height: 16),

                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: (isFirst || isLast) ? kPrimary : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimary, width: 2),
                    ),
                  ),

                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: kPrimary.withOpacity(0.3),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: (isFirst || isLast)
                          ? kPrimary.withOpacity(0.3)
                          : Colors.grey.shade100,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimary.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              stop.station.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: (isFirst || isLast)
                                    ? kPrimary
                                    : kTextDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              stop.station.code,
                              style: const TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (!isFirst) ...[
                            _TimeLabel(
                                label: "Arr",
                                time: stop.formattedArrival),
                            const SizedBox(width: 16),
                          ],
                          if (!isLast)
                            _TimeLabel(
                                label: "Dep",
                                time: stop.formattedDeparture),
                          const Spacer(),
                          if (stop.distanceFromOriginKm > 0)
                            Row(
                              children: [
                                Icon(Icons.route_outlined,
                                    size: 12,
                                    color: kTextMuted.withOpacity(0.6)),
                                const SizedBox(width: 3),
                                Text(
                                  '${stop.distanceFromOriginKm.toInt()} km',
                                  style: const TextStyle(
                                      color: kTextMuted, fontSize: 11),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  class _TimeLabel extends StatelessWidget {
    final String label;
    final String time;
    const _TimeLabel({required this.label, required this.time});

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: kTextMuted, fontSize: 11),
          ),
          Text(
            time,
            style: const TextStyle(
              color: kTextDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }

  class _BottomBar extends StatelessWidget {
    final int selectedCount;
    final double totalFare;
    final String fareLabel;
    final VoidCallback? onBook;

    const _BottomBar({
      required this.selectedCount,
      required this.totalFare,
      required this.fareLabel,
      required this.onBook,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
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
                    selectedCount > 0
                        ? '₹${totalFare.toStringAsFixed(0)} total'
                        : fareLabel,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: selectedCount > 0 ? kTextDark : kTextMuted,
                    ),
                  ),
                  Text(
                    selectedCount > 0
                        ? '$selectedCount seat${selectedCount > 1 ? 's' : ''} selected'
                        : 'No seats selected',
                    style: const TextStyle(color: kTextMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Book button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  onBook != null ? kPrimary : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  class _SectionHeader extends StatelessWidget {
    final String label;
    const _SectionHeader({required this.label});

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: kTextDark,
            ),
          ),
        ],
      );
    }
  }

  class _LoadingView extends StatelessWidget {
    const _LoadingView();

    @override
    Widget build(BuildContext context) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: kPrimary),
              SizedBox(height: 16),
              Text("Loading train details...",
                  style: TextStyle(color: kTextMuted)),
            ],
          ),
        ),
      );
    }
  }

  class _ErrorView extends StatelessWidget {
    final String error;
    final VoidCallback onRetry;

    const _ErrorView({required this.error, required this.onRetry});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 52, color: kTextMuted),
                const SizedBox(height: 16),
                const Text("Something went wrong",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: kTextDark)),
                const SizedBox(height: 8),
                Text(error,
                    style: const TextStyle(color: kTextMuted, fontSize: 13),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
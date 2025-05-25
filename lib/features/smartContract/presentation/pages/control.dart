import 'dart:async';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Control extends ConsumerStatefulWidget {
  const Control({super.key});

  @override
  ConsumerState<Control> createState() => _ControlState();
}

class _ControlState extends ConsumerState<Control> {
  DateTime? startTime;
  DateTime? endTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTime = ref.watch(contractProvider.notifier).startTime();
      endTime = ref.watch(contractProvider.notifier).endTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration? d) {
    if (d == null) return "--:--:--";
    if (d.isNegative) return "00:00:00";

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  Duration? timeUntil(DateTime? targetTime) {
    if (targetTime == null) return null;
    return targetTime.difference(DateTime.now());
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Not set";
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isVoting = startTime != null &&
        endTime != null &&
        now.isAfter(startTime!) &&
        now.isBefore(endTime!);
    final hasNotStarted = startTime != null && now.isBefore(startTime!);
    final userDetail = ref.read(authStateProvider.notifier).getUserDetail();
    bool currentState = ref.read(contractProvider.notifier).isVotingPaused();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Control"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => ref.read(contractProvider.notifier).fatchAllData(
                userDetail != null ? userDetail['fayda_no'] : 0000),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh data',
          )
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeCard(
                            title: 'Time Until Start',
                            duration: timeUntil(startTime),
                            isActive: hasNotStarted,
                          ),
                          const SizedBox(width: 16),
                          _buildTimeCard(
                            title: 'Time Remaining',
                            duration: timeUntil(endTime),
                            isActive: isVoting,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Election Schedule",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTimeRow("Start:", _formatDateTime(startTime)),
                            const SizedBox(height: 8),
                            _buildTimeRow("End:", _formatDateTime(endTime)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isVoting
                            ? Colors.green.withOpacity(0.1)
                            : hasNotStarted
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isVoting
                              ? Colors.green
                              : hasNotStarted
                                  ? Colors.blue
                                  : Colors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isVoting
                                ? Icons.check_circle
                                : hasNotStarted
                                    ? Icons.access_time
                                    : Icons.error,
                            color: isVoting
                                ? Colors.green
                                : hasNotStarted
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isVoting
                                ? "Voting in Progress"
                                : startTime == null || endTime == null
                                    ? "Please set both start and end times"
                                    : hasNotStarted
                                        ? "Voting will start soon"
                                        : "Voting has ended",
                            style: TextStyle(
                              color: isVoting
                                  ? Colors.green
                                  : hasNotStarted
                                      ? Colors.blue
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  currentState
                                      ? "Vote Paused"
                                      : "Vote Not Paused",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required Duration? duration,
    required bool isActive,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: isActive ? Colors.indigo.shade50 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: isActive ? Colors.indigo : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formatDuration(duration),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.indigo : Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: value == "Not set" ? Colors.grey : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

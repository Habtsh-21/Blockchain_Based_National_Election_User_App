import 'dart:async';
import 'package:blockchain_based_national_election_user_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Vote extends ConsumerStatefulWidget {
  const Vote({super.key});

  @override
  ConsumerState<Vote> createState() => _ControlState();
}

class _ControlState extends ConsumerState<Vote> {
  DateTime? startTime;
  DateTime? endTime;
  late Timer _timer;
  final user = Supabase.instance.client.auth.currentUser;
  String? votedParty;
  ContractProviderState? _previousState;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
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
    final height = MediaQuery.of(context).size.height;

    startTime = ref.watch(contractProvider.notifier).startTime();
    endTime = ref.watch(contractProvider.notifier).endTime();
    final hasNotStarted = startTime != null && now.isBefore(startTime!);
    final userDetail = ref.read(authStateProvider.notifier).getUserDetail();
    int faydaNo = userDetail != null
        ? userDetail['fayda_no']
        : 0000; //if user detail is null send a random value it return false vote value (user hasn't vote)
    bool isVotingPaused = ref.read(contractProvider.notifier).isVotingPaused();
    bool hasUserVoted = ref.read(contractProvider.notifier).hasUserVoted();
    final contractState = ref.watch(contractProvider);
    final partyList = ref.read(contractProvider.notifier).getParties();
    final bool shouldDisable =
        !isVoting || userDetail == null || isVotingPaused || hasUserVoted;

    if (partyList == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(contractProvider.notifier).fatchAllData(faydaNo);
      });
      return const Scaffold(
        body: Center(
          child: Text('parties is not loaded'),
        ),
      );
    }

    if (_previousState != contractState && contractState is VotedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success!',
          textColor: Colors.black,
          text: 'trxHash:${contractState.message}',
          borderRadius: 0,
          barrierColor: Colors.black.withOpacity(0.2),
        );
        ref.read(contractProvider.notifier).resetState();
      });
    }
    if (_previousState != contractState && contractState is VoteFailureState) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'error!',
          textColor: Colors.black,
          text: '${contractState.message}',
          borderRadius: 0,
          barrierColor: Colors.black.withOpacity(0.2),
        );
        ref.read(contractProvider.notifier).resetState();
      });
    }
    _previousState = contractState;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vote"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(contractProvider.notifier).fatchAllData(faydaNo),
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
                      color: shouldDisable
                          ? Colors.grey.shade200
                          : Colors.indigo.shade50,
                      child: AbsorbPointer(
                        absorbing: shouldDisable,
                        child: Opacity(
                          opacity: shouldDisable ? 0.5 : 1.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Vote",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Select Party',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: votedParty,
                                  items: partyList.map((party) {
                                    return DropdownMenuItem<String>(
                                      value: party.partyId.toString(),
                                      child: Text(party.partyName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      votedParty = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a Party';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: height * 0.055,
                                  child: GradientButton(
                                    text: Text(
                                      'Vote',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPress: shouldDisable
                                        ? () {}
                                        : () {
                                            if (votedParty == null) return;
                                            int? votedPartyId =
                                                int.tryParse(votedParty!);
                                            print(votedPartyId);
                                            if (votedPartyId != null) {
                                              ref
                                                  .read(
                                                      contractProvider.notifier)
                                                  .vote(
                                                    userDetail['fayda_no'],
                                                    votedPartyId,
                                                    userDetail['state_Id'],
                                                  );
                                            }
                                          },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (contractState is VoteFailureState)
                                  Text(
                                    contractState.message,
                                    style: const TextStyle(color: Colors.red),
                                  )
                              ],
                            ),
                          ),
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
                                    ? "Please set start and end times"
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                                  isVotingPaused
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
}

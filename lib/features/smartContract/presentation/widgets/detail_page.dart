import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerStatefulWidget {
  final PartyModel party;

  const DetailPage({super.key, required this.party});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.party.partyName),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPartyHeader(context),
            const SizedBox(height: 24),
            _buildVoteCard(
              title: 'Total Votes',
              value: widget.party.votes.toString(),
              icon: Icons.people_alt_outlined,
            ),
            const SizedBox(height: 16),
            _buildStateVotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyHeader(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Hero(
              tag: 'partySymbol${widget.party.partyId}',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.party.partySymbol,
                    placeholder: (context, url) => Image.asset(
                        'assets/images/placeholder.png',
                        width: 50,
                        height: 50),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 50),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.party.partyName,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Party ID: ${widget.party.partyId}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStateVotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State-wise Votes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.party.stateVotes.entries
            .map((entry) => _buildStateVoteItem(entry.key, entry.value))
            .toList(),
      ],
    );
  }

  Widget _buildStateVoteItem(int stateId, int votes) {
    final stateList = ref.read(contractProvider.notifier).getStates();
    final state = stateList!.firstWhere(
      (state) => state.stateId == stateId,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                stateId.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.stateName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: widget.party.votes == 0
                      ? 0.0
                      : votes / widget.party.votes,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            votes.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

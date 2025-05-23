import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/components/live_auction_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class MyLiveAuctionsWidget extends StatefulWidget {
  const MyLiveAuctionsWidget({super.key});

  static String routeName = 'MyLiveAuctions';
  static String routePath = '/myLiveAuctions';

  @override
  State<MyLiveAuctionsWidget> createState() => _MyLiveAuctionsWidgetState();
}

class _MyLiveAuctionsWidgetState extends State<MyLiveAuctionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        title: Text(
          'My Live Auctions',
          style: FlutterFlowTheme.of(context).titleMedium,
        ),
      ),
      body: StreamBuilder<List<LiveAuctionRecord>>(
        stream: queryLiveAuctionRecord(
          parent: null,
          limit: null,
          startAfter: null,
          singleRecord: false,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            );
          }

          final auctions = snapshot.data!;

          if (auctions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.live_tv,
                    size: 64,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Live Auctions',
                    style: FlutterFlowTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a live auction from your posts',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: auctions.length,
            itemBuilder: (context, index) {
              final auction = auctions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveAuctionWidget(
                          auctionId: auction.reference!.id,
                          isOwner: true,
                          postImage: auction.postImage ?? '',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                auction.postImage ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    auction.postTitle ?? '',
                                    style: FlutterFlowTheme.of(context).titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Current Bid: \$${auction.currentBid?.toStringAsFixed(2) ?? "0.00"}',
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bidders: ${auction.bidders?.length ?? 0}',
                                    style: FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ],
                        ),
                        if (auction.currentBidderName != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(auction.currentBidderPic ?? ''),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Highest bidder: ${auction.currentBidderName}',
                                style: FlutterFlowTheme.of(context).bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 
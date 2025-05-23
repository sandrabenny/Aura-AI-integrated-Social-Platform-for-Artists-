import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/gemini_service.dart';

class ChatBotMessage {
  final String text;
  final bool isBot;
  final List<String>? quickReplies;

  ChatBotMessage({
    required this.text,
    required this.isBot,
    this.quickReplies,
  });
}

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({super.key});

  @override
  _ChatBotWidgetState createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatBotMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isChatOpen = false;
  Offset _chatPosition = const Offset(0, 0);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'Hello! 👋 I\'m AURA, your AI assistant. How can I help you today?',
      quickReplies: [
        'Explore Art',
        'Sell Artwork',
        'Artist Community',
        'Support',
        'About AURA',
      ],
    );
  }

  void _addBotMessage(String message, {List<String>? quickReplies}) {
    setState(() {
      _messages.add(ChatBotMessage(
        text: message,
        isBot: true,
        quickReplies: quickReplies,
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatBotMessage(text: message, isBot: false));
    });
    _scrollToBottom();
    _handleUserMessage(message);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserMessage(String message) async {
    setState(() {
      _messages.add(ChatBotMessage(
        text: '...',
        isBot: true,
      ));
    });

    try {
      String response;
      List<String>? quickReplies;

      // Handle quick reply menu options
      switch (message.toLowerCase()) {
        case 'explore art':
          response = 'Let me help you discover amazing artworks:\n\n'
              '• Browse by Category\n'
              '• Featured Artists\n'
              '• Latest Artworks\n'
              '• Trending Now\n'
              '• Art Collections\n\n'
              'What interests you?';
          quickReplies = [
            'Browse Categories',
            'Featured Artists',
            'Latest Art',
            'Back to Menu'
          ];
          break;

        case 'back to menu':
          response = 'What else can I help you with?';
          quickReplies = [
            'Explore Art',
            'Sell Artwork',
            'Artist Community',
            'Support',
            'About AURA',
          ];
          break;

        default:
          // Use Gemini for natural conversation
          try {
            response = await GeminiService.generateResponse(message);
            
            // Add contextual quick replies based on the response content
            if (response.toLowerCase().contains('artwork') || 
                response.toLowerCase().contains('artist')) {
              quickReplies = [
                'Tell me more',
                'Get insights',
                'Related artists',
                'Back to Menu'
              ];
            } else if (response.toLowerCase().contains('bid') || 
                      response.toLowerCase().contains('auction')) {
              quickReplies = [
                'Bidding tips',
                'Market value',
                'Similar items',
                'Back to Menu'
              ];
            } else if (response.toLowerCase().contains('style') || 
                      response.toLowerCase().contains('technique')) {
              quickReplies = [
                'More details',
                'Similar styles',
                'Art history',
                'Back to Menu'
              ];
            } else {
              quickReplies = [
                'Explore Art',
                'Sell Artwork',
                'Artist Community',
                'Support',
                'About AURA',
              ];
            }
          } catch (e) {
            print('Error in chatbot: $e');
            response = 'I apologize, but I\'m having trouble processing your request. Please try again or choose from these options:';
            quickReplies = [
              'Explore Art',
              'Sell Artwork',
              'Artist Community',
              'Support',
              'About AURA',
            ];
          }
      }

      setState(() {
        _messages.removeLast(); // Remove typing indicator
      });

      _addBotMessage(response, quickReplies: quickReplies);
    } catch (e) {
      print('Critical error in chatbot: $e');
      setState(() {
        _messages.removeLast(); // Remove typing indicator
        _addBotMessage(
          'I apologize, but I\'m experiencing technical difficulties. Please try again later or choose from these options:',
          quickReplies: [
            'Explore Art',
            'Sell Artwork',
            'Artist Community',
            'Support',
            'About AURA',
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isChatOpen)
          Positioned(
            left: _chatPosition.dx,
            top: _chatPosition.dy,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isDragging = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _chatPosition += details.delta;
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
              },
              child: Container(
                width: 320,
                height: 500,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).tertiary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.auto_awesome,
                              color: FlutterFlowTheme.of(context).tertiary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AURA Assistant',
                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'AI Powered',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() => _isChatOpen = false),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Column(
                            crossAxisAlignment: message.isBot
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: message.isBot
                                      ? FlutterFlowTheme.of(context).primaryBackground
                                      : FlutterFlowTheme.of(context).tertiary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  message.text,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Outfit',
                                    color: message.isBot
                                        ? FlutterFlowTheme.of(context).primaryText
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              if (message.quickReplies != null)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: message.quickReplies!.map((reply) {
                                    return InkWell(
                                      onTap: () => _addUserMessage(reply),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).tertiary,
                                          ),
                                        ),
                                        child: Text(
                                          reply,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).tertiary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  _addUserMessage(value);
                                  _messageController.clear();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send),
                            color: FlutterFlowTheme.of(context).tertiary,
                            onPressed: () {
                              if (_messageController.text.trim().isNotEmpty) {
                                _addUserMessage(_messageController.text);
                                _messageController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (!_isChatOpen)
          Positioned(
            right: 16.0,
            bottom: 80.0,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() => _isDragging = true);
              },
              onPanUpdate: (details) {
                if (_isDragging) {
                  setState(() {
                    _chatPosition += details.delta;
                  });
                }
              },
              onPanEnd: (details) {
                setState(() => _isDragging = false);
              },
              child: Transform.translate(
                offset: _chatPosition,
                child: Column(
                  children: [
                    if (!_isChatOpen)
                      FloatingActionButton(
                        backgroundColor: FlutterFlowTheme.of(context).tertiary,
                        onPressed: () => setState(() => _isChatOpen = true),
                        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 
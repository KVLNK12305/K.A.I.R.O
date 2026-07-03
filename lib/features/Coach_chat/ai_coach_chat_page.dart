import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/chat_message.dart';
import '../../core/services/ai_service.dart';
import '../../core/constants/ai_prompts.dart';

class AiCoachChatPage extends StatefulWidget {
  const AiCoachChatPage({super.key});

  @override
  State<AiCoachChatPage> createState() => _AiCoachChatPageState();
}

class _AiCoachChatPageState extends State<AiCoachChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiService _aiService = AiService();
  bool _isLoading = false;
  bool _isHistoryLoaded = false;

  List<ChatSession> _sessions = [];
  String? _currentSessionId;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // ─── Persistence ──────────────────────────────────────────────────

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJsonStr = prefs.getString('kairo_chat_sessions');

    if (sessionsJsonStr != null && sessionsJsonStr.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(sessionsJsonStr);
        final loadedSessions = decoded
            .map((item) => ChatSession.fromJson(item as Map<String, dynamic>))
            .toList();
        if (loadedSessions.isNotEmpty && mounted) {
          setState(() {
            _sessions = loadedSessions;
            _currentSessionId = _sessions.first.id;
            _messages.clear();
            _messages.addAll(_sessions.first.messages);
            _isHistoryLoaded = true;
          });
          _scrollToBottom();
          return;
        }
      } catch (e) {
        debugPrint('Error loading chat sessions: $e');
      }
    }

    // Fallback: migrate old single-session format
    final oldJsonStr = prefs.getString('kairo_chat_history');
    List<ChatMessage> initialMsgs = [
      ChatMessage("I am K.A.I.R.O — your second brain and discipline coach. How shall we improve today?", false),
    ];
    if (oldJsonStr != null && oldJsonStr.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(oldJsonStr);
        final loaded = decoded
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();
        if (loaded.isNotEmpty) initialMsgs = loaded;
      } catch (_) {}
      // Clean up old key after migration
      await prefs.remove('kairo_chat_history');
    }

    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: initialMsgs.length > 1 ? "PREVIOUS SESSION" : "WELCOME SESSION",
      updatedAt: DateTime.now(),
      messages: initialMsgs,
    );

    if (mounted) {
      setState(() {
        _sessions = [newSession];
        _currentSessionId = newSession.id;
        _messages.clear();
        _messages.addAll(newSession.messages);
        _isHistoryLoaded = true;
      });
      _saveHistory();
    }
  }

  Future<void> _saveHistory() async {
    if (_currentSessionId == null) return;
    final prefs = await SharedPreferences.getInstance();

    final index = _sessions.indexWhere((s) => s.id == _currentSessionId);
    if (index != -1) {
      _sessions[index].messages = List.from(_messages);
      _sessions[index].updatedAt = DateTime.now();

      // Auto-title from first user message if title is still a default
      if (_sessions[index].title == "NEW SESSION" ||
          _sessions[index].title == "WELCOME SESSION" ||
          _sessions[index].title == "Untitled Session") {
        final firstUserMsg = _messages.cast<ChatMessage?>().firstWhere(
          (m) => m?.isUser == true,
          orElse: () => null,
        );
        if (firstUserMsg != null) {
          String snippet = firstUserMsg.text.replaceAll('\n', ' ').trim();
          if (snippet.length > 28) snippet = "${snippet.substring(0, 28)}…";
          _sessions[index].title = snippet.toUpperCase();
        }
      }
    }

    _sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final encoded = jsonEncode(_sessions.map((s) => s.toJson()).toList());
    await prefs.setString('kairo_chat_sessions', encoded);
  }

  // ─── Session Management ───────────────────────────────────────────

  void _createNewSession() {
    // Save current session before creating a new one
    _saveHistory();

    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "NEW SESSION",
      updatedAt: DateTime.now(),
      messages: [
        ChatMessage("Fresh coaching session. What challenge or system are we dissecting?", false),
      ],
    );

    setState(() {
      _sessions.insert(0, newSession);
      _currentSessionId = newSession.id;
      _messages.clear();
      _messages.addAll(newSession.messages);
    });
    _saveHistory();
  }

  void _switchSession(String sessionId) {
    if (sessionId == _currentSessionId) return;

    // BUG FIX: Persist current session before switching
    _saveHistory();

    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == sessionId,
      orElse: () => null,
    );
    if (session != null && mounted) {
      setState(() {
        _currentSessionId = session.id;
        _messages.clear();
        _messages.addAll(session.messages);
      });
      _scrollToBottom();
    }
  }

  void _deleteSession(String sessionId) {
    setState(() {
      _sessions.removeWhere((s) => s.id == sessionId);
      if (_sessions.isEmpty) {
        _createNewSession();
        return;
      }
      if (_currentSessionId == sessionId) {
        _currentSessionId = _sessions.first.id;
        _messages.clear();
        _messages.addAll(_sessions.first.messages);
      }
    });
    _saveHistory();
  }

  // ─── Chat ─────────────────────────────────────────────────────────

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;
    final text = _controller.text.trim();
    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(text, true));
      _isLoading = true;
    });
    _scrollToBottom();
    _saveHistory();

    final List<Map<String, String>> apiMessages = [
      {'role': 'system', 'content': AiPrompts.kairoSystemPrompt},
      ..._messages.map((m) => {
        'role': m.isUser ? 'user' : 'assistant',
        'content': m.text,
      }),
    ];

    try {
      final response = await _aiService.chat(apiMessages);

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(response, false));
          _isLoading = false;
        });
        _scrollToBottom();
        _saveHistory();
      }
    } on AiServiceException catch (e) {
      // BUG FIX: Don't save error messages into history — show as snackbar
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message, style: const TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: const Color(0xFF2A0000),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // ─── Scroll ───────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── History Modal ────────────────────────────────────────────────

  void _showHistoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PAST SESSIONS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white, size: 16),
                            label: const Text(
                              "NEW",
                              style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1),
                            ),
                            style: TextButton.styleFrom(backgroundColor: Colors.white10),
                            onPressed: () {
                              Navigator.pop(context);
                              _createNewSession();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 8),

                      // Session List
                      Expanded(
                        child: _sessions.isEmpty
                            ? const Center(
                                child: Text("No saved sessions.", style: TextStyle(color: Colors.white38)),
                              )
                            : ListView.builder(
                                itemCount: _sessions.length,
                                itemBuilder: (context, index) {
                                  final s = _sessions[index];
                                  final isCurrent = s.id == _currentSessionId;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isCurrent ? Colors.white.withAlpha(26) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isCurrent ? Colors.white38 : Colors.white12,
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        _switchSession(s.id);
                                      },
                                      title: Text(
                                        s.title,
                                        style: TextStyle(
                                          color: isCurrent ? Colors.white : Colors.white70,
                                          fontSize: 13,
                                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        "${s.messages.length} msgs • ${_formatDate(s.updatedAt)}",
                                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.white30, size: 18),
                                        onPressed: () {
                                          _deleteSession(s.id);
                                          setModalState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  // ─── Lifecycle ────────────────────────────────────────────────────

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.history, color: Colors.white70, size: 22),
          tooltip: "Past Coaching Sessions",
          onPressed: _showHistoryModal,
        ),
        title: const Text("CRITIQUE COACH", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, color: Colors.white70, size: 20),
            tooltip: "New Coaching Session",
            onPressed: _createNewSession,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
            tooltip: "Delete Current Session",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A1A),
                  title: const Text(
                    "DELETE THIS SESSION?",
                    style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1),
                  ),
                  content: const Text(
                    "This will permanently remove this coaching session.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (_currentSessionId != null) {
                          _deleteSession(_currentSessionId!);
                        }
                      },
                      child: const Text("DELETE", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: !_isHistoryLoaded
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
              ),
            )
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) {
                    final msg = _messages[i];
                    return Align(
                      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: msg.isUser ? Colors.white : Colors.white.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(color: msg.isUser ? Colors.black : Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 96 : 16,
                ),
                color: const Color(0xFF0A0A0A),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "Ask your coach...",
                        hintStyle: TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ]),
              ),
            ]),
    );
  }
}

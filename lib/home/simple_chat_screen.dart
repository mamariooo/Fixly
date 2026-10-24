import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';

/// شات بسيط (للفني والدعم) بردود وهمية.
class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({
    super.key,
    required this.title,
    required this.initialMessages,
    required this.replies,
  });

  final String title;
  final List<String> initialMessages;
  final List<String> replies;

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _Msg {
  final bool mine;
  final String text;
  const _Msg(this.mine, this.text);
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  late final List<_Msg> _msgs =
      widget.initialMessages.map((t) => _Msg(false, t)).toList();
  int _replyIndex = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() => _msgs.add(_Msg(true, t)));
    _ctrl.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final reply = widget.replies[_replyIndex++ % widget.replies.length];
    setState(() => _msgs.add(_Msg(false, reply)));
    _scrollToBottom();
  }

  Widget _bubble(_Msg m) {
    return Align(
      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: m.mine ? kNavy : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: m.mine ? null : Border.all(color: kBorder),
          ),
          child: Text(
            m.text,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: m.mine ? Colors.white : kNavy,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: kBorder, width: 0.8)),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBorder.withValues(alpha: 0.6)),
                      ),
                      child: const Icon(Icons.chevron_left,
                          color: kNavy, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: _scroll,
                padding: const EdgeInsets.all(20),
                itemCount: _msgs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _bubble(_msgs[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 6, 8, 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: kBorder, width: 1.4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        onSubmitted: (_) => _send(),
                        textInputAction: TextInputAction.send,
                        style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          hintStyle:
                              GoogleFonts.manrope(fontSize: 17, color: kGrey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _send,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: kNavy,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.near_me_outlined,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
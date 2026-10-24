import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
import 'ai_chat_screen.dart';
import 'simple_chat_screen.dart';

const Color _cyan = Color(0xFF14B8D6);
const Color _iconBg = Color(0xFFDCE9FF);
const Color _onlineText = Color(0xFF1B4FA8);

/// تاب "Messages" (بيتحط جوه الـ Bottom Nav في HomeScreen)
class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  Widget _chatTile({
    required Widget leading,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: kNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing],
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: kBorder.withValues(alpha: 0.5),
          ),
      ],
    );
  }

  Widget _squareAvatar({required Color bg, required Widget child}) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _circleAvatar({required Widget child}) {
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: _iconBg, shape: BoxShape.circle),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Messages',
            style: GoogleFonts.manrope(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 18),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: kBorder.withValues(alpha: 0.7)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Fixly AI
                _chatTile(
                  leading: _squareAvatar(
                    bg: kNavy,
                    child: const Icon(
                      Icons.auto_awesome,
                      color: _cyan,
                      size: 24,
                    ),
                  ),
                  title: 'Fixly AI',
                  subtitle: 'Tell me what’s wrong and I’ll help.',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _iconBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Online',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _onlineText,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AiChatScreen()),
                    );
                  },
                ),

                // Technician
                _chatTile(
                  leading: _circleAvatar(
                    child: Text(
                      'HA',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _onlineText,
                      ),
                    ),
                  ),
                  title: 'Hossam Ali',
                  subtitle: 'Job finished. Anything else?',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SimpleChatScreen(
                          title: 'Hossam Ali',
                          initialMessages: ['Job finished. Anything else?'],
                          replies: [
                            'Sure, I can come by tomorrow at 5 PM.',
                            'No problem, happy to help!',
                            'Thanks for choosing Fixly.',
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Support
                _chatTile(
                  leading: _circleAvatar(
                    child: const Icon(
                      Icons.help_outline,
                      color: kBlue,
                      size: 28,
                    ),
                  ),
                  title: 'Fixly Support',
                  subtitle: 'Your refund was processed.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SimpleChatScreen(
                          title: 'Fixly Support',
                          initialMessages: ['Your refund was processed.'],
                          replies: [
                            'Is there anything else we can help you with?',
                            'Thanks for your patience, we are checking this now.',
                          ],
                        ),
                      ),
                    );
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

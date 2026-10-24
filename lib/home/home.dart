import 'package:fixly/home/AI_ImageAnalysis.dart';
import 'package:fixly/home/BookingsTab.dart';
import 'package:fixly/home/MessagesTab.dart';
import 'package:fixly/home/ProfileTab.dart';
import 'package:fixly/home/Services_screen.dart';
<<<<<<< HEAD
import 'package:fixly/home/voice_screen.dart';
import 'package:fixly/home/ai_chat_screen.dart';
=======
import 'package:fixly/home/ai_chat_screen.dart';
import 'package:fixly/home/voice_screen.dart';
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';

const Color kCyanLabel = Color(0xFF14B8D6);
const Color kNavyLight = Color(0xFF1C3358);
const Color kIconBg = Color(0xFFDCE9FF);
const Color kGreenBg = Color(0xFFDDF3E6);
const Color kGreenText = Color(0xFF14733A);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
<<<<<<< HEAD
  final List<Widget> _pages = [
    const HomeTab(),
    const ServicesTab(),
    const BookingsTab(),
    const MessagesTab(),
    const ProfileTab(),
  ];
=======
final List<Widget> _pages = [
  const HomeTab(),
  const ServicesTab(),
  const BookingsTab(),
  const MessagesTab(),
  const ProfileTab(),
];
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _pages),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

// ============================================================
// Bottom Navigation
// ============================================================
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.grid_view_rounded, 'Services'),
    (Icons.calendar_today_outlined, 'Bookings'),
    (Icons.chat_bubble_outline, 'Messages'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder, width: 0.8)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              final color = selected ? kNavy : kGrey;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_items[i].$1, color: color, size: 26),
                        const SizedBox(height: 6),
                        Text(
                          _items[i].$2,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
<<<<<<< HEAD
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w600,
=======
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600,
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Home Tab
// ============================================================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(userName: 'Mario', location: 'Minya'),
          const SizedBox(height: 24),
          const _AiCard(),
          const SizedBox(height: 28),
<<<<<<< HEAD
          _SectionTitle(
            title: 'Popular Services',
            action: 'See all',
            onTap: () {},
          ),
          const SizedBox(height: 14),
          const _PopularServices(),
          const SizedBox(height: 28),
          _SectionTitle(
            title: 'Recent Services',
            action: 'History',
            onTap: () {},
          ),
=======
          _SectionTitle(title: 'Popular Services', action: 'See all', onTap: () {
          }),
          const SizedBox(height: 14),
          const _PopularServices(),
          const SizedBox(height: 28),
          _SectionTitle(title: 'Recent Services', action: 'History', onTap: () {}),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
          const SizedBox(height: 14),
          const _RecentServiceCard(
            icon: Icons.water_drop_outlined,
            title: 'Kitchen sink leak',
            subtitle: 'Plumbing · 28 Sep · 280 EGP',
            status: 'Completed',
          ),
          const SizedBox(height: 28),
          const _SectionTitle(title: 'Recommended Technicians'),
          const SizedBox(height: 14),
          const _TechnicianCard(
            initials: 'AH',
            name: 'Ahmed Hassan',
            subtitle: 'AC Specialist · 4.8 · 1.2 km',
            match: '94%',
          ),
        ],
      ),
    );
  }
}

// ---------- Header ----------
class _Header extends StatelessWidget {
  final String userName;
  final String location;

  const _Header({required this.userName, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning, $userName',
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
<<<<<<< HEAD
                  const Icon(
                    Icons.location_on_outlined,
                    color: kGrey,
                    size: 18,
                  ),
=======
                  const Icon(Icons.location_on_outlined, color: kGrey, size: 18),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Your current location · $location',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
                border: Border.all(color: kBorder.withValues(alpha: 0.6)),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: kNavy,
                size: 26,
              ),
=======
                border: Border.all(color: kBorder.withOpacity(0.6)),
              ),
              child: const Icon(Icons.notifications_none,
                  color: kNavy, size: 26),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
            Positioned(
              top: 13,
              right: 14,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5322D),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------- AI Card ----------
<<<<<<< HEAD
class _AiCard extends StatefulWidget {
  const _AiCard();

  @override
  State<_AiCard> createState() => _AiCardState();
}

class _AiCardState extends State<_AiCard> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openChat([String? text]) {
    final t = (text ?? '').trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiChatScreen(initialMessage: t.isEmpty ? null : t),
      ),
    );
    _ctrl.clear();
  }

  Future<void> _openVoice() async {
    final text = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const VoiceScreen()),
    );
    if (text != null && mounted) _openChat(text);
  }

=======
class _AiCard extends StatelessWidget {
  const _AiCard();

>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: kNavyLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: kNavy,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FIXLY AI',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: kCyanLabel,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'What do you need help with?',
            style: GoogleFonts.manrope(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),

          // Input
          Container(
            height: 76,
            padding: const EdgeInsets.only(left: 22, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
<<<<<<< HEAD
                    controller: _ctrl,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _openChat,
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                    style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Describe your problem...',
<<<<<<< HEAD
                      hintStyle: GoogleFonts.manrope(
                        fontSize: 17,
                        color: kGrey,
                      ),
=======
                      hintStyle:
                          GoogleFonts.manrope(fontSize: 17, color: kGrey),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                    ),
                  ),
                ),
                InkWell(
<<<<<<< HEAD
                  onTap: () => _openChat(_ctrl.text),
=======
                  onTap: () {
                    // TODO: send problem description
                  },
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kNavy,
                      borderRadius: BorderRadius.circular(14),
                    ),
<<<<<<< HEAD
                    child: const Icon(
                      Icons.near_me_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
=======
                    child: const Icon(Icons.near_me_outlined,
                        color: Colors.white, size: 24),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
<<<<<<< HEAD
             _actionButton(Icons.mic_none, 'Voice', _openVoice),
              const SizedBox(width: 14),
              _actionButton(Icons.photo_camera_outlined, 'Image', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AiImageAnalysisScreen(),
                  ),
                );
=======
              _actionButton(Icons.mic_none, 'Voice', () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>VoiceScreen()));

              }),
              const SizedBox(width: 14),
              _actionButton(Icons.photo_camera_outlined, 'Image', () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>AiImageAnalysisScreen()));
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Section title ----------
class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const _SectionTitle({required this.title, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: kNavy,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              action!,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kBlue,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------- Icon box ----------
class _IconBox extends StatelessWidget {
  final IconData icon;
  const _IconBox(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: kIconBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: kBlue, size: 28),
    );
  }
}

// ---------- Popular Services ----------
class _PopularServices extends StatelessWidget {
  const _PopularServices();

  static const _services = [
    (Icons.bolt, 'Electrical'),
    (Icons.water_drop_outlined, 'Plumbing'),
    (Icons.ac_unit, 'AC'),
    (Icons.hardware, 'Carpentry'),
    (Icons.format_paint_outlined, 'Painting'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 162,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _services.length,
<<<<<<< HEAD
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServicesTab()),
              );
=======
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
           
           Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesTab()));
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 146,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
<<<<<<< HEAD
                border: Border.all(color: kBorder.withValues(alpha: 0.7)),
=======
                border: Border.all(color: kBorder.withOpacity(0.7)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IconBox(_services[i].$1),
                  const SizedBox(height: 12),
                  Text(
                    _services[i].$2,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------- Status chip ----------
class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: kGreenBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: kGreenText,
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
<<<<<<< HEAD
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: kBorder.withValues(alpha: 0.7)),
);
=======
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: kBorder.withOpacity(0.7)),
    );
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

// ---------- Recent service ----------
class _RecentServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  const _RecentServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: kIconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: kBlue, size: 26),
          ),
          const SizedBox(width: 14),
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
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Chip(status),
        ],
      ),
    );
  }
}

// ---------- Technician card ----------
class _TechnicianCard extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  final String match;

  const _TechnicianCard({
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: kIconBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kNavy,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
<<<<<<< HEAD
                    const Icon(
                      Icons.verified_user_outlined,
                      color: kBlue,
                      size: 20,
                    ),
=======
                    const Icon(Icons.verified_user_outlined,
                        color: kBlue, size: 20),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Chip(match),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

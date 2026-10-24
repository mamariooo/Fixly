import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
import 'package:fixly/core/models/booking.dart';
import 'package:fixly/core/services/booking_store.dart';
import 'simple_chat_screen.dart';
import 'package:fixly/core/services/profile_store.dart';
import 'package:fixly/core/services/notification_store.dart';
import 'package:fixly/main.dart' show appLocale, changeLanguage;

/// هيكل مشترك لصفحات البروفايل: هيدر فيه زرار رجوع + عنوان
class _PageScaffold extends StatelessWidget {
  const _PageScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

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
                      title,
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
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// Service History
// =====================================================
class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  Widget _historyCard(Booking b) {
    final done = b.status == BookingStatus.completed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(b.icon, color: kBlue, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.issue,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${b.service} · ${_date(b.createdAt)}',
                  style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                ),
                if (b.technicianName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Technician: ${b.technicianName}',
                    style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                  ),
                ],
                if (b.rating != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < b.rating! ? Icons.star : Icons.star_border,
                        color: const Color(0xFFF5B301),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (b.price != null) ...[
                Text(
                  '${b.price} EGP',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFFDDF3E6)
                      : const Color(0xFFFDE2E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  b.status.label,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: done
                        ? const Color(0xFF14733A)
                        : const Color(0xFFB42318),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Service History',
      child: ListenableBuilder(
        listenable: BookingStore.instance,
        builder: (context, _) {
          final items = BookingStore.instance.past;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, size: 48, color: kGrey),
                    const SizedBox(height: 12),
                    Text(
                      'No past services yet',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Completed and cancelled bookings will show up here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _historyCard(items[i]),
          );
        },
      ),
    );
  }
}

// =====================================================
// Help & Support
// =====================================================
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<(String, String)> _faqs = [
    (
      'How do I request a technician?',
      'Describe your problem in the AI chat, then tap "Request a technician" under the summary card.',
    ),
    (
      'How can I cancel a booking?',
      'Open Bookings, tap the booking, then "Cancel booking". You can cancel before the technician starts working.',
    ),
    (
      'How do I rate a technician?',
      'When the job is completed, open the booking from the Bookings tab and tap "Rate technician".',
    ),
    (
      'How is the price decided?',
      'The technician enters the final price when the job is finished.',
    ),
    (
      'How do I pay?',
      'For now you pay the technician directly. Online payment is coming soon.',
    ),
  ];

  

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Help & Support',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Frequently asked questions',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 12),
          for (final f in _faqs)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder.withValues(alpha: 0.7)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    f.$1,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.$2,
                      style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SimpleChatScreen(
                      title: 'Fixly Support',
                      initialMessages: ['Hi! How can we help you today?'],
                      replies: [
                        'Thanks for the details. We are checking this now.',
                        'Is there anything else we can help you with?',
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.support_agent),
              label: Text(
                'Chat with support',
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// =====================================================
// Saved Locations
// =====================================================
class SavedLocationsScreen extends StatelessWidget {
  const SavedLocationsScreen({super.key});

  IconData _iconFor(String label) {
    switch (label) {
      case 'Home':
        return Icons.home_outlined;
      case 'Work':
        return Icons.work_outline;
      default:
        return Icons.place_outlined;
    }
  }

  Future<void> _edit(BuildContext context, {SavedAddress? existing}) async {
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    String label = existing?.label ?? 'Home';
    String? error;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(existing == null ? 'Add location' : 'Edit location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                children: ['Home', 'Work', 'Other']
                    .map(
                      (l) => ChoiceChip(
                        label: Text(l),
                        selected: label == l,
                        onSelected: (_) => setLocal(() => label = l),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Street, building, floor, area',
                  errorText: error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (addressCtrl.text.trim().length < 5) {
                  setLocal(() => error = 'Enter a full address');
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;
    final text = addressCtrl.text.trim();
    if (existing == null) {
      ProfileStore.instance.addAddress(label, text);
    } else {
      ProfileStore.instance.updateAddress(existing, label, text);
    }
  }

  Widget _card(BuildContext context, SavedAddress a) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_iconFor(a.label), color: kBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      a.label,
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    if (a.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF3E6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Default',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF14733A),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  a.address,
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'default') ProfileStore.instance.setDefaultAddress(a);
              if (v == 'edit') _edit(context, existing: a);
              if (v == 'delete') ProfileStore.instance.removeAddress(a);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'default', child: Text('Set as default')),
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Saved Locations',
      child: ListenableBuilder(
        listenable: ProfileStore.instance,
        builder: (context, _) {
          final items = ProfileStore.instance.addresses;

          var edgeInsets = const EdgeInsets.all(20);
          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.place_outlined,
                                  size: 48, color: kGrey),
                              const SizedBox(height: 12),
                              Text(
                                'No saved locations',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: kNavy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add your home or work address to book faster.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                    fontSize: 15, color: kGrey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: edgeInsets,
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _card(context, items[i]),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _edit(context),
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add location',
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================
// Payment Methods
// =====================================================
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  Future<void> _addCard(BuildContext context) async {
    final titleCtrl = TextEditingController();
    final last4Ctrl = TextEditingController();
    String? titleError;
    String? last4Error;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Add card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Card name',
                  hintText: 'e.g. My Visa',
                  errorText: titleError,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: last4Ctrl,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Last 4 digits',
                  errorText: last4Error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final t = titleCtrl.text.trim();
                final l = last4Ctrl.text.trim();
                final okLast4 = RegExp(r'^\d{4}$').hasMatch(l);
                if (t.isEmpty || !okLast4) {
                  setLocal(() {
                    titleError = t.isEmpty ? 'Required' : null;
                    last4Error = okLast4 ? null : 'Enter 4 digits';
                  });
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (saved == true) {
      ProfileStore.instance
          .addCard(titleCtrl.text.trim(), last4Ctrl.text.trim());
    }
  }

  Widget _card(PaymentMethod p) {
    var boxDecoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: p.isDefault ? kBlue : kBorder.withValues(alpha: 0.7),
          width: p.isDefault ? 1.6 : 1,
        ),
      );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: boxDecoration,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              p.isCard ? Icons.credit_card : Icons.payments_outlined,
              color: kBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                Text(
                  p.isCard ? '•••• ${p.last4}' : 'Pay the technician directly',
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
          if (p.isDefault)
            Text(
              'Default',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: kBlue,
              ),
            )
          else
            TextButton(
              onPressed: () => ProfileStore.instance.setDefaultPayment(p),
              child: const Text('Set default'),
            ),
          if (p.isCard)
            IconButton(
              onPressed: () => ProfileStore.instance.removePayment(p),
              icon: const Icon(Icons.delete_outline, color: kGrey),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Payment Methods',
      child: ListenableBuilder(
        listenable: ProfileStore.instance,
        builder: (context, _) {
          final items = ProfileStore.instance.payments;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    for (final p in items) ...[
                      _card(p),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Only the last 4 digits are kept. Online payments will '
                      'go through a secure payment provider.',
                      style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _addCard(context),
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add card',
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================
// Favorites
// =====================================================
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Widget _techTile(TechnicianInfo t) {
    final fav = ProfileStore.instance.isFavorite(t.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFDCE9FF),
            child: Text(
              t.name[0],
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: kBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.name,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${t.skill} · ',
                      style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                    ),
                    const Icon(Icons.star,
                        size: 16, color: Color(0xFFF5B301)),
                    Text(
                      ' ${t.rating}',
                      style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ProfileStore.instance.toggleFavorite(t.name),
            icon: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? const Color(0xFFE5484D) : kGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: kGrey,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Favorites',
      child: ListenableBuilder(
        listenable: ProfileStore.instance,
        builder: (context, _) {
          final favs = ProfileStore.instance.favoriteTechnicians;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _label('MY FAVORITES'),
              if (favs.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'No favorites yet. Tap the heart on a technician below.',
                    style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                  ),
                )
              else
                for (final t in favs) _techTile(t),
              const SizedBox(height: 14),
              _label('TECHNICIANS'),
              for (final t in ProfileStore.technicians) _techTile(t),
            ],
          );
        },
      ),
    );
  }
}
  // =====================================================
// Settings
// =====================================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  BoxDecoration get _box => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      );

  TextStyle _title() => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: kNavy,
      );

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // الإشعارات
          ListenableBuilder(
            listenable: NotificationStore.instance,
            builder: (context, _) => Container(
              decoration: _box,
              child: SwitchListTile(
                value: NotificationStore.instance.customerEnabled,
                onChanged: NotificationStore.instance.setCustomerEnabled,
                title: Text('Notifications', style: _title()),
                subtitle: Text(
                  'Updates about your bookings',
                  style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // اللغة
          ValueListenableBuilder(
            valueListenable: appLocale,
            builder: (context, locale, _) => Container(
              padding: const EdgeInsets.all(16),
              decoration: _box,
              child: Row(
                children: [
                  Expanded(child: Text('Language', style: _title())),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'en', label: Text('EN')),
                      ButtonSegment(value: 'ar', label: Text('AR')),
                    ],
                    selected: {locale.languageCode == 'ar' ? 'ar' : 'en'},
                    onSelectionChanged: (s) => changeLanguage(s.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // عن التطبيق
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _box,
            child: Row(
              children: [
                Expanded(child: Text('About Fixly', style: _title())),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

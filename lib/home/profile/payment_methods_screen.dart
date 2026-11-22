import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/profile_store.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/address_dialog.dart';
import 'page_scaffold.dart';

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

    final title = titleCtrl.text.trim();
    final last4 = last4Ctrl.text.trim();
    disposeLater([titleCtrl, last4Ctrl]);

    if (saved == true) {
      ProfileStore.instance.addCard(title, last4);
    }
  }

  Widget _card(PaymentMethod p) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: p.isDefault ? kBlue : kBorder.withValues(alpha: 0.7),
          width: p.isDefault ? 1.6 : 1,
        ),
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
    return PageScaffold(
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

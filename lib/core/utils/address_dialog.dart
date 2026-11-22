import 'package:flutter/material.dart';

/// بيسأل المستخدم عن العنوان. الـ TextEditingController مملوك للـ State
/// بتاع الحوار نفسه وبيتعمله dispose بعد ما الحوار يتقفل بالكامل،
/// فمفيش crash عند "إلغاء" أو "متابعة".

Future<String?> askAddress(
  BuildContext context, {
  String title = 'أين موقع المشكلة؟',
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _AddressDialog(title: title),
  );
}

class _AddressDialog extends StatefulWidget {
  const _AddressDialog({required this.title});
  final String title;

  @override
  State<_AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<_AddressDialog> {
  final _ctrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final t = _ctrl.text.trim();
    if (t.length < 5) {
      setState(() => _error = 'يرجى كتابة عنوان واضح وكامل');
      return;
    }
    Navigator.of(context).pop(t);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _ctrl,
        maxLines: 2,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'الشارع، رقم العمارة، الطابق، والمنطقة',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        TextButton(onPressed: _submit, child: const Text('متابعة')),
      ],
    );
  }
}

/// للحوارات التانية اللي لسه بتستخدم controller خارجي:
/// بيأجل الـ dispose لحد ما أنيميشن قفل الحوار يخلص.
void disposeLater(List<ChangeNotifier> items) {
  Future.delayed(const Duration(milliseconds: 600), () {
    for (final i in items) {
      i.dispose();
    }
  });
}
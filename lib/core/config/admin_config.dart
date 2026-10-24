/// الإيميلات المسموح لها تفتح لوحة الأدمن.
/// ضيفي هنا إيميلاتك وإيميلات زمايلك.
const List<String> kAdminEmails = [
  'demiana@fixly.com',
  'moren@fixly.com',
  'moaz@fixly.com',
  'felobateer@fixly.com',
  'mario@fixly.com',
];

bool isAdminEmail(String email) {
  final e = email.trim().toLowerCase();
  return kAdminEmails.any((a) => a.toLowerCase() == e);
}
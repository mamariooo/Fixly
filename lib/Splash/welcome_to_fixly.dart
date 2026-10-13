

// import 'package:flutter/material.dart';

// class WelcometoFixly extends StatelessWidget {
//   const WelcometoFixly({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("WelcometoFixly")),
//       body: Center(child: Text("WelcometoFixly"),),
//     );
    
//   }
// } 


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixly/main.dart';

// ====== الألوان ======
const kNavy = Color(0xFF0D1F3C);
const kBlue = Color(0xFF2457C5);
const kOuterBg = Color(0xFFE9EEF6);
const kInnerBg = Color(0xFFF7F9FD);
const kGrey = Color(0xFF6B7280);
const kBorder = Color(0xFFE3E8F0);
const kLightBlue = Color(0xFFDCEAFE);

const kLogoPath = 'assets/images/fixly.jpeg';

class WelcometoFixly extends StatelessWidget {
const WelcometoFixly({super.key});

@override
Widget build(BuildContext context) {
return ValueListenableBuilder<Locale>(
valueListenable: appLocale,
builder: (context, locale, child) {
final isAr = locale.languageCode == 'ar';


    String tr(String en, String ar) => isAr ? ar : en;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: kOuterBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kInnerBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== اللوجو واللغة =====
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            kLogoPath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: kLightBlue,
                                child: const Icon(
                                  Icons.home_repair_service,
                                  color: kNavy,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Fixly',
                          style: GoogleFonts.manrope(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: kNavy,
                          ),
                        ),
                        const Spacer(),

                        // زر تغيير اللغة
                        PopupMenuButton<String>(
                          tooltip: tr('Change language', 'تغيير اللغة'),
                          onSelected: changeLanguage,
                          icon: const Icon(
                            Icons.language_rounded,
                            color: kNavy,
                            size: 28,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'en',
                              child: Row(
                                children: [
                                  const Text('🇺🇸'),
                                  const SizedBox(width: 10),
                                  const Text('English'),
                                  if (!isAr) ...[
                                    const Spacer(),
                                    const Icon(
                                      Icons.check,
                                      color: kBlue,
                                      size: 18,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'ar',
                              child: Row(
                                children: [
                                  const Text('🇪🇬'),
                                  const SizedBox(width: 10),
                                  const Text('العربية'),
                                  if (isAr) ...[
                                    const Spacer(),
                                    const Icon(
                                      Icons.check,
                                      color: kBlue,
                                      size: 18,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ===== العنوان =====
                    Text(
                      tr('Welcome to Fixly', 'أهلاً بك في Fixly'),
                      style: GoogleFonts.getFont(
                        isAr ? 'Cairo' : 'Manrope',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      tr(
                        'Choose how you want to use the app.',
                        'اختر الطريقة التي تريد استخدام التطبيق بها.',
                      ),
                      style: GoogleFonts.getFont(
                        isAr ? 'Cairo' : 'Manrope',
                        fontSize: 15,
                        color: kGrey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== كارت العميل =====
                    _RoleCard(
                      isAr: isAr,
                      icon: const Icon(
                        Icons.home_outlined,
                        color: kBlue,
                        size: 26,
                      ),
                      iconBg: kLightBlue,
                      title: tr(
                        'I need a technician',
                        'أحتاج إلى فني',
                      ),
                      subtitle: tr(
                        'Describe a problem and get matched.',
                        'اشرح المشكلة وسنساعدك في العثور على الفني المناسب.',
                      ),
                      primaryButton: _FilledBtn(
                        label: tr(
                          'Continue as customer',
                          'المتابعة كعميل',
                        ),
                        onTap: () {
                          // TODO: الانتقال إلى شاشة العميل
                        },
                        isAr: isAr,
                      ),
                      linkText: tr(
                        'Already have an account? Log in',
                        'لديك حساب بالفعل؟ سجّل الدخول',
                      ),
                      onLinkTap: () {
                        // TODO: تسجيل دخول العميل
                      },
                    ),

                    const SizedBox(height: 16),

                    // ===== كارت الفني =====
                    _RoleCard(
                      isAr: isAr,
                      icon: const Icon(
                        Icons.handyman_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      iconBg: kNavy,
                      title: tr(
                        'I am a technician',
                        'أنا فني',
                      ),
                      subtitle: tr(
                        'Receive jobs and grow your income.',
                        'استقبل طلبات العمل وزد دخلك.',
                      ),
                      primaryButton: _OutlinedBtn(
                        label: tr('Login', 'تسجيل الدخول'),
                        onTap: () {
                          // TODO: تسجيل دخول الفني
                        },
                        isAr: isAr,
                      ),
                      linkText: tr(
                        'New technician? Apply to join',
                        'فني جديد؟ قدّم طلب الانضمام',
                      ),
                      onLinkTap: () {
                        // TODO: التقديم كفني
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  },
);
}
}

// ====== كارت قابل لإعادة الاستخدام ======
class _RoleCard extends StatelessWidget {
final Widget icon;
final Color iconBg;
final String title;
final String subtitle;
final Widget primaryButton;
final String linkText;
final VoidCallback onLinkTap;
final bool isAr;

const _RoleCard({
required this.icon,
required this.iconBg,
required this.title,
required this.subtitle,
required this.primaryButton,
required this.linkText,
required this.onLinkTap,
required this.isAr,
});

@override
Widget build(BuildContext context) {
final font = isAr ? 'Cairo' : 'Manrope';


return Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: kBorder),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    font,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.getFont(
                    font,
                    fontSize: 12,
                    height: 1.5,
                    color: kGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      primaryButton,
      const SizedBox(height: 14),
      Center(
        child: GestureDetector(
          onTap: onLinkTap,
          child: Text(
            linkText,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              font,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kBlue,
            ),
          ),
        ),
      ),
      const SizedBox(height: 6),
    ],
  ),
);

}
}

// ====== الزر الأساسي ======
class _FilledBtn extends StatelessWidget {
final String label;
final VoidCallback onTap;
final bool isAr;

const _FilledBtn({
required this.label,
required this.onTap,
required this.isAr,
});

@override
Widget build(BuildContext context) {
return SizedBox(
width: double.infinity,
height: 54,
child: ElevatedButton(
onPressed: onTap,
style: ElevatedButton.styleFrom(
backgroundColor: kNavy,
foregroundColor: Colors.white,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
),
child: Text(
label,
textAlign: TextAlign.center,
style: GoogleFonts.getFont(
isAr ? 'Cairo' : 'Manrope',
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
),
);
}
}

// ====== الزر الثانوي ======
class _OutlinedBtn extends StatelessWidget {
final String label;
final VoidCallback onTap;
final bool isAr;

const _OutlinedBtn({
required this.label,
required this.onTap,
required this.isAr,
});

@override
Widget build(BuildContext context) {
return SizedBox(
width: double.infinity,
height: 54,
child: OutlinedButton(
onPressed: onTap,
style: OutlinedButton.styleFrom(
foregroundColor: kNavy,
side: const BorderSide(color: kBorder, width: 1.5),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
),
child: Text(
label,
textAlign: TextAlign.center,
style: GoogleFonts.getFont(
isAr ? 'Cairo' : 'Manrope',
fontSize: 15,
fontWeight: FontWeight.w600,
),
),
),
);
}
}

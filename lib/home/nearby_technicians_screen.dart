import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/models/technician_model.dart';
import '../core/services/database_seeder.dart';
import '../core/theme/app_colors.dart';
import '../main.dart';
import 'ai_chat_screen.dart';

class NearbyTechniciansScreen extends StatefulWidget {
  const NearbyTechniciansScreen({
    super.key,
    this.initialCategory,
    this.problemDiagnosis,
  });

  final String? initialCategory;
  final String? problemDiagnosis;

  @override
  State<NearbyTechniciansScreen> createState() =>
      _NearbyTechniciansScreenState();
}

class _NearbyTechniciansScreenState extends State<NearbyTechniciansScreen> {
  List<TechnicianModel> _allTechnicians = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _sortBy = 'ai'; // 'ai', 'distance', 'rating', 'expert'

  final List<(String, String)> _categories = [
    ('All', 'الكل'),
    ('Air Conditioning', 'تكييف'),
    ('Plumbing', 'سباكة'),
    ('Electrical', 'كهرباء'),
    ('Appliances', 'أجهزة منزلية'),
    ('Carpentry', 'نجارة'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    _loadTechnicians();
  }

  Future<void> _loadTechnicians() async {
    final list = await DatabaseSeeder.instance.getTechnicians();
    if (!mounted) return;
    setState(() {
      _allTechnicians = list;
      _isLoading = false;
    });
  }

  List<TechnicianModel> get _filteredTechnicians {
    var list = List<TechnicianModel>.from(_allTechnicians);

    // تصفية حسب التخصص
    if (_selectedCategory != 'All') {
      list = list.where((t) {
        return t.specialty.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // ترتيب
    switch (_sortBy) {
      case 'distance':
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'expert':
        list = list.where((t) => t.isExpert).toList();
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'ai':
      default:
        list.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
        break;
    }

    return list;
  }

  void _showTechnicianDetails(TechnicianModel tech) {
    final isAr = appLocale.value.languageCode == 'ar';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFFDCE9FF),
                    child: Text(
                      tech.name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join(),
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
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
                                tech.name,
                                style: GoogleFonts.manrope(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: kNavy,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF1D5FD8),
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tech.specialty,
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF5B301), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${tech.rating} (${tech.ratingCount} ${isAr ? 'تقييم' : 'reviews'})',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kNavy,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // بطاقة ترشيح الـ AI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFB9D7FE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF1B4FA8),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'ترشيح الذكاء الاصطناعي (${tech.matchPercentage}% توافق)' : 'AI Recommendation (${tech.matchPercentage}% match)',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1B4FA8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tech.matchReason.isNotEmpty
                                ? tech.matchReason
                                : (isAr
                                    ? 'فني موثوق وقريب من موقعك وحاصل على أعلى التقييمات.'
                                    : 'Top-rated nearby certified technician.'),
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: const Color(0xFF1C3358),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isAr ? 'نبذة عن الفني' : 'About Technician',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tech.bio.isNotEmpty
                    ? tech.bio
                    : (isAr ? 'فني معتمد ذو خبرة وكفاءة عالية.' : 'Experienced certified specialist.'),
                style: GoogleFonts.manrope(fontSize: 14, height: 1.4, color: kGrey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'السعر التقديري' : 'Estimated Base Rate',
                        style: GoogleFonts.manrope(fontSize: 12, color: kGrey),
                      ),
                      Text(
                        '~${tech.hourlyRate} ${isAr ? 'ج.م' : 'EGP'}',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F9D63),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'المسافة' : 'Distance',
                        style: GoogleFonts.manrope(fontSize: 12, color: kGrey),
                      ),
                      Text(
                        '${tech.distanceKm} ${isAr ? 'كم' : 'km'}',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kNavy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _requestThisTechnician(tech);
                  },
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  label: Text(
                    isAr ? 'إرسال الطلب لهذا الفني' : 'Request This Technician',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestThisTechnician(TechnicianModel tech) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiChatScreen(
          preSelectedTechnician: tech,
          initialMessage: widget.problemDiagnosis ??
              'أحتاج فني ${tech.specialty} لفحص مشكلة لدي.',
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final selected = _selectedCategory == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        label: Text(label),
        labelStyle: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? Colors.white : kNavy,
        ),
        selectedColor: kNavy,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: selected ? kNavy : kBorder,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (val) {
          setState(() => _selectedCategory = key);
        },
      ),
    );
  }

  Widget _buildSortButton(String key, String label, IconData icon) {
    final selected = _sortBy == key;
    return InkWell(
      onTap: () => setState(() => _sortBy = key),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDCE9FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? const Color(0xFF1B4FA8) : kGrey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? const Color(0xFF1B4FA8) : kGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = appLocale.value.languageCode == 'ar';
    final technicians = _filteredTechnicians;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNavy),
        title: Text(
          isAr ? 'الفنيون القريبون' : 'Nearby Technicians',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: kNavy,
          ),
        ),
      ),
      body: Column(
        children: [
          // شريط التخصصات
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories
                    .map((c) => _buildFilterChip(c.$1, isAr ? c.$2 : c.$1))
                    .toList(),
              ),
            ),
          ),
          // شريط الترتيب
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortButton('ai', isAr ? 'ترشيح AI' : 'AI Match', Icons.auto_awesome),
                  const SizedBox(width: 6),
                  _buildSortButton('distance', isAr ? 'الأقرب مسافة' : 'Closest', Icons.near_me_outlined),
                  const SizedBox(width: 6),
                  _buildSortButton('rating', isAr ? 'الأعلى تقييماً' : 'Top Rated', Icons.star_border),
                  const SizedBox(width: 6),
                  _buildSortButton('expert', isAr ? 'خبراء فقط' : 'Experts Only', Icons.workspace_premium_outlined),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: kBorder.withValues(alpha: 0.6)),

          // قائمة الفنيين
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: kNavy))
                : technicians.isEmpty
                    ? Center(
                        child: Text(
                          isAr ? 'لا يوجد فنيون في هذا التخصص حالياً' : 'No technicians found for this filter',
                          style: GoogleFonts.manrope(fontSize: 16, color: kGrey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: technicians.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, i) {
                          final tech = technicians[i];
                          return _TechnicianItemCard(
                            tech: tech,
                            isAr: isAr,
                            onTap: () => _showTechnicianDetails(tech),
                            onRequest: () => _requestThisTechnician(tech),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _TechnicianItemCard extends StatelessWidget {
  const _TechnicianItemCard({
    required this.tech,
    required this.isAr,
    required this.onTap,
    required this.onRequest,
  });

  final TechnicianModel tech;
  final bool isAr;
  final VoidCallback onTap;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFDCE9FF),
                  child: Text(
                    tech.name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join(),
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              tech.name,
                              style: GoogleFonts.manrope(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: kNavy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF1D5FD8),
                            size: 18,
                          ),
                          if (tech.isExpert) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3D6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isAr ? 'خبير معتمد' : 'Expert',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF8A5300),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${tech.specialty} · ${tech.area}',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFF5B301), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${tech.rating}',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: kNavy,
                            ),
                          ),
                          Text(
                            ' (${tech.ratingCount})',
                            style: GoogleFonts.manrope(fontSize: 12, color: kGrey),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.near_me_outlined, color: kGrey, size: 15),
                          const SizedBox(width: 3),
                          Text(
                            '${tech.distanceKm} ${isAr ? 'كم' : 'km'}',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // نسبة توافق الـ AI
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF6FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${tech.matchPercentage}%',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1B4FA8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // سبب الترشيح
            if (tech.matchReason.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF14B8D6),
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tech.matchReason,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: const Color(0xFF1C3358),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

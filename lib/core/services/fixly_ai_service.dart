import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../config/ai_config.dart';
import '../models/technician_model.dart';

/// نتيجة تشخيص الذكاء الاصطناعي (AI Diagnosis Result)
class AiDiagnosisResult {
  final String
  serviceCategory; // Air Conditioning, Plumbing, Electrical, Appliances, Carpentry, Other
  final String issueSummary; // ملخص المشكلة
  final String urgency; // High, Medium, Low
  final bool needsExpert; // هل تتطلب المشكلة خبيراً معتمداً أم أي فني عادي؟
  final double confidence; // نسبة الدقة (0.0 إلى 1.0)
  final String safetyAdvice; // نصيحة أمان سريعة للعميل
  final String technicianBrief; // تقرير فني مجهز لإرساله للفني مع الصور

  const AiDiagnosisResult({
    required this.serviceCategory,
    required this.issueSummary,
    required this.urgency,
    required this.needsExpert,
    required this.confidence,
    required this.safetyAdvice,
    required this.technicianBrief,
  });

  factory AiDiagnosisResult.fallback(String text) {
    return FixlyAiService.analyzeWithHeuristics(text);
  }
}

/// خدمة الذكاء الاصطناعي (Fixly AI Engine)
///
/// تعمل بنظام ثنائي ذكي:
/// 1. تجربة Gemini 1.5 Flash (Free Tier) إن توفر API Key.
/// 2. المحرك الداخلي (NLP Rule & Heuristic Engine) فائق السرعة وبدون إنترنت
///    يدعم اللهجة المصرية والفصحى والإنجليزية بدقة متناهية.
class FixlyAiService {
  FixlyAiService._();
  static final FixlyAiService instance = FixlyAiService._();

  /// تشخيص المشكلة وتحليل الصور بالذكاء الاصطناعي
  Future<AiDiagnosisResult> diagnoseProblem({
    required String description,
    Uint8List? imageBytes,
  }) async {
    final cleanText = description.trim();

    // 1. إذا كان مفتاح Gemini متوفراً، نحاول الاتصال بـ Google Gemini
    if (AiConfig.hasApiKey) {
      try {
        final model = GenerativeModel(
          model: AiConfig.geminiModel,
          apiKey: AiConfig.geminiApiKey,
        );

        final prompt =
            '''
You are an expert home maintenance diagnosis assistant for Fixly app.
Analyze this user problem: "$cleanText".
Has image attached: ${imageBytes != null}.

Respond ONLY with valid JSON in this exact structure:
{
  "serviceCategory": "Air Conditioning" or "Plumbing" or "Electrical" or "Appliances" or "Carpentry",
  "issueSummary": "Short issue title in Arabic and English",
  "urgency": "High" or "Medium" or "Low",
  "needsExpert": true or false (true if dangerous, complex, requires specialized tools or certified master, false if simple fix),
  "confidence": 0.85 to 0.98,
  "safetyAdvice": "Immediate safe action for homeowner in Arabic",
  "technicianBrief": "Technical briefing for the technician in Arabic"
}
''';

        final contentParts = <Part>[TextPart(prompt)];
        if (imageBytes != null) {
          contentParts.add(DataPart('image/jpeg', imageBytes));
        }

        final response = await model.generateContent([
          Content.multi(contentParts),
        ]);

        final responseText = response.text;
        if (responseText != null && responseText.isNotEmpty) {
          final jsonStart = responseText.indexOf('{');
          final jsonEnd = responseText.lastIndexOf('}');
          if (jsonStart != -1 && jsonEnd != -1) {
            final jsonStr = responseText.substring(jsonStart, jsonEnd + 1);
            final data = json.decode(jsonStr) as Map<String, dynamic>;

            return AiDiagnosisResult(
              serviceCategory: data['serviceCategory'] ?? 'Air Conditioning',
              issueSummary: data['issueSummary'] ?? cleanText,
              urgency: data['urgency'] ?? 'Medium',
              needsExpert: data['needsExpert'] == true,
              confidence: (data['confidence'] as num?)?.toDouble() ?? 0.90,
              safetyAdvice:
                  data['safetyAdvice'] ?? 'يرجى توخي الحذر حتى وصول الفني.',
              technicianBrief: data['technicianBrief'] ?? cleanText,
            );
          }
        }
      } catch (e) {
        debugPrint('Gemini API call failed, falling back to local NLP: $e');
      }
    }

    // 2. المحرك المحلي الذكي (Heuristic Engine) - مجاني وفوري 100%
    return analyzeWithHeuristics(cleanText, hasImage: imageBytes != null);
  }

  /// المحرك المحلي لتحليل النصوص والأعطال (عربي + إنجليزي)
  static AiDiagnosisResult analyzeWithHeuristics(
    String text, {
    bool hasImage = false,
  }) {
    final t = text.toLowerCase();

    bool has(List<String> words) => words.any(t.contains);

    // 1. طوارئ وسلامة حرجة (Emergency)
    if (has([
      'غاز',
      'gas',
      'حريق',
      'fire',
      'ماس كهربائي',
      'شرار',
      'spark',
      'صدمة كهربائية',
      'electric shock',
      'ريحة شياط',
      'انفجار',
    ])) {
      return AiDiagnosisResult(
        serviceCategory: 'Electrical',
        issueSummary: 'طوارئ: عطل كهربائي / أمان حرج (Urgent Safety Alert)',
        urgency: 'High',
        needsExpert: true, // تتطلب خبيراً فورياً
        confidence: 0.96,
        safetyAdvice:
            'افصل القاطع الكهربائي العمومي أو محبس الغاز فوراً وابتعد عن المصدر لحين وصول الفني.',
        technicianBrief:
            'حالة طوارئ قصوى: خطر ماس أو شرار. الفني يحتاج لمعدات عزل وكشف فوري للجهد.',
      );
    }

    // 2. تكييف وتبريد (Air Conditioning)
    if (has([
      'تكييف',
      'ac',
      'فريون',
      'تبريد',
      'كمبروسر',
      'كومبريسور',
      'مروحة التكييف',
      'تنقيط تكييف',
      'cooling',
      'air condition',
    ])) {
      // هل يحتاج خبير؟ (أعطال الكومبريسور وتسريب الفريون والشحنات تحتاج خبيراً)
      final isComplexAc = has([
        'كومبريسور',
        'كمبروسر',
        'compressor',
        'فريون',
        'freon',
        'صوت عالي',
        'محروق',
        'refrigerant',
      ]);
      return AiDiagnosisResult(
        serviceCategory: 'Air Conditioning',
        issueSummary: isComplexAc
            ? 'عطل في دورة التبريد / الكومبريسور (Compressor / Freon Issue)'
            : 'ضعف تبريد وتنظيف فلاتر (AC Maintenance & Airflow)',
        urgency: isComplexAc ? 'High' : 'Medium',
        needsExpert: isComplexAc, // يحتاج خبير إذا كان كومبريسور أو فريون
        confidence: hasImage ? 0.94 : 0.89,
        safetyAdvice:
            'يُفضل إيقاف تشغيل التكييف لحماية المحرك من الاحتراق في حالة انخفاض التبريد المفاجئ.',
        technicianBrief: isComplexAc
            ? 'فحص ضغط الفريون واختبار سحب الكومبريسور والتسريبات بالأنابيب النحاسية.'
            : 'صيانة دورية: تنظيف الفلاتر وفحص ضغط الهواء ومجرى تصريف المياه.',
      );
    }

    // 3. سباكة ومياه (Plumbing)
    if (has([
      'سباك',
      'سباكة',
      'مياه',
      'تسريب',
      'ماسورة',
      'حنفية',
      'بالوعة',
      'سيفون',
      'خلاط',
      'plumb',
      'leak',
      'pipe',
      'drain',
      'water',
    ])) {
      final isComplexPlumb = has([
        'كسر ماسورة',
        'ماسورة مكسورة',
        'تسريب داخلي',
        'في الحيطة',
        'تحت البلاط',
        'burst pipe',
        'sewage',
      ]);
      return AiDiagnosisResult(
        serviceCategory: 'Plumbing',
        issueSummary: isComplexPlumb
            ? 'كسر أو تسريب داخلي بشبكة المياه (Severe Pipe Leak)'
            : 'صيانة تسريب سطحي أو خلاط مياه (Minor Leak / Faucet Fix)',
        urgency: isComplexPlumb ? 'High' : 'Medium',
        needsExpert: isComplexPlumb, // لو تسريب داخلي يحتاج خبير بأجهزة كشف
        confidence: hasImage ? 0.92 : 0.86,
        safetyAdvice:
            'أغلق محبس المياه العمومي الخاص بالشقة فوراً لتجنب غمر الأرضيات.',
        technicianBrief: isComplexPlumb
            ? 'تسريب مخفي أو كسر ماسورة يتطلب جهاز كشف تسريبات ومعدات لحام حراري.'
            : 'إصلاح تسريب مياه سطحي أو استبدال قطع غيار ووصلات تغذية.',
      );
    }

    // 4. كهرباء (Electrical)
    if (has([
      'كهربا',
      'كهرباء',
      'فيشة',
      'مفتاح نور',
      'قاطع',
      'لوحة',
      'لمبة',
      'نجفة',
      'سلك',
      'electric',
      'power',
      'socket',
      'breaker',
      'switch',
    ])) {
      final isComplexElec = has([
        'لوحة',
        'قاطع عمومي',
        'شورت',
        'قفلة',
        'short circuit',
        'panel',
        'breaker box',
        'كابل',
      ]);
      return AiDiagnosisResult(
        serviceCategory: 'Electrical',
        issueSummary: isComplexElec
            ? 'عطل في لوحة التوزيع أو قفلة كهربائية (Circuit Breaker Failure)'
            : 'تصليح أو استبدال مقابس ومفاتيح إنارة (Switch / Socket Replacement)',
        urgency: isComplexElec ? 'High' : 'Medium',
        needsExpert: isComplexElec,
        confidence: 0.88,
        safetyAdvice:
            'لا تلمس أي أسلاك عارية وافصل الدائرة المعطلة من اللوحة الفرعية.',
        technicianBrief: isComplexElec
            ? 'فحص قواطع التيار والأحمال واكتشاف مكان القفلة عبر جهاز قياس الأمبير/الفولت.'
            : 'تغيير مفاتيح أو تركيب إضاءة منزلية قياسية.',
      );
    }

    // 5. أجهزة منزلية (Appliances)
    if (has([
      'غسالة',
      'ثلاجة',
      'سخان',
      'بوتاجاز',
      'ميكروويف',
      'ماتور',
      'washing machine',
      'fridge',
      'refrigerator',
      'heater',
      'oven',
      'stove',
    ])) {
      final isComplexApp = has([
        'كارتة',
        'موتور',
        'motor',
        'ثلاجة مش بتسقع',
        'تسريب غاز',
        'board',
      ]);
      return AiDiagnosisResult(
        serviceCategory: 'Appliances',
        issueSummary: 'عطل في الأجهزة المنزلية (Appliance Malfunction)',
        urgency: 'Medium',
        needsExpert: isComplexApp,
        confidence: 0.87,
        safetyAdvice:
            'افصل الجهاز المعطل عن مصدر الكهرباء تماماً حتى لا يتلف المحرك أو اللوحة الإلكترونية.',
        technicianBrief:
            'فحص الحساسات، لوحة التحكم، ودائرة تصريف المياه أو دورة التبريد.',
      );
    }

    // 6. نجارة (Carpentry)
    if (has([
      'نجار',
      'باب',
      'كالون',
      'شباك',
      'مطبخ',
      'أوكره',
      'قفل',
      'door',
      'lock',
      'window',
      'wood',
      'carpenter',
    ])) {
      return AiDiagnosisResult(
        serviceCategory: 'Carpentry',
        issueSummary: 'أعمال نجارة وأبواب وأقفال (Door / Furniture Repair)',
        urgency: 'Low',
        needsExpert: false, // معظم أعمال النجارة الخفيفة تناسب أي فني
        confidence: 0.85,
        safetyAdvice:
            'تأكد من عدم ترك الباب مفتوحاً واستخدم القفل الاحتياطي إن وجد.',
        technicianBrief:
            'صيانة مفصلات أو استبدال كالون أو تسوية درف الأبواب والمطابخ.',
      );
    }

    // افتراضي عام
    return AiDiagnosisResult(
      serviceCategory: 'General',
      issueSummary: text.isNotEmpty
          ? text
          : 'طلب صيانة منزلية عامة (General Home Maintenance)',
      urgency: 'Medium',
      needsExpert: false,
      confidence: 0.80,
      safetyAdvice:
          'تم تسجيل الطلب، وسيقوم الفني بالفحص وتحديد الخطوات اللازمة.',
      technicianBrief: 'معاينة عامة للمشكلة وتحديد قطع الغيار المطلوبة.',
    );
  }

  /// خوارزمية ترشيح الفني المناسب وترتيبهم بالذكاء الاصطناعي
  ///
  /// تعتمد على:
  /// 1. مدى تعقيد المشكلة: هل تتطلب خبيراً (needsExpert)؟
  /// 2. التقييم (Rating)
  /// 3. المسافة وقرب الفني من العميل (Distance)
  List<TechnicianModel> rankTechnicians({
    required List<TechnicianModel> technicians,
    required AiDiagnosisResult diagnosis,
    double? userLat,
    double? userLng,
  }) {
    final targetCategory = diagnosis.serviceCategory.toLowerCase();

    // لو التشخيص محدد تخصص معين، نفضل الفنيين المطابقين للتخصص أولاً
    final filtered = targetCategory == 'general'
        ? technicians
        : technicians
              .where((t) => t.specialty.toLowerCase() == targetCategory)
              .toList();

    final pool = filtered.isNotEmpty ? filtered : technicians;

    final list = pool.map((tech) {
      double score = 40.0;

      final matchSpecialty =
          tech.specialty.toLowerCase() == targetCategory ||
          targetCategory == 'general';
      if (matchSpecialty) {
        score += 30.0;
      }

      String expertReason;
      if (diagnosis.needsExpert) {
        if (tech.isExpert) {
          score += 15.0;
          expertReason = 'خبير معتمد (مناسب لهذه المشكلة)';
        } else {
          score -= 10.0;
          expertReason = 'فني عام (يفضل خبير متخصص)';
        }
      } else {
        score += 10.0;
        expertReason = 'مناسب لطبيعة هذا العطل';
      }

      final ratingScore = ((tech.rating - 3.5) / 1.5).clamp(0.0, 1.0) * 10.0;
      score += ratingScore;

      double dist = tech.distanceKm;
      if (userLat != null &&
          userLng != null &&
          tech.latitude != null &&
          tech.longitude != null) {
        dist = TechnicianModel.calculateDistanceKm(
          lat1: userLat,
          lon1: userLng,
          lat2: tech.latitude!,
          lon2: tech.longitude!,
        );
      }

      if (dist <= 2.0) {
        score += 10.0;
      } else if (dist <= 5.0) {
        score += 6.0;
      } else if (dist <= 10.0) {
        score += 2.0;
      }

      final finalPercentage = score.clamp(25.0, 99.0).round();
      final reason =
          '$expertReason · تقييم ${tech.rating.toStringAsFixed(1)} ★ · يبعد $dist كم';

      return tech.copyWith(
        distanceKm: dist,
        matchPercentage: finalPercentage,
        matchReason: reason,
      );
    }).toList();

    list.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
    return list;
  }
}

import 'package:flutter/material.dart';

import 'widgets/ai_art.dart';
import 'widgets/home_art.dart';
import 'widgets/map_art.dart';

/// One onboarding page: illustration + title + body.
class OnboardingPageData {
  final String title;
  final String body;
  final Widget Function() art;

  const OnboardingPageData({
    required this.title,
    required this.body,
    required this.art,
  });
}

/// The three onboarding pages, in display order.
final List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    title: 'Your Home, Our Help',
    body:
        'From a flickering light to a leaking pipe, trusted technicians are one message away.',
    art: () => const HomeArt(),
  ),
  OnboardingPageData(
    title: 'AI Finds the Right Technician',
    body:
        'Describe it, snap it, or say it. Fixly ranks technicians by skill, rating and availability, not just distance.',
    art: () => const AiArt(),
  ),
  OnboardingPageData(
    title: 'Track. Fix. Relax.',
    body:
        'Follow your technician live, pay securely, and rate the job when it is done.',
    art: () => const MapArt(),
  ),
];

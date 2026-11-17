import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/profile_store.dart';
import '../../core/theme/app_colors.dart';
import 'page_scaffold.dart';

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
                    const Icon(Icons.star, size: 16, color: Color(0xFFF5B301)),
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
    return PageScaffold(
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

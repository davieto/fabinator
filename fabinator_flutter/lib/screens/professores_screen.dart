import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/professors_data.dart';
import '../models/professor.dart';
import '../theme/colors.dart';
import '../widgets/background.dart';
import '../widgets/professor_photo.dart';

class ProfessoresScreen extends StatelessWidget {
  const ProfessoresScreen({super.key});

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static List<Professor> get _professors => ProfessorsData.all
      .map((m) => Professor(
            id: m['id'] as String,
            name: m['name'] as String,
            initials: _initials(m['name'] as String),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    final profs = _professors;
    final isWide = MediaQuery.sizeOf(context).width > 600;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          Column(
            children: [
              _topBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profs.length} professores no banco de dados',
                            style: GoogleFonts.spectral(
                                fontStyle: FontStyle.italic,
                                color: goldLight.withValues(alpha: 0.8),
                                fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          isWide
                              ? _grid(profs)
                              : Column(
                                  children: profs
                                      .map((p) => _profCard(p))
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: wine800.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: cream, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Text('Professores',
                style: GoogleFonts.lilitaOne(fontSize: 26, color: goldLight)),
          ],
        ),
      ),
    );
  }

  Widget _grid(List<Professor> profs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: profs.length,
      itemBuilder: (_, i) => _profCard(profs[i]),
    );
  }

  Widget _profCard(Professor prof) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCF6EA), Color(0xFFF1E2C8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA9741A).withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: wine800,
              child: Text(
                prof.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.lilitaOne(
                    fontSize: 14,
                    color: goldLight,
                    letterSpacing: 0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: ProfessorPhoto(prof: prof, height: 150),
            ),
          ],
        ),
      ),
    );
  }
}

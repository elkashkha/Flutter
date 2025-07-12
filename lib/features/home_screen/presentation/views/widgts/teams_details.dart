import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';

class TeamDetailsPage extends StatelessWidget {
  final TeamMember member;

  const TeamDetailsPage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);


    final name = locale.languageCode == 'ar' ? member.nameAr : member.nameEn;
    final description = locale.languageCode == 'ar'
        ? member.descriptionAr ?? l10n.noDescription
        : member.descriptionEn ?? l10n.noDescription;
    final specialties = locale.languageCode == 'ar' ? member.specialtiesAr : member.specialtiesEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(name.isNotEmpty ? name : l10n.noName),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: member.image,
                  height: 200,
                  width: 354,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name.isNotEmpty ? name : l10n.noName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.specialtiesTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: specialties
                  .map((spec) => Chip(label: Text(spec.isNotEmpty ? spec : l10n.noSpecialties)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.projectsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            member.projects.isEmpty
                ? Text(l10n.noProjects)
                : SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: member.projects.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final project = member.projects[index];
                  return project.images.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: project.images[0],
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const SizedBox.shrink();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyCustomButton(text: l10n.book_now, voidCallback: () { context.push('/BookingService'); },),
            )
          ],
        ),
      ),
    );
  }
}
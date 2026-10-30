import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:page_flip/page_flip.dart';
import 'package:tirth_today/layouts/notebook_layout.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkExperiencePage extends StatelessWidget {
  const WorkExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final experiences = [
      {
        "role": "Freelance Software Engineer",
        "company": "Self Employed",
        "duration": "May 2026 - Present",
        "description":
            "Built a static website for a PTFE manufacturer and set up a blog for my own site. Contributed to the open source Flutter SDK and added Gujarati translations to ente.io. I also took a short break during this period and traveled to Hyderabad and Goa.",
      },
      {
        "role": "Developer Support Engineer",
        "company": "Nevercode HQ / Codemagic",
        "duration": "Feb 2026 - Apr 2026",
        "description":
            "Supporting developers using Codemagic's CI/CD platform for Flutter and mobile apps by triaging complex build and deployment issues across Mobile Dev pipelines. Reproduce failures, analyze logs, debug environment and configuration problems, and collaborate with engineering to drive product improvements that enhance build reliability and developer experience.",
      },
      {
        "role": "Open Source Software Engineer",
        "company": "Nevercode HQ / Codemagic",
        "duration": "May 2025 - Jan 2026",
        "description":
            "Collaborating with the Flutter team as part of Codemagic's Frontline Triage initiative. I triage and bisect issues for the flutter/flutter (SDK) repository, document findings, and occasionally raise PRs to help improve the developer experience.",
      },
      {
        "role": "Software Engineer",
        "company": "Multipl Fintech",
        "duration": "Jan 2023 - April 2025",
        "description":
            "Built and maintained core features for Multipl (multipl.xyz), a fintech product in the 'Save Now, Buy Later' and spendvesting category. Led campaigns and feature launches that improved user engagement and long-term savings outcomes.",
      },
      {
        "role": "Software Engineer",
        "company": "SculptSoft",
        "duration": "Oct 2021 - Jan 2023",
        "description":
            "Developed dashboards for technicians, appraisers, and property owners in the remote property valuation domain. Built a video-calling module using Twilio that integrated seamlessly with Android/iOS AR apps for inspections.",
      },
      {
        "role": "Software Engineer",
        "company": "Stasis Labs",
        "duration": "Nov 2020 - Aug 2021",
        "description":
            "Contributed to an FDA-regulated and HIPPA compliant Remote Patient Monitoring platform. Built a custom Flutter plugin enabling inter-app IPC with native Android apps (via Messenger and ContentProvider), streaming BLE-based vitals data from Stasis medical monitors.",
      },
      {
        "role": "Software Engineer",
        "company": "Aubergine Solutions",
        "duration": "Dec 2019 - Jun 2020",
        "description":
            "Started my career developing a super app with integrated voice assistance features. Collaborated closely with cross-functional teams and wrote technical blogs to share learnings and promote company engineering culture.",
      },
    ];

    return Scaffold(
      backgroundColor: palette.paper,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'work_next_page_fab',
        onPressed: () {
          GetIt.I
              .get<GlobalKey<PageFlipWidgetState>>()
              .currentState
              ?.nextPage();
        },
        label: Text('Next Page'),
        tooltip: 'Page can be swiped as well',
      ),
      body: Stack(
        children: [
          const NotebookLayout(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Work Experience",
                  style: TextStyle(
                    fontSize: 32,
                    color: palette.ink,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                    decorationColor: palette.ink,
                    decorationThickness: .8,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: experiences.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final item = experiences[index];
                      return Center(
                        child: StickyNoteCard(
                          title: item["role"]!,
                          subtitle: "${item["company"]} • ${item["duration"]}",
                          description: item["description"]!,
                          colorIndex: index - 1,
                          color: index == 0
                              ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.teal.shade900
                                    : Colors.teal.shade100)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StickyNoteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final int colorIndex;
  final Color? color;

  StickyNoteCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.colorIndex,
    this.color,
  });

  final Map<String, String> companyUrls = {
    "Nevercode HQ / Codemagic": "https://codemagic.io",
    "Multipl Fintech": "https://multipl.in",
    "SculptSoft": "https://sculptsoft.com",
    "Stasis Labs": "https://www.linkedin.com/company/stasis-labs",
    "Aubergine Solutions": "https://aubergine.co",
  };

  final Map<String, List<String>> companyLogos = {
    "Nevercode HQ / Codemagic": [
      "https://avatars.githubusercontent.com/u/31367575?s=280&v=4",
    ],
    "Multipl Fintech": [
      "https://framerusercontent.com/images/jcac5XGXYqH10hoPF84nFxvGZh4.png",
    ],
  };

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stickyColors = isDark
        ? [
            Colors.deepOrange.shade900,
            Colors.blue.shade900,
            Colors.amber.shade900,
            Colors.green.shade900,
            Colors.indigo.shade900,
            Colors.purple.shade900,
          ]
        : [
            Colors.deepOrange.shade100,
            Colors.blue.shade100,
            Colors.amber.shade100,
            Colors.green.shade100,
            Colors.indigo.shade100,
            Colors.purple.shade100,
          ];

    final color = this.color ?? stickyColors[colorIndex % stickyColors.length];
    final companyName = subtitle.split(" • ")[0];
    final companyUrl = companyUrls[companyName];

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        border: isDark ? Border.all(color: palette.rule) : null,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: isDark ? Colors.black54 : Colors.black26, offset: Offset(2, 4), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: palette.ink,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (companyLogos[companyName] != null) ...[
                ...companyLogos[companyName]!.map(
                  (e) => Image.network(e, width: 24, height: 24),
                ),
                const SizedBox(width: 4),
              ],
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: companyName,
                      style: const TextStyle(fontFamily: 'Pangolin').copyWith(
                        fontSize: 16,
                        color: palette.ink,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (companyUrl != null &&
                              await canLaunchUrl(Uri.parse(companyUrl))) {
                            await launchUrl(Uri.parse(companyUrl));
                          }
                        },
                    ),
                    TextSpan(
                      text: " • ${subtitle.split(" • ")[1]}",
                      style: const TextStyle(fontFamily: 'Pangolin').copyWith(
                        fontSize: 16,
                        color: palette.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, height: 1.4, color: palette.ink),
          ),
        ],
      ),
    );
  }
}

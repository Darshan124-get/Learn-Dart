import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _h(context, 'Privacy Policy for Learn Dart'),
              const SizedBox(height: 8),
              _p(context, 'Effective date: [22/09/2025]'),
              const SizedBox(height: 16),
              _p(context, 'Learn Dart ("App", "we", "our") is an offline learning app. This policy describes how the App handles information.'),
              const SizedBox(height: 16),
              _h(context, 'Information We Collect'),
              _ul(context, const [
                'Advertising data via Google AdMob: device advertising ID, IP address, approximate location, and engagement for ad delivery, measurement, fraud prevention, and personalization where permitted.',
                'Network status (online/offline) using connectivity_plus to adapt behavior (e.g., show internet required screen).',
                'Local preferences using shared_preferences (e.g., last viewed items). Stored only on your device.',
                'We do not create user accounts and we do not collect names, emails, or passwords.'
              ]),
              _h(context, 'How We Use Information'),
              _ul(context, const [
                'Serve and measure ads.',
                'Maintain and improve core functionality.',
                'Remember preferences locally.'
              ]),
              _h(context, 'Sharing of Information'),
              _p(context, 'We share data with Google AdMob solely to serve and measure ads. See Google policies at https://policies.google.com/technologies/ads.'),
              _h(context, 'Legal Bases & Your Choices'),
              _ul(context, const [
                'Legitimate interests (functionality, security, fraud prevention).',
                'Consent for personalized ads where required (e.g., EEA). Turn off ad personalization in Android settings.'
              ]),
              _h(context, 'Children'),
              _p(context, 'The App is for general audiences. Personalized ads to children are disabled where required.'),
              _h(context, 'Data Retention'),
              _p(context, 'Local preferences remain on your device until you clear app data or uninstall. Ad data is retained by Google under their policies.'),
              _h(context, 'Security'),
              _p(context, 'We do not transmit personal data to our servers. Third‑party partners (Google) secure data according to their standards.'),
              _h(context, 'International Transfers'),
              _p(context, 'AdMob may process data on servers outside your country in accordance with their safeguards.'),
              _h(context, 'Changes'),
              _p(context, 'We may update this policy. Changes will be posted in‑app with an updated effective date.'),
              _h(context, 'Contact'),
              _p(context, 'Email: [devgroup089@gmail.com]'),
              _p(context, 'Website: [https://sites.google.com/view/learndart/home]'),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _h(BuildContext context, String text) {
    return Text(text, style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w700));
  }

  Widget _p(BuildContext context, String text) {
    return Text(text, style: GoogleFonts.roboto(fontSize: 15, height: 1.6));
  }

  Widget _ul(BuildContext context, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: _p(context, i)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}



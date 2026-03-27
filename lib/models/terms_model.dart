// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

class TermsModel {
  final String body;
  const TermsModel({required this.body});
}

const termsContent = TermsModel(
  body:
      'Welcome to [Your App Name]. By using this application, you agree to the '
      'following Terms and Conditions. If you do not agree, please discontinue use of the app.\n\n'
      '[Your App Name] is designed to support early autism screening and behavioral '
      'observation for children. The app is intended for parents, caregivers, and '
      'healthcare professionals. The information and screening results provided are for '
      'educational and informational purposes only and do not constitute a medical '
      'diagnosis or professional medical advice.\n\n'
      'By using this app, you acknowledge that all data collected, including videos, '
      'is handled in accordance with our Privacy Policy. Video recordings may be used '
      'for research and scientific purposes based on your consent selections above.\n\n'
      'You agree not to misuse the application or attempt to access it in unauthorized '
      'ways. Affiliated institutions are not liable for decisions made based on app output.\n\n'
      'By tapping "I Accept," you confirm that you have read, understood, and agree to these terms.',
);

const List<String> consentLabels = [
  'My video(s) can be shown to the public for research and scientific purposes only.',
  'My video(s) can be shown to the public for research and scientific purposes only.',
  'My video(s) can be shown to the public for research and scientific purposes only.',
];

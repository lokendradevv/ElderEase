import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  final String _privacyPolicyMarkdown = '''
# Privacy & Security Policy

**Last Updated: June 2026**

## Welcome to ElderEase

ElderEase is committed to protecting the privacy, security, and personal information of our users. This Privacy & Security Policy explains how we collect, use, store, and protect information when you use the ElderEase mobile application and related services.

By using ElderEase, you agree to the practices described in this policy.

---

# 1. Information We Collect

## Personal Information

When using ElderEase, we may collect:

* Full name
* Email address
* Phone number
* Emergency contact information
* User account details

## Device Information

We may collect:

* Device model
* Operating system version
* App version
* Unique device identifiers
* Crash and performance logs

## Location Information

With your permission, ElderEase may access your location to:

* Provide emergency assistance features
* Share location with designated guardians during emergencies
* Improve safety-related services

Location access can be disabled at any time through your device settings.

---

# 2. How We Use Your Information

We use collected information to:

* Provide ElderEase services and features
* Send emergency alerts to guardians
* Improve app performance and reliability
* Respond to user support requests
* Maintain account security
* Detect and prevent fraudulent or unauthorized activities

We do not sell personal information to third parties.

---

# 3. Emergency Contact Features

ElderEase allows users to register guardians or emergency contacts.

When an emergency event is triggered:

* Alert notifications may be sent to registered guardians.
* Location information may be shared with those contacts.
* Emergency details may be transmitted to facilitate assistance.

This sharing only occurs based on user-configured settings or emergency actions.

---

# 4. Data Storage and Security

We implement industry-standard security measures including:

* Encrypted data transmission (HTTPS/TLS)
* Secure cloud database storage
* Authentication and access controls
* Regular security monitoring
* Restricted access to sensitive information

While we take reasonable measures to protect your data, no internet-based system can guarantee 100% security.

---

# 5. Firebase Services

ElderEase may use services provided by [Firebase](https://firebase.google.com) for:

* User authentication
* Secure cloud storage
* Real-time database services
* Crash reporting
* Analytics

Information processed through Firebase is subject to Google's security and privacy standards.

---

# 6. Third-Party Services

The application may integrate with trusted third-party providers to support:

* Cloud hosting
* Push notifications
* Analytics
* Authentication services

These providers are granted access only to the information necessary to perform their services.

---

# 7. User Rights

Users have the right to:

* Access their personal information
* Update inaccurate information
* Request deletion of their account
* Withdraw previously granted permissions
* Contact us regarding privacy concerns

Requests may be submitted through the application's support channels.

---

# 8. Data Retention

We retain information only as long as necessary to:

* Provide services
* Meet legal obligations
* Resolve disputes
* Improve platform security

When data is no longer required, it is securely deleted or anonymized.

---

# 9. Children's Privacy

ElderEase is designed primarily for adults and elderly users.

We do not knowingly collect personal information from children under 13 years of age. If such information is discovered, it will be removed promptly.

---

# 10. Security Best Practices for Users

To help keep your account secure:

* Use a strong password.
* Do not share login credentials.
* Keep your device updated.
* Review guardian contact information regularly.
* Enable device-level security such as PIN, Face ID, or fingerprint authentication.

---

# 11. Changes to This Policy

We may update this Privacy & Security Policy from time to time.

Any changes will be posted within the application, and the updated date will be revised accordingly.

---

# 12. Contact Us

If you have questions about privacy, security, or data handling practices, please contact:

**ElderEase Support Team**

Email: **lokendrasinghofficial2@gmail.com**

---

### Security Commitment

At ElderEase, protecting the safety, dignity, and privacy of elderly users is one of our highest priorities. We continuously work to improve our security measures and ensure that user information remains protected.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: AppTheme.backgroundOffWhite,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Markdown(
          data: _privacyPolicyMarkdown,
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(color: AppTheme.textDarkGray, fontSize: 24, fontWeight: FontWeight.bold),
            h2: const TextStyle(color: AppTheme.textDarkGray, fontSize: 20, fontWeight: FontWeight.bold),
            p: const TextStyle(color: AppTheme.textMuted, fontSize: 16, height: 1.5),
            listBullet: const TextStyle(color: AppTheme.primaryBlue, fontSize: 18),
            strong: const TextStyle(color: AppTheme.textDarkGray, fontWeight: FontWeight.bold),
            a: const TextStyle(color: AppTheme.primaryBlue, decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }
}

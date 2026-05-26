import 'package:about/core/constants/info.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // Construct mailto URL
    final subject = Uri.encodeComponent('Contact from Kunj Shingala: $name');
    final body = Uri.encodeComponent(
      'Name: $name\nEmail: $email\n\nMessage:\n$message',
    );
    final mailtoUrl = 'mailto:${AppInfo.email}?subject=$subject&body=$body';

    final uri = Uri.parse(mailtoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      // Clear form after successful launch
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      _showSnackBar('Opening email client...');
    } else {
      _showSnackBar('Could not open email client');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusS)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.screenWidth(context);
    final isMobile = Responsive.isMobile(context);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.spaceS),
            Text(
              'Have a project in mind?',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            const SizedBox(height: Dimensions.spaceXXL),
            Container(
              padding: EdgeInsets.all(
                  isMobile ? Dimensions.spaceL : Dimensions.spaceXXL),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(Dimensions.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "I'm currently available for freelance work or full-time opportunities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: isMobile ? 14 : 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: Dimensions.spaceXXL),
                  if (isMobile) ...[
                    _field('Name', 'Jane Doe', _nameController, context),
                    const SizedBox(
                        height: Dimensions.spaceL / 1.2), // approx 20
                    _field(
                      'Email',
                      'jane@example.com',
                      _emailController,
                      context,
                    ),
                  ] else
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            'Name',
                            'Jane Doe',
                            _nameController,
                            context,
                          ),
                        ),
                        const SizedBox(
                            width: Dimensions.spaceL / 1.2), // approx 20
                        Expanded(
                          child: _field(
                            'Email',
                            'jane@example.com',
                            _emailController,
                            context,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: Dimensions.spaceL / 1.2), // approx 20
                  _field(
                    'Message',
                    'Tell me about your project...',
                    _messageController,
                    context,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: Dimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _sendEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusFull),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'SEND MESSAGE',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
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

  Widget _field(
    String label,
    String hint,
    TextEditingController controller,
    BuildContext context, {
    int maxLines = 1,
  }) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.spaceS),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: isMobile ? 9 : 10,
            fontWeight: FontWeight.bold,
            color: context.colors.textTertiary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: Dimensions.spaceS),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: context.colors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: context.colors.textTertiary,
              fontSize: isMobile ? 13 : 14,
            ),
            filled: true,
            fillColor: context.colors.fieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusS),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

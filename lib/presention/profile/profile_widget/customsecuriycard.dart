import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class CustomSecurityCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final Widget? prefix;
  final Widget? trailing;
  final bool showTrailing;
  final Color? textColor;

  const CustomSecurityCard({
    super.key,
    required this.title,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.prefix,
    this.trailing,
    this.showTrailing = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFEFEFE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isSwitch ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefix != null) ...[
              prefix!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? const Color(0xFF1F2937),
                ),
              ),
            ),
            if (isSwitch)
              SizedBox(
                height: 24,
                child: Transform.scale(
                  scale: 0.8, // scale down to fit the 48px height nicely
                  child: Switch(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    activeThumbColor: Appcolors.pramary,
                    activeTrackColor: Appcolors.pramary.withValues(alpha: 0.5),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFE5E7EB),
                  ),
                ),
              )
            else if (showTrailing)
              trailing ?? const Icon(Icons.chevron_right, color: Color(0xFF1F2937)),
          ],
        ),
      ),
    );
  }
}

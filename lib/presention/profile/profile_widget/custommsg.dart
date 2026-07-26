import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMsgDialog extends StatelessWidget {
  final String title;
  final String buttonText;
  final String iconPath;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color? titleColor;
  final bool isDelete;

  const CustomMsgDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.iconPath,
    required this.onConfirm,
    required this.onCancel,
    this.titleColor,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 370,
        height: 219,
        decoration: BoxDecoration(
          color: Colors.white, // solid white for the dialog background
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Close Button or Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onCancel,
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),

            // Icon & Message Center
            Column(
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: 48,
                  width: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: isDelete
                      ? null
                      : const LinearGradient(
                          colors: [
                            Color(0xFFFF8A50),
                            Color(0xFFFF5252),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  color: isDelete ? const Color(0xFFFF5A4A) : null,
                ),
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

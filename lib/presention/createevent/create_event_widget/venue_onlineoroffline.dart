import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VenueOnlineOrOfflineSelector extends StatelessWidget {
  final bool isVenueSelected;
  final ValueChanged<bool> onChanged;

  const VenueOnlineOrOfflineSelector({
    super.key,
    required this.isVenueSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const activeBg = Color(0xFFFFE7CF);
    const activeText = Color(0xFFEC6D43);
    const inactiveText = Color(0xFF6B7280);
    const borderColor = Color(0x1A000000);

    return Container(
      height: 47,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Venue Option
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                decoration: BoxDecoration(
                  color: isVenueSelected ? activeBg : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: isVenueSelected ? activeText : inactiveText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Venue",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isVenueSelected ? activeText : inactiveText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: double.infinity,
            color: borderColor,
          ),
          // Online Event Option
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isVenueSelected ? activeBg : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_outlined,
                      size: 20,
                      color: !isVenueSelected ? activeText : inactiveText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Online Event",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: !isVenueSelected ? activeText : inactiveText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

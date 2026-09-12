import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectionRequestCard extends StatelessWidget {
  final String name;
  final String meetupName;
  final int mutualConnections;
  final String timeAgo;
  final String avatarPath;
  final VoidCallback onAccept;
  final VoidCallback onIgnore;

  const ConnectionRequestCard({
    super.key,
    required this.name,
    required this.meetupName,
    required this.mutualConnections,
    required this.timeAgo,
    required this.avatarPath,
    required this.onAccept,
    required this.onIgnore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 26,
            backgroundImage: avatarPath.startsWith('http')
                ? NetworkImage(avatarPath) as ImageProvider
                : AssetImage(avatarPath),
          ),
          const SizedBox(width: 12),
          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0C0A09),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Meetup Subtitle
                Text(
                  meetupName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                // Mutual connections count
                Text(
                  "$mutualConnections mutual connections",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 10),
                // Actions Buttons
                Row(
                  children: [
                    // Accept Button
                    GestureDetector(
                      onTap: onAccept,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC6D43), Color(0xFFFFB670)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Accept",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Ignore Button
                    GestureDetector(
                      onTap: onIgnore,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(


                        ),
                        child: Center(
                          child: Text(
                            "Ignore",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

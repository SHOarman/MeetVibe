import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMessageTile extends StatelessWidget {
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final bool isTyping;
  final int unreadCount;
  final bool hasAttachment;
  final bool isVoice;
  final bool isLastMessageFromMe;
  final bool isLastMessageRead;
  final VoidCallback? onTap;

  const CustomMessageTile({
    super.key,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.isTyping = false,
    this.unreadCount = 0,
    this.hasAttachment = false,
    this.isVoice = false,
    this.isLastMessageFromMe = false,
    this.isLastMessageRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image(
                    image: avatar.startsWith('http')
                        ? NetworkImage(avatar) as ImageProvider
                        : AssetImage(avatar),
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52,
                      height: 52,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71), // green dot
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            
            // Name and Message details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F0F0F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isVoice && !isTyping) ...[
                        const Icon(
                          Icons.mic,
                          size: 14,
                          color: Color(0xFF7E7E7E),
                        ),
                        const SizedBox(width: 4),
                      ] else if (hasAttachment && !isTyping) ...[
                        const Icon(
                          Icons.image,
                          size: 14,
                          color: Color(0xFF7E7E7E),
                        ),
                        const SizedBox(width: 4),
                      ] else if (isLastMessageFromMe && !isTyping) ...[
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: isLastMessageRead ? const Color(0xFFF2703D) : const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          isTyping ? 'Typing...' : lastMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isTyping ? FontWeight.w500 : FontWeight.w400,
                            color: isTyping
                                ? const Color(0xFFF2703D)
                                : const Color(0xFF7E7E7E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            
            // Time and Unread count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF7E7E7E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2703D), // orange badge
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:meetvibe/core/route/app_routes.dart';
//
// class BottomNavPainter extends CustomPainter {
//   final double barHeight;
//   BottomNavPainter({required this.barHeight});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint bgPaint = Paint()
//       ..color = const Color(0xFFFFB670).withValues(alpha: 0.10)
//       ..style = PaintingStyle.fill;
//
//     Paint borderPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5
//       ..shader = ui.Gradient.linear(
//         const Offset(0, 0),
//         Offset(0, size.height),
//         const [
//           Color(0xFFEC6D43),
//           Color(0xFFFFB670),
//         ],
//       );
//
//     ui.Path path = ui.Path();
//     double cornerRadius = size.height / 2;
//     double cx = size.width / 2;
//     double nw = 64.0;
//
//     path.moveTo(cornerRadius, 0);
//
//     path.lineTo(cx - nw, 0);
//     path.cubicTo(
//       cx - nw + 18, 0,
//       cx - nw + 30, barHeight * 0.58,
//       cx, barHeight * 0.58,
//     );
//     path.cubicTo(
//       cx + nw - 30, barHeight * 0.58,
//       cx + nw - 18, 0,
//       cx + nw, 0,
//     );
//
//     // Top-right corner
//     path.lineTo(size.width - cornerRadius, 0);
//     path.arcToPoint(
//       Offset(size.width, size.height / 2),
//       radius: Radius.circular(cornerRadius),
//       clockwise: true,
//     );
//
//     path.arcToPoint(
//       Offset(size.width - cornerRadius, size.height),
//       radius: Radius.circular(cornerRadius),
//       clockwise: true,
//     );
//
//     path.lineTo(cornerRadius, size.height);
//
//     path.arcToPoint(
//       Offset(0, size.height / 2),
//       radius: Radius.circular(cornerRadius),
//       clockwise: true,
//     );
//     path.arcToPoint(
//       Offset(cornerRadius, 0),
//       radius: Radius.circular(cornerRadius),
//       clockwise: true,
//     );
//
//     path.close();
//
//     canvas.drawPath(path, bgPaint);
//     canvas.drawPath(path, borderPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant BottomNavPainter oldDelegate) =>
//       oldDelegate.barHeight != barHeight;
// }
//
// class CustomBottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   const CustomBottomNavBar({super.key, required this.selectedIndex});
//
//   static const _navItems = [
//     _NavItem(
//       activeIcon: 'assets/icon/activehome.svg',
//       inactiveIcon: 'assets/icon/inactivehome.svg',
//       label: 'Home',
//       route: AppRoutes.homeui,
//     ),
//     _NavItem(
//       activeIcon: 'assets/icon/activeevent.svg',
//       inactiveIcon: 'assets/icon/inactiveevent.svg',
//       label: 'Events',
//       route: AppRoutes.eventui,
//     ),
//     _NavItem(
//       activeIcon: 'assets/icon/activemsg.svg',
//       inactiveIcon: 'assets/icon/inactivemsg.svg',
//       label: 'Message',
//       route: AppRoutes.message,
//     ),
//     _NavItem(
//       activeIcon: 'assets/icon/activeprofile.svg',
//       inactiveIcon: 'assets/icon/inactiveprofile.svg',
//       label: 'Profile',
//       route: AppRoutes.profile,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final sw = MediaQuery.of(context).size.width;
//     final double systemNavBarHeight = MediaQuery.of(context).viewPadding.bottom;
//
//     final double barHeight = 70.0;
//     final double totalBarHeight = barHeight + systemNavBarHeight;
//     final double fabSize = 55.0;
//     final double bottomOffset = systemNavBarHeight + 10.0;
//
//     return Container(
//       color: Colors.transparent,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       height: totalBarHeight + 15 + 40.0, // Increase container height to prevent clipping
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             bottom: bottomOffset,
//             left: 0,
//             right: 0,
//             height: barHeight,
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 CustomPaint(
//                   size: Size(sw, barHeight),
//                   painter: BottomNavPainter(barHeight: barHeight),
//                 ),
//                 Container(
//                   height: barHeight,
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Row(
//                     children: [
//                       Expanded(child: _buildNavItem(0)),
//                       Expanded(child: _buildNavItem(1)),
//                       const SizedBox(width: 110),
//                       Expanded(child: _buildNavItem(2)),
//                       Expanded(child: _buildNavItem(3)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Center Floating Action Button (FAB) Gradient Matching
//           Positioned(
//             bottom: bottomOffset + barHeight - (fabSize / 1.8),
//             child: GestureDetector(
//               onTap: () => Get.toNamed(AppRoutes.createeventui),
//               child: Container(
//                 height: fabSize,
//                 width: fabSize,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFFFFB670),
//                       Color(0xFFEC6D43),
//                     ],
//                   ),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white, size: 32),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavItem(int index) {
//     final item = _navItems[index];
//     final bool isSelected = selectedIndex == index;
//
//     return GestureDetector(
//       onTap: () {
//         if (!isSelected) Get.offAllNamed(item.route);
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             isSelected ? item.activeIcon : item.inactiveIcon,
//             height: 24,
//             width: 24,
//             colorFilter: ColorFilter.mode(
//               isSelected ? const Color(0xFFEC6D43) : const Color(0xFF7E7E7E),
//               BlendMode.srcIn,
//             ),
//           ),
//           const SizedBox(height: 4),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               item.label,
//               maxLines: 1,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? const Color(0xFFEC6D43) : const Color(0xFF7E7E7E),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _NavItem {
//   final String activeIcon, inactiveIcon, label, route;
//   const _NavItem({
//     required this.activeIcon,
//     required this.inactiveIcon,
//     required this.label,
//     required this.route,
//   });
// }

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:meetvibe/core/route/app_routes.dart';

class BottomNavPainter extends CustomPainter {
  final double barHeight;
  BottomNavPainter({required this.barHeight});

  @override
  void paint(Canvas canvas, Size size) {
    // Background Paint
    Paint bgPaint = Paint()
      ..color = const Color(0xFFFFB670).withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    // Gradient Border Paint
    Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        const [Color(0xFFEC6D43), Color(0xFFFFB670)],
      );

    ui.Path path = ui.Path();
    double cornerRadius = size.height / 2;
    double cx = size.width / 2;
    double nw = 55.0; // Adjusted for a smoother, tighter fit around the FAB

    // Start top-left
    path.moveTo(cornerRadius, 0);

    // Left half of top edge
    path.lineTo(cx - nw, 0);

    // Center Notch Curve
    path.cubicTo(
      cx - nw + 15,
      0,
      cx - nw + 25,
      barHeight * 0.62,
      cx,
      barHeight * 0.62,
    );
    path.cubicTo(cx + nw - 25, barHeight * 0.62, cx + nw - 15, 0, cx + nw, 0);

    // Top-right edge and corner
    path.lineTo(size.width - cornerRadius, 0);
    path.arcToPoint(
      Offset(size.width, size.height / 2),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    path.arcToPoint(
      Offset(0, size.height / 2),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.close();

    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant BottomNavPainter oldDelegate) =>
      oldDelegate.barHeight != barHeight;
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNavBar({super.key, required this.selectedIndex});

  static const _navItems = [
    _NavItem(
      activeIcon: 'assets/icon/activehome.svg',
      inactiveIcon: 'assets/icon/inactivehome.svg',
      label: 'Home',
      route: AppRoutes.homeui,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activeevent.svg',
      inactiveIcon: 'assets/icon/inactiveevent.svg',
      label: 'Events',
      route: AppRoutes.eventui,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activemsg.svg',
      inactiveIcon: 'assets/icon/inactivemsg.svg',
      label: 'Message',
      route: AppRoutes.message,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activeprofile.svg',
      inactiveIcon: 'assets/icon/inactiveprofile.svg',
      label: 'Profile',
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double systemNavBarHeight = MediaQuery.of(context).viewPadding.bottom;

    final double barHeight = 68.0;
    final double fabSize = 56.0;

    final double bottomOffset = systemNavBarHeight > 0
        ? systemNavBarHeight
        : 16.0;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: barHeight + bottomOffset + (fabSize / 2),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: bottomOffset,
            left: 0,
            right: 0,
            height: barHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(sw - 32, barHeight),
                  painter: BottomNavPainter(barHeight: barHeight),
                ),
                SizedBox(
                  height: barHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildNavItem(0)),
                      Expanded(child: _buildNavItem(1)),
                      const SizedBox(width: 68),
                      Expanded(child: _buildNavItem(2)),
                      Expanded(child: _buildNavItem(3)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: bottomOffset + (barHeight * 0.50),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.createeventui),
              child: Container(
                height: fabSize,
                width: fabSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEC6D43).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFB670), Color(0xFFEC6D43)],
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isSelected) Get.offAllNamed(item.route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSelected ? item.activeIcon : item.inactiveIcon,
            height: 22,
            width: 22,
            colorFilter: ColorFilter.mode(
              isSelected ? const Color(0xFFEC6D43) : const Color(0xFF7E7E7E),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFEC6D43)
                    : const Color(0xFF7E7E7E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String activeIcon, inactiveIcon, label, route;
  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.route,
  });
}

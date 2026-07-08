import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class CategoryModel {
  final String label;
  final String iconPath;
  final Color bgColor;
  final Color iconColor;

  const CategoryModel({
    required this.label,
    required this.iconPath,
    required this.bgColor,
    required this.iconColor,
  });
}

class TrendingCategoryRow extends StatelessWidget {
  final ValueChanged<CategoryModel>? onCategoryTap;

  const TrendingCategoryRow({super.key, this.onCategoryTap});

  static const List<CategoryModel> categories = [
    CategoryModel(
      label: 'Music',
      iconPath: 'assets/icon/Frame (16).svg',
      bgColor: Color(0xFFE6DDFA),
      iconColor: Color(0xFF7C3AED),
    ),
    CategoryModel(
      label: 'Fitness',
      iconPath: 'assets/icon/Frame (17).svg',
      bgColor: Color(0xFFDFEFE2),
      iconColor: Color(0xFF10B981),
    ),
    CategoryModel(
      label: 'Tech',
      iconPath: 'assets/icon/Frame (18).svg',
      bgColor: Color(0xFFDEE5F7),
      iconColor: Color(0xFF2563EB),
    ),
    CategoryModel(
      label: 'Gaming',
      iconPath: 'assets/icon/Frame (19).svg',
      bgColor: Color(0xFFFEDFE5),
      iconColor: Color(0xFFDB2777),
    ),
    CategoryModel(
      label: 'Books',
      iconPath: 'assets/icon/Frame (20).svg',
      bgColor: Color(0xFFFFE5CF),
      iconColor: Color(0xFFD97706),
    ),
    CategoryModel(
      label: 'Coffee',
      iconPath: 'assets/icon/Frame (21).svg',
      bgColor: Color(0xFFF0E6E0),
      iconColor: Color(0xFF78350F),
    ),
    CategoryModel(
      label: 'More',
      iconPath: 'assets/icon/Frame (22).svg',
      bgColor: Color(0xFFF1EEE9),
      iconColor: Color(0xFF4B5563),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: () {
                if (onCategoryTap != null) {
                  onCategoryTap!(category);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Circle Icon Wrapper
                  Container(
                    height: 52.0, // Radius 26px => Diameter 52px
                    width: 52.0,
                    padding: const EdgeInsets.all(
                      10.0,
                    ), // Padding 5px-10px to fit SVGs inside
                    decoration: BoxDecoration(
                      color: category.bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(
                          0x1A939393,
                        ), // #939393 with 10% opacity
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000), // #000000 with 8% opacity
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      category.iconPath,
                      colorFilter: ColorFilter.mode(
                        category.iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    category.label,
                    style: AppTextStyle.inter(
                      size: 12,
                      weight: FontWeight.w500,
                      color: const Color(0xFF0C0A09),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

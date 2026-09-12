import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:get/get.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/core/route/app_routes.dart';

class CategoryModel {
  final String label;
  final String iconPath;
  final Color bgColor;
  final Color iconColor;
  final String? emoji;

  const CategoryModel({
    required this.label,
    required this.iconPath,
    required this.bgColor,
    required this.iconColor,
    this.emoji,
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

  CategoryModel _mapCategoryToModel(dynamic categoryNode) {
    final name = (categoryNode['name'] ?? categoryNode['slug'] ?? 'Unknown').toString();
    final slug = (categoryNode['slug'] ?? name).toString().toLowerCase();
    final apiEmoji = categoryNode['emoji']?.toString();

    // Map by slug or label
    for (var cat in categories) {
      if (cat.label.toLowerCase() == slug || cat.label.toLowerCase() == name.toLowerCase()) {
        return CategoryModel(
          label: name.isNotEmpty ? name : cat.label,
          iconPath: cat.iconPath,
          bgColor: cat.bgColor,
          iconColor: cat.iconColor,
          emoji: apiEmoji != null && apiEmoji.trim().isNotEmpty ? apiEmoji : cat.emoji,
        );
      }
    }
    
    // Fallback model if not in predefined list - generating dynamic color based on slug
    int hash = 0;
    for (var i = 0; i < slug.length; i++) {
       hash += slug.codeUnitAt(i);
    }
    final predefinedColorCategories = categories.where((c) => c.label != 'More').toList();
    final fallbackCat = predefinedColorCategories[hash % predefinedColorCategories.length];

    return CategoryModel(
      label: name,
      iconPath: 'assets/icon/Frame (22).svg', // generic icon
      bgColor: fallbackCat.bgColor,
      iconColor: fallbackCat.iconColor,
      emoji: apiEmoji,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Obx(() {
      if (homeCtrl.dynamicCategories.isEmpty) {
        return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: homeCtrl.dynamicCategories.map((categoryNode) {
            final category = _mapCategoryToModel(categoryNode);
            return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: () {
                if (onCategoryTap != null) {
                  onCategoryTap!(category);
                } else {
                  Get.toNamed(AppRoutes.categoryFiltered, arguments: {'slug': categoryNode['slug'], 'name': categoryNode['name']});
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
                    child: (category.emoji != null && category.emoji!.trim().isNotEmpty)
                      ? Center(
                          child: Text(
                            category.emoji!,
                            style: const TextStyle(fontSize: 22, height: 1.0),
                          ),
                        )
                      : SvgPicture.asset(
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
    });
  }
}

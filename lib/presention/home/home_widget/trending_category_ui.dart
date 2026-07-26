import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meetvibe/presention/home/home_widget/search_bar.dart';
import 'package:meetvibe/presention/home/home_widget/tendingcatory.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class TrendingCategoryUi extends StatelessWidget {
  const TrendingCategoryUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0C0A09)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Trending Category",
          style: AppTextStyle.poppins(
            size: 18,
            weight: FontWeight.bold,
            color: const Color(0xff2D292E),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SvgPicture.asset(
                'assets/icon/Frame (11).svg',
                width: 28,
                height: 28,
              ),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(

        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [

          SizedBox(height: 20), HomeSearchBar(),

          SizedBox(height: 20,),
          TrendingCategoryRow(),



        ]),
      ),
    );
  }
}

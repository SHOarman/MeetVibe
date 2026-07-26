import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _fullNameController = TextEditingController(text: "Mugdho");
  final TextEditingController _emailController = TextEditingController(text: "kader@gmail.com");
  final TextEditingController _dobController = TextEditingController(text: "12/11/2001");
  String? _selectedGender = "Male";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2001, 11, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 1,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Edit Profile",
                        style: AppTextStyle.outfit(
                          size: 24,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    "assets/image/59039 1 (1).png",
                    height: 120,
                    width: 120,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 30,
                    child: Text(
                      "Mugdho",
                      style: AppTextStyle.poppins(
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 260,
                    child: SvgPicture.asset(
                      "assets/icon/Vector (4).svg",
                      height: 20,
                      width: 20,
                    ),
                  ),

                  Positioned(
                    top: 65,
                    left: 130,
                    child: Text(
                      "@mugdho_23",
                      style: AppTextStyle.poppins(
                        size: 14,
                        weight: FontWeight.w400,
                        color: const Color(0xff323232),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 130,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Vector (5).svg",
                          height: 12,
                          width: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Dhaka, Bangladesh",
                          style: AppTextStyle.poppins(
                            size: 13,
                            weight: FontWeight.w400,
                            color: const Color(0xff7E7E7E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //=======================================Personal Information===========================
              const SizedBox(height: 40),

              Text(
                "Personal Information",
                style: AppTextStyle.poppins(
                  size: 16,
                  weight: FontWeight.w700,
                  color: Appcolors.black,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextfild(
                controller: _fullNameController,
                labelText: "Full Name",
                hintText: "Enter your full name",
              ),

              const SizedBox(height: 20),

              CustomTextfild(
                controller: _emailController,
                labelText: "Email Address",
                hintText: "Enter your email address",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              CustomTextfild(
                controller: _dobController,
                labelText: "Date of Birth",
                hintText: "Select your date of birth",
                readOnly: true,
                onTap: () => _selectDate(context),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    "assets/icon/Frame (24).svg",
                    height: 20,
                    width: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gender",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1D5DB),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1D5DB),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Appcolors.pramary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Appcolors.black,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Male",
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Male"),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Female",
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Female"),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Other",
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Other"),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: "Save",
                onTap: () {
                  Get.snackbar('Success', 'Profile updated successfully!');
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

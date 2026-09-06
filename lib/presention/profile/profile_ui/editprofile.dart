import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  final TextEditingController _dobController = TextEditingController(text: "12/11/2001");
  String? _selectedGender = "Male";
  File? _pickedImage;
  final ProfileController profileController = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());
  late Worker _nameWorker;
  late Worker _emailWorker;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: profileController.name.value);
    _emailController = TextEditingController(text: profileController.email.value);

    // Ensure controllers update if API fetches data *after* this page loads
    _nameWorker = ever(profileController.name, (String val) {
      if (_fullNameController.text.isEmpty && val.isNotEmpty) {
        _fullNameController.text = val;
      }
    });

    _emailWorker = ever(profileController.email, (String val) {
      if (_emailController.text.isEmpty && val.isNotEmpty) {
        _emailController.text = val;
      }
    });
  }

  @override
  void dispose() {
    _nameWorker.dispose();
    _emailWorker.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

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

              Obx(() {
                 if (profileController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                 }

                 final imageUrl = profileController.image.value;
                 final localImage = profileController.localImage.value;
                 final isVerified = profileController.isVerified.value;
                 final name = profileController.name.value.isEmpty ? "Name" : profileController.name.value;
                 final username = profileController.username.value.isEmpty ? "" : profileController.username.value;

                 return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: _pickedImage != null 
                              ? Image.file(
                                  _pickedImage!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : localImage.isNotEmpty
                                ? Image.file(
                                    File(localImage),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.person, size: 50),
                                    ),
                                  )
                                : Image.asset(
                                    "assets/image/59039 1 (1).png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.person, size: 50),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Appcolors.pramary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: AppTextStyle.poppins(
                                    size: 24,
                                    weight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isVerified) ...[
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  "assets/icon/Vector (4).svg",
                                  height: 20,
                                  width: 20,
                                ),
                              ]
                            ],
                          ),
                          if (username.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              username,
                              style: AppTextStyle.poppins(
                                size: 14,
                                weight: FontWeight.w400,
                                color: const Color(0xff323232),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }),

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
                readOnly: true, // Email should not be changed
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

              Obx(() => CustomButton(
                text: "Save",
                isLoading: profileController.isLoading.value,
                onTap: () async {
                  if (profileController.isLoading.value) return;

                  final success = await profileController.updateProfile(
                    _fullNameController.text,
                    null, // image upload not implemented in API
                    localImagePath: _pickedImage?.path,
                  );

                  if (success) {
                    Get.snackbar('Success', 'Profile updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
                    Get.offAllNamed(AppRoutes.homeui);
                  }
                },
              )),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/presention/event/event_controller/event_host_controller.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class ManageEventUi extends StatefulWidget {
  const ManageEventUi({super.key});

  @override
  State<ManageEventUi> createState() => _ManageEventUiState();
}

class _ManageEventUiState extends State<ManageEventUi> {
  final eventHostController = Get.isRegistered<EventHostController>() 
      ? Get.find<EventHostController>() 
      : Get.put(EventHostController());
      
  Map<String, dynamic>? event;
  String? eventId;

  @override
  void initState() {
    super.initState();
    event = Get.arguments as Map<String, dynamic>?;
    eventId = event?['id'] ?? event?['_id'];
    if (eventId != null) {
      eventHostController.getPendingPayments(eventId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          "Manage Event",
          style: AppTextStyle.poppins(size: 18, weight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (eventHostController.isLoadingPending.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pending = eventHostController.pendingParticipants;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pending Payments",
                style: AppTextStyle.outfit(size: 16, weight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              if (pending.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    "No pending offline payments at the moment.",
                    style: AppTextStyle.outfit(size: 14, weight: FontWeight.w400, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pending.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final participant = pending[index];
                    final participantId = participant['id'] ?? participant['_id'];
                    final user = participant['user'] ?? {};
                    final userName = user['name'] ?? 'Unknown User';

                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(Icons.person, color: Colors.white), // Use user['profileImage'] if available
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              userName,
                              style: AppTextStyle.outfit(size: 14, weight: FontWeight.w600, color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final success = await eventHostController.reviewPayment(participantId, "APPROVED");
                              if (success) {
                                Get.snackbar("Success", "$userName's payment approved.", backgroundColor: Colors.green, colorText: Colors.white);
                              } else {
                                Get.snackbar("Error", "Could not approve payment.", backgroundColor: Colors.red, colorText: Colors.white);
                              }
                            },
                            style: TextButton.styleFrom(backgroundColor: const Color(0xFFEC6D43), padding: const EdgeInsets.symmetric(horizontal: 10)),
                            child: const Text("Approve", style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 30),
              
              // Finalize Attendance Section
              Text(
                "Finalize Event",
                style: AppTextStyle.outfit(size: 16, weight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      "Once the event is complete, click here to finalize attendance and release escrow payments. For now, this approves all automatically.",
                      style: AppTextStyle.outfit(size: 13, weight: FontWeight.w400, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (eventId == null) return;
                        
                        // NOTE: You would normally build the attendance array by iterating over all accepted participants.
                        // Since we just have the API, we pass an empty array or an array of the required users.
                        // You can adjust `[]` to match any specific participants list when available.
                        final success = await eventHostController.finalizeAttendance(eventId!, []);
                        if (success) {
                          Get.snackbar("Success", "Event finalized and funds released!", backgroundColor: Colors.green, colorText: Colors.white);
                        } else {
                          Get.snackbar("Error", "Could not finalize event.", backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC6D43),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: eventHostController.isFinalizing.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Finalize Attendance", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Common Widgets/constants.dart';
import '../../Controllers/message_sending.dart';
import '../Announcements/announcements_screen.dart';
import '../LiveStreaming/sos_page.dart';

class PoliceOptions extends StatefulWidget {
  const PoliceOptions({Key? key}) : super(key: key);

  @override
  State<PoliceOptions> createState() => _PoliceOptionsState();
}

class _PoliceOptionsState extends State<PoliceOptions> {
  final smsController = Get.put(messageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(color),
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(Get.height * 0.1),
            child: Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: const AssetImage(
                              "assets/logos/emergencyAppLogo.png"),
                          height: Get.height * 0.08),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Police Options",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/logos/policeman.png"),
              height: Get.height * 0.10,
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Color(color),
                leading: const Icon(
                  Icons.map,
                  color: Colors.yellowAccent,
                ),
                title: const Text(
                  'Police Station Map Display',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Find the nearest police station on the map',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  var lat = position.latitude;
                  var long = position.longitude;
                  String url = '';
                  String urlAppleMaps = '';
                  if (Platform.isAndroid) {
                    url =
                    "https://www.google.com/maps/search/police+station/@$lat,$long,12.5z";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  } else {
                    urlAppleMaps = 'https://maps.apple.com/?q=$lat,$long';
                    url =
                    'comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
                      await launchUrl(Uri.parse(urlAppleMaps));
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Color(color),
                leading: const Icon(
                  Icons.call,
                  color: Colors.yellowAccent,
                ),
                title: const Text(
                  'Call ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Directly call the police station hotline',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  String? policePhone;
                  final refsResponder = FirebaseDatabase.instance.ref("Users");
                  try {
                    // Query the database for all users
                    final snapshot = await refsResponder.get();

                    if (snapshot.exists) {
                      // Iterate through all users to find UserType = 'Fire'
                      for (final user in snapshot.children) {
                        if (user.child("UserType").value == "Police") {
                          //zanecoUserUID = user.key;
                          policePhone = user.child("Phone").value.toString();
                          break; // Exit the loop once we find the first match
                        }
                      }
                    } else {}
                  } catch (error) {
                    print("Error fetching Fire User UID: $error");
                  }

                  if (policePhone == null || policePhone.isEmpty) {
                    Get.snackbar('Error', 'No phone number available');
                    return;
                  }

                  if (await Permission.phone.request().isGranted) {
                    debugPrint("In making phone call");
                    var uri = Uri.parse('tel:$policePhone');
                    await launchUrl(uri);
                    debugPrint("Phone  Permission is granted");
                  } else {
                    debugPrint("Phone  Permission is denied.");
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Color(color),
                leading: const Icon(
                  Icons.announcement,
                  color: Colors.yellowAccent,
                ),
                title: const Text(
                  'View Announcements',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'View current announcements and advisories',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Get.to(() => const AnnouncementsScreen(
                    department: 'Police',
                    departmentName: 'Police Department',
                  ));
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width * 0.8,
              height: Get.height * 0.1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String userMessage = "";
                      File? selectedImage;
                      File? selectedVideo;
                      final imagePicker = ImagePicker();

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text("Report Police Emergency"),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      userMessage = value.trim();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Describe the emergency situation",
                                      labelText: "Emergency Description",
                                    ),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  if (selectedImage != null)
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: FileImage(selectedImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              selectedImage = null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  if (selectedVideo != null)
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.grey[300],
                                          ),
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.videocam, size: 40),
                                                Text('Video Selected'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              selectedVideo = null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.image),
                                          label: const Text("Add Image"),
                                          onPressed: () async {
                                            final XFile? image = await imagePicker.pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 70,
                                            );
                                            if (image != null) {
                                              setState(() {
                                                selectedImage = File(image.path);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.videocam),
                                          label: const Text("Add Video"),
                                          onPressed: () async {
                                            final XFile? video = await imagePicker.pickVideo(
                                              source: ImageSource.gallery,
                                            );
                                            if (video != null) {
                                              setState(() {
                                                selectedVideo = File(video.path);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("Send Alert"),
                                onPressed: () {
                                  Navigator.of(context).pop({
                                    'message': userMessage,
                                    'image': selectedImage,
                                    'video': selectedVideo,
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ).then((result) {
                    if (result != null && result['message'].isNotEmpty) {
                      saveCurrentLocation(result['message']).whenComplete(() {
                        smsController.sendLocationViaSMS("Police Emergency\nSend Police at");
                      });
                    } else {
                      Get.snackbar("Description Required", "You must enter an emergency description to proceed.");
                    }
                  });
                },
                child: const Text("Send Alert", style: TextStyle(fontSize: 40)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveCurrentLocation(String message) async {

    String? policeUserUID;
    String phone = '';
    final refsResponder = FirebaseDatabase.instance.ref("Users");


      final snapshot = await refsResponder.get();
      if (snapshot.exists) {
        for (final user in snapshot.children) {
          if (user.child("UserType").value == "Police") {
            policeUserUID = user.key;
            phone = user.child("Phone").value.toString();
            break;
          }
        }

      } else {}

    String videoId = sessionController.userid.toString();
    final user = FirebaseAuth.instance.currentUser;


    try {
      // Check location permissions first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      try {
        // Try to get placemark
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

          // Firebase reference
          final ref = FirebaseDatabase.instance.ref("assigned/$policeUserUID");

          // Set data
          await ref.set({
            "time": "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            'responderID': policeUserUID,
            'userID': user!.uid.toString(),
            'userLat': position.latitude.toString(),
            'userLong': position.longitude.toString(),
            'userAddress': address,
            'userMessage': message,
            'userPhone': phone,
            'responderType': 'Police',
          });
        }
      } catch (e) {
        print('Geocoding error: $e');
        // Fallback if placemark conversion fails
        final ref = FirebaseDatabase.instance.ref("assigned/$policeUserUID");
        await ref.set({
          "time": "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          'responderID': policeUserUID,
          'userID': user!.uid.toString(),
          'userLat': position.latitude.toString(),
          'userLong': position.longitude.toString(),
          'userAddress': 'Address not available',
          'userMessage': message,
          'userPhone': phone,
          'responderType': 'Police',
        });
      }
    } catch (e) {
      print('Location error: $e');
    }
        Get.snackbar("Success", 'Successfully send your location to the rescue headquarters');



  }

  jumpToLiveStream(String liveId, bool isHost) {
    if (liveId.isNotEmpty) {
      // Get.to(
      //       () => LiveStreamingPage(
      //     liveId: liveId,
      //     isHost: isHost,
      //   ),
      // );
    } else {
      Get.snackbar("Error", "Please enter a valid ID");
    }
  }
}

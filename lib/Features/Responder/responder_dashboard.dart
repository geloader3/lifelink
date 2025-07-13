import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emergencyrespo3712/Features/User/Screens/LiveStreaming/sos_page.dart';
import '../User/Screens/Profile/profile_screen.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Common Widgets/constants.dart';
import '../User/Controllers/message_sending.dart';
import '../User/Screens/LiveStreaming/live_stream.dart';
import 'dart:math';



class ResponderDashboard extends StatefulWidget {
  const ResponderDashboard({Key? key}) : super(key: key);
  @override
  State<ResponderDashboard> createState() => _ResponderDashboardState();
}

final user = FirebaseAuth.instance.currentUser;
final assignmedRef =
FirebaseDatabase.instance.ref().child('assigned/${user!.uid}');
final activeRespondersRef =
FirebaseDatabase.instance.ref().child('activeResponders');
final userRef = FirebaseDatabase.instance.ref().child('Users');
String userType = '';
final locationController = Get.put(messageController());
late Position position;
String status = '';
bool _switchValue = false;

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

class _ResponderDashboardState extends State<ResponderDashboard> {
  final user = FirebaseAuth.instance.currentUser;
  // var Value = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
    debugPrint(_switchValue.toString());
  }

  Future<void> _loadSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _switchValue = prefs.getBool('switchValue') ?? false;
    });
  }

  Future<void> _saveSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(color),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(color: Colors.white24, width: 4)),
        onPressed: () {
          Get.to(() => const ProfileScreen());
        },
        child: const Icon(Icons.person),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      extendBodyBehindAppBar: false,
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
          preferredSize: Size.fromHeight(Get.height * 0.16),
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
                        height: Get.height * 0.07),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Responder Dashboard",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SlidingSwitch(
                        value: _switchValue,
                        // initial value of the switch
                        width: 100.0,
                        // width of the switch
                        onChanged: (value) {
                          setState(() {
                            _saveSwitchValue(value);
                            _switchValue = value;
                            status = getStatus();
                          });
                          _saveSwitchValue(value);
                          // Value = value;
                        },
                        height: 40.0,
                        // borderRadius: 20.0,
                        textOff: 'OFF',
                        textOn: 'ON',
                        colorOn: Colors.green,
                        colorOff: Colors.red,
                        onSwipe: () {
                          debugPrint(_switchValue.toString());
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: assignmedRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: ListTile(
                  tileColor: Color(color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'No Emergency Request Yet',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            Map<dynamic, dynamic> list = dataSnapshot.value as dynamic ?? Map();
            // List<dynamic> list = [];
            // list.clear();
            // list = map.values.toList();
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                  child: ListTile(
                      onTap: () async {
                        var lat = list['userLat'];
                        var long = list['userLong'];
                        String url = '';
                        String urlAppleMaps = '';
                        if (list['userLat'] == null ||
                            list['userLong'] == null) {
                          Get.snackbar('Error', 'No Emergency Location Found');
                          return;
                        } else {
                          if (Platform.isAndroid) {
                            url =
                            'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          } else {
                            urlAppleMaps =
                            'https://maps.apple.com/?q=$lat,$long';
                            url =
                            'comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else if (await canLaunchUrl(
                                Uri.parse(urlAppleMaps))) {
                              await launchUrl(Uri.parse(urlAppleMaps));
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        }
                      },
                      tileColor: Color(color),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        list['userAddress'] ?? 'No Emergency Request Yet',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Message: ${list['userMessage'] ?? 'No message available'}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Phone: ${list['userPhone'] ?? 'No phone available'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green, size: 30),
                          onPressed: () async {
                            final phone = list['userPhone'];
                            if (phone == null || phone.isEmpty) {
                              Get.snackbar('Error', 'No phone number available');
                              return;
                            }

                            if (await Permission.phone.request().isGranted) {
                              debugPrint("In making phone call");
                              var uri = Uri.parse('tel:$phone');
                              await launchUrl(uri);
                              debugPrint("Phone  Permission is granted");
                            } else {
                              debugPrint("Phone  Permission is denied.");
                            }

                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.video_call, color: Colors.red, size: 30),
                          onPressed: () {
                            if (list['userLat'] == null || list['userLong'] == null) {
                              Get.snackbar('Error', 'No Emergency Request Yet');
                              return;
                            } else {

                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green, size: 30),
                          onPressed: () {
                            final userid = list['responderID'];
                            final assignedRef =
                            FirebaseDatabase.instance.ref().child('assigned');

                            if (userid == null) {
                              Get.snackbar('Error', 'No user ID available');
                              return;
                            }

                            // Remove the assignment
                            assignedRef.child(userid.toString()).remove().then((_) {
                              Get.snackbar('Success', 'Assignment removed successfully');
                            }).catchError((error) {
                              Get.snackbar('Error', 'Failed to remove assignment: $error');
                            });
                          },
                        ),
                      ],
                    ),


                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  String getStatus() {
    if (_switchValue == true) {
      // setResponderData();
      setState(() {
        status = 'Available';
        setResponderData();
      });
    } else {
      setState(() {
        status = 'Unavailable';
        activeRespondersRef.child(user!.uid.toString()).remove();
      });
    }
    return status;
  }

  Color setColor() {
    if (Value == true) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  setResponderData() async {
    userType = '';
    await smsController.handleLocationPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) async {
      try {
        await userRef
            .child(user!.uid.toString())
            .get()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.value as dynamic;
            userType = map['UserType'];
            activeRespondersRef.child(user!.uid.toString()).set({
              "lat": position.latitude.toString(),
              "long": position.longitude.toString(),
              "responderType": userType,
              "responderID": user!.uid.toString(),
            });
          } else {
            userType = 'DK BRuh';
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  getUserType() async {
    try {
      await userRef
          .child(user!.uid.toString())
          .get()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> map = snapshot.value as dynamic ?? {};

          return map['UserType'];
        } else {
          return '';
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
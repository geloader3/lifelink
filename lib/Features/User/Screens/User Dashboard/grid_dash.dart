import 'package:emergencyrespo3712/Features/User/Screens/ZanecoOptions/zaneco_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AmbulanceOptions/AmbulanceOptions.dart';
import '../FirefighterOptions/firefighter_options.dart';
import '../PoliceOptions/police_options.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = Items(
      title: "Police Station",
      subtitle: "Emergency Police Services",
      event: "",
      img: "assets/logos/policeman.png");

  Items item2 = Items(
    title: "Fire Station",
    subtitle: "Emergency Fire Services",
    event: "",
    img: "assets/logos/fire-truck.png",
  );

  Items item3 = Items(
    title: "Medical Services",
    subtitle: "Emergency Medical Services",
    event: "",
    img: "assets/logos/ambulance.png",
  );
  Items item4 = Items(
    title: "Utility Services",
    subtitle: "Emergency Utility Services",
    event: "",
    img: "assets/logos/zaneco.png",
  );

  GridDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4];
    var color = 0xff2471A3;
    return GridView.count(
        childAspectRatio: 1.0,
        padding: const EdgeInsets.only(left: 6, right: 6),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return GestureDetector(
            onTap: () {
              if (data.title == "Police Station") {
                Get.to(() => const PoliceOptions());
              } else if (data.title == "Fire Station") {
                Get.to(() => const FireFighterOptions());
              } else if (data.title == "Medical Services") {
                Get.to(() => const AmbulanceOptions());
              } else if (data.title == "Utility Services") {
                Get.to(() => const ZanecoOptions());
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(color), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Image.asset(
                      data.img,
                      width: 42,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.event,
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }).toList());
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items(
      {required this.title,
      required this.subtitle,
      required this.event,
      required this.img});
}

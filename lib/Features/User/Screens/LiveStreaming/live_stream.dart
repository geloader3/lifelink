// import 'package:flutter/cupertino.dart';
// import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
// import 'keys.dart';
//
// class LiveStreamingPage extends StatelessWidget {
//   final String liveId;
//   final bool isHost;
//
//   const LiveStreamingPage({Key? key, required this.liveId, this.isHost = false}) : super(key: key);
//   // const LiveStreamingPage(
//   //     {Key? key, required this.isHost, required this.liveId})
//   //     : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ZegoUIKitPrebuiltLiveStreaming(
//         appID: 1267942805,// Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign: "54d8aad0911cdc143a9573ebd90f894453bae2b0219db4323dcaf9becb525e49",// Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: Keys().userId,
//         userName: "user_${Keys().userId}",
//         liveID: liveId,
//         config: isHost
//             ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
//             : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
//       ),
//     );
//   }
// }

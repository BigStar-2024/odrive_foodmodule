import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';

class CallScreen extends StatefulWidget {
  final String imageUrl;
  const CallScreen({super.key, required this.imageUrl});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: "Call"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RippleAnimation(
                  child: CircleAvatar(
                    minRadius: 75,
                    maxRadius: 75,
                    backgroundImage: NetworkImage(widget.imageUrl),
                  ),
                  color: primaryColor,
                  delay: const Duration(milliseconds: 300),
                  repeat: true,
                  minRadius: 75,
                  ripplesCount: 6,
                  duration: const Duration(milliseconds: 6 * 300),
                ),
                SizedBox(height: 80),
                Text("JackStauber", style: text32GrayScale100),
                SizedBox(height: 8),
                Text("02:25", style: text18GreyScale800),
                SizedBox(height: 60),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        color: greyShade3,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.volume_up, size: 36),
                    ),
                    SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                          color: greyShade3,
                          borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.mic, size: 36),
                    ),
                    SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.call_end, size: 36, color: Colors.white,),
                    )
                  ],
                )
              ],
            )
          ),
                  ],
      )
    );
  }
}

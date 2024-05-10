import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odrive/pages/auth/login.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessageAppBar(titleText: "Message"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Center(child: Text("No message"))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.camera_alt_rounded, color: greyColor800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.photo_rounded, color: greyColor800),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                //Champs input text ici
                Expanded(child:
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: ShapeDecoration(
                    color: Color(0xFFF2F2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Entrez votre message...',
                      border: InputBorder.none
                    ),
                  ),
                )
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.send
                ),
                // SvgPicture.asset("assets/message/send.svg"),
                SizedBox(width: 8),
                /* Row(
                    // Utilise la largeur de l'écran
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: ShapeDecoration(
                          color: Color(0xFFF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Enter your text here...',
                            labelText: 'Text',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]), */
                /* Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Color(0xFFF2F2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Enter message...',
                              style: TextStyle(
                                color: Color(0xFF78828A),
                                fontSize: 14,
                                fontFamily: 'Abel',
                                fontWeight: FontWeight.w400,
                                height: 0.10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 170),
                      Container(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: Stack(children: [
                                SvgPicture.asset("assets/message/send.svg")
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) */
              ],
            ),
          )
                  ],
      )
    );
  }
}

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  MessageAppBar({required this.titleText});
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 3,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: greyScale90Color),
        onPressed: () {
          // Action à effectuer lorsqu'on appuie sur la flèche de retour
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        titleText,
        style: text20GrayScale100,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: Colors.black),
          tooltip: "Call",
          onPressed: (){

          },
        )
      ],
    );
  }
}

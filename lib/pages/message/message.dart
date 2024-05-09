import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odrive/pages/auth/login.dart';

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
      appBar: MyAppBar(titleText: "Message"),
      body: SingleChildScrollView(),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Stack(children: [
                          SvgPicture.asset('assets/message/camera.svg')
                        ]),
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
                        child: Stack(children: [
                          SvgPicture.asset('assets/message/image.svg')
                        ]),
                      ),
                    ],
                  ),
                ),
                //Champs input text ici
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.height / 17,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Color(0xFFF2F2F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Entrez votre message...',
                        //border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset("assets/message/send.svg")
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
          ),
        ],
      ),
    );
  }
}

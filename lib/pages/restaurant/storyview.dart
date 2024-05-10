
import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";

import '../../backend/api.dart';

/*
*  StoryViews
* */
class StoryRestaurantScreen extends StatefulWidget {
  final List<StoryItem> storyItems;
  final StoryController storyController;

  StoryRestaurantScreen({required this.storyItems, required this.storyController});

  @override
  _StoryRestaurantState createState() => _StoryRestaurantState();
}

class _StoryRestaurantState extends State<StoryRestaurantScreen> {
  // final controller = StoryController();
  // List<StoryItem> storyItems = [];

  @override
  Widget build(BuildContext context) {
    return StoryView(
        storyItems: widget.storyItems,
        controller: widget.storyController, // pass controller here too
        repeat: true, // should the stories be slid forever
        onStoryShow: (s) {},
        onComplete: () {},
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        } // To disable vertical swipe gestures, ignore this parameter.
    );
  }
}
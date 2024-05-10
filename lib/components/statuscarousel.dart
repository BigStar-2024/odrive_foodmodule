import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../backend/api.dart';

/*
*  ImageCarousel
* */
class StatusCarousel extends StatefulWidget {
  final List<dynamic> statusData;

  StatusCarousel({required this.statusData});

  @override
  _StatusCarouselState createState() => _StatusCarouselState();
}

class _StatusCarouselState extends State<StatusCarousel> {
  final CarouselController _carouselController = CarouselController();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _carouselController.jumpToPage(_pageController.page!.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 19 / 7,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.statusData.map((data) {
            String imageUrl = data['media_url'] ?? '';
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.network(
                    "$serverImages$imageUrl",
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
          carouselController: _carouselController,
        ),
        SizedBox(height: 10),
        /* Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.bannerData.length,
            effect: ExpandingDotsEffect(
              spacing: 8.0,
              radius: 8.0,
              dotWidth: 16.0,
              dotHeight: 16.0,
              dotColor: Colors.black26,
              activeDotColor: Colors.black,
            ),
          ),
        ), */
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  //Slideshow
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Bắt đầu slideshow sau 3 giây và chuyển trang sau mỗi 3 giây.
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _sliderImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  final List<String> _sliderImages = [
    'assets/sl1.jpg',
    'assets/sl2.jpg',
    'assets/sl3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _slider = _sliderImages
        .map((image) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ))
        .toList();

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.05,
                // horizontal: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * (1 / 4),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: _slider,
                ),
              ),
            ),
            Container(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: _slider.length,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 5,
                  dotColor: Color.fromRGBO(217, 217, 217, 1),
                  activeDotColor: Color.fromRGBO(102, 102, 102, 1),
                  paintStyle: PaintingStyle.fill,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text('Page 1')
          ],
        ),
      ),
    );
  }
}

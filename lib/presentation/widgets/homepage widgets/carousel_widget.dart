import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/breacking_card_widget.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key, required this.news});
  final List<Articles> news;
  

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int currentPage = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: 280,
    child: CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.news.length,
      itemBuilder: (context, index, realIndex) {
        return buildBreakingCard(context, widget.news[index], index);
      },
      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 500),
        autoPlayCurve: Curves.easeInOut,
        pauseAutoPlayOnTouch: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() => currentPage = index);
        },
      ),
    ),
  );
  }
}

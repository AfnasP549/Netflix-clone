import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/tv_series_model.dart';

class CustomCarousel extends StatelessWidget {
  final TvSeriesModel data;
  const CustomCarousel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: CarouselSlider.builder(
        itemCount: data.results?.length ?? 0, // Null check on results
        itemBuilder: (BuildContext context, int index, int realIndex) {
          // Handle potential null values for backdropPath and name
          var url = data.results?[index].backdropPath ?? ''; // Fallback to an empty string
          var name = data.results?[index].name ?? 'Unknown'; // Fallback to 'Unknown'

          return GestureDetector(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: "$imageUrl$url", // Handle backdropPath safely
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 20),
                Text(
                  name, // Safely displaying the name with a fallback
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
          aspectRatio: 16 / 9,
          reverse: false,
          initialPage: 0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

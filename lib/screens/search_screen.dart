import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_recommendation_model';
import 'package:netflix_clone/models/search_model.dart';
import 'package:netflix_clone/screens/movie_detail_screen.dart';
import 'package:netflix_clone/services/api_service.dart';
import 'package:netflix_clone/widgets/color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  ApiService apiService = ApiService();
  SearchModel? searchModel;

  late Future<MovieRecommendationModel> getMovieRecommendation;

  void search(String query) {
    apiService.getSearchMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMovieRecommendation = apiService.getMovieRecommendation();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CupertinoSearchTextField(
                padding: const EdgeInsets.all(10),
                controller: searchController, // Use the correct controller
                prefixIcon: Icon(
                  Icons.search,
                  color: MyColor.Grey,
                ),
                suffixIcon: Icon(
                  Icons.cancel,
                  color: MyColor.Grey,
                ),
                style: TextStyle(color: MyColor.White),
                backgroundColor: MyColor.LGrey,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      searchModel =
                          null; // Reset the results if the field is empty
                    });
                  } else {
                    search(value); // Use the entered value for search
                  }
                },
              ),
              searchController.text.isEmpty
                  ? FutureBuilder(
                      future: getMovieRecommendation,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.results;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "Top Searches",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                  itemCount: data!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailScreen(
                                              movieId: (data[index].id as int),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 150,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.network(
                                                "${imageUrl}${data[index].posterPath}"),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 260,
                                              child: Text(
                                                data[index].title ??
                                                    "No title available",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      })
                  : searchModel == null
                      ? const SizedBox.shrink()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchModel?.results.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent:200, // Adjust the height to fit image and text
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 1.2 / 2),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                        movieId:
                                            searchModel!.results[index].id),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  searchModel?.results[index].backdropPath ==
                                          null
                                      ? Image.asset(
                                          "assets/netflix.jpg",
                                          height: 170,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              "${imageUrl}${searchModel!.results[index].backdropPath}",
                                          height: 170,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                  // Flexible widget to handle text overflow
                                  Expanded(
                                    child: SizedBox(
                                      width: 100, // Set the width for the text
                                      child: Text(
                                        searchModel?.results[index]
                                                .originalTitle ??
                                            '',
                                        maxLines: 2,
                                        overflow: TextOverflow
                                            .ellipsis, // Text overflow handling
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: MyColor.White,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

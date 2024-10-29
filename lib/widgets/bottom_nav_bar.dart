import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/home_screen.dart';
import 'package:netflix_clone/screens/new_and_hot.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/widgets/color.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: MyColor.Black,
          height: 70,
          child: TabBar(tabs: const [
            Tab(
              icon: Icon(Icons.home),
              text: "Home",          
            ),
      
             Tab(
              icon: Icon(Icons.search),
              text: "Search",
             ),
      
              Tab(
              icon: Icon(Icons.photo_library_outlined),
              text: "New & Hot",
             )
          ],
          indicatorColor: Colors.transparent,
          labelColor: MyColor.White,
          unselectedLabelColor: const Color(0xff999999),
          ),
        ),

        body: const TabBarView(children: [
          Homescreen(),
          SearchScreen(),
          NewAndHot(),
          
        ]),
      ),
    );
  }
}
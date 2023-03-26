import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cs_project/views/search_screen.dart';
import 'anime_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> animeList = [];
  int _currentPage = 0;
  bool _isLoading = false;
  List<dynamic> watchList = [];

  Future<void> _fetchAnimeData(int page) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://kitsu.io/api/edge/anime?page[limit]=20&page[offset]=$page')); // uses the http method to fetch api data

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body); // parses the json
      final animeData =
          parsedJson['data']; // adds the data received from the api into a list
      setState(() {
        animeList.addAll(animeData); // moves the animeData list into animeList
        _isLoading = false; // disables the circular progress indicator
      });
    } else {
      throw Exception(
          'Failed to load anime list'); // displays an error if a status code other than 200 is received
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAnimeData(
        _currentPage); // calls the fetch anime function and passes the value in _currentPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creating the floating action button to navigate to search_screen.dart:
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnimeSearchScreen(),
              ));
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.search),
      ),
      body: NotificationListener<ScrollNotification>(
        // makes list scrollable by listening for notifications
        onNotification: (scrollNotification) {
          if (!_isLoading &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
            _currentPage = _currentPage +
                20; // increments the point from where pages are called from
            _fetchAnimeData(_currentPage);
            return true;
          } // calls the fetchAnimeFunction when a user scrolls to the bottom of the list to call the next 20 pages from the Api
          return false;
        },
        child: ListView.builder(
          itemCount: animeList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == animeList.length) {
              return _buildProgressIndicator();
            } else {
              final animeData = animeList[index];
              final animeAttributes = animeData['attributes'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimeDetailScreen(
                        animeData: animeData,
                      ),
                    ), // displays the Anime Detail Screen when the list tile is pressed and passes animeData
                  );
                },
                child: ListTile(
                  leading: Image.network(animeAttributes['posterImage']
                      ['small']), //fetches the poster image of each anime
                  title: Text(animeAttributes[
                      'canonicalTitle']), // fetches the canonical title of each anime
                  subtitle: Text(animeAttributes[
                      'startDate']), // fetches the start date of each anime
                ), // Creates the List Tile that is displayed by the list view builder
              ); // Gesture Detector
            }
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    // creats the widget that displays the circular progress indicator
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container();
  }
}

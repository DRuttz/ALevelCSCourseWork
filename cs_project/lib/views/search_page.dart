import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cs_project/views/search_screen.dart';
import 'anime_details.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AnimeListScreenState createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen> {
  List<dynamic> animeList = [];
  int _currentPage = 0;
  bool _isLoading = false;
  List<dynamic> watchList = [];

  Future<void> _fetchAnimeData(int page) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://kitsu.io/api/edge/anime?page[limit]=20&page[offset]=$page'));

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      final animeData = parsedJson['data'];
      setState(() {
        animeList.addAll(animeData);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load anime list');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAnimeData(_currentPage);
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
        onNotification: (scrollNotification) {
          if (!_isLoading &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
            _currentPage = _currentPage + 20;
            _fetchAnimeData(_currentPage);
            return true;
          }
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
                    ),
                  );
                },
                child: ListTile(
                  leading:
                      Image.network(animeAttributes['posterImage']['small']),
                  title: Text(animeAttributes['canonicalTitle']),
                  subtitle: Text(animeAttributes['startDate']),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'anime_details.dart';
//Creating the search screen

class AnimeSearchScreen extends StatefulWidget {
  const AnimeSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimeSearchScreenState createState() => _AnimeSearchScreenState();
}

class _AnimeSearchScreenState extends State<AnimeSearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchAnime(String query) async {
    setState(() {
      _isLoading = true;
    });
    final response = await http
        .get(Uri.parse('https://kitsu.io/api/edge/anime?filter[text]=$query'));

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      final searchResults = parsedJson['data'];
      setState(() {
        _searchResults = searchResults;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to search for anime');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Search Anime'),
        //Creating the icon button to go back to search_page.dart
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  hintText: 'Enter an anime title',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  )),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final query = _searchController.text;
              if (query.isNotEmpty) {
                _searchAnime(query);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Search'),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      final animeData = _searchResults[index];
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
                          leading: Image.network(
                              animeAttributes['posterImage']['small']),
                          title: Text(animeAttributes['canonicalTitle']),
                          subtitle: Text(animeAttributes['startDate']),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

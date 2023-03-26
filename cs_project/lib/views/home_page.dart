import 'package:flutter/material.dart';
import 'package:cs_project/watchlist_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isListViewVisible = true;
  Future<List<Map<String, dynamic>>> _animeDataFuture =
      WatchlistDatabase.instance.getAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Watchlist'),
        shape: Border(bottom: BorderSide(color: Colors.black, width: 1)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
                _isListViewVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isListViewVisible = !_isListViewVisible;
              });
            },
          ),
        ],
      ),
      body: Visibility(
        visible: _isListViewVisible,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _animeDataFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final animeData = snapshot.data!;
            return ListView.builder(
              itemCount: animeData.length,
              itemBuilder: (context, index) {
                final anime = animeData[index];
                final TextEditingController controller =
                    TextEditingController();

                // Create a local copy of the data
                final Map<String, dynamic> animeCopy = Map.from(anime);

                return ListTile(
                  title: Text(anime[WatchlistDatabase.columnTitle]),
                  leading:
                      Image.network(anime[WatchlistDatabase.columnPosterImage]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await WatchlistDatabase.instance.delete(
                        anime[WatchlistDatabase.columnId],
                      );
                      setState(() {
                        // Rebuild the future to show updated data
                        _animeDataFuture = WatchlistDatabase.instance.getAll();
                      });
                    },
                  ),
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('How many episodes have you watched?'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(controller.text);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    if (result != null) {
                      final watchedEpisodes = int.tryParse(result);
                      if (watchedEpisodes != null) {
                        // Update the local copy of the data
                        animeCopy['watched_episodes'] = watchedEpisodes;

                        // Update the database with the new data
                        await WatchlistDatabase.instance.update(
                          anime[WatchlistDatabase.columnId],
                          {'watched_episodes': watchedEpisodes},
                        );

                        setState(() {
                          // Rebuild the future to show updated data
                          _animeDataFuture =
                              WatchlistDatabase.instance.getAll();
                        });
                      }
                    }
                  },
                  subtitle: animeData[index]['watched_episodes'] != null
                      ? animeData[index]['watched_episodes'] >=
                              anime[WatchlistDatabase.columnEpisodeCount]
                          ? Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              'Episodes watched: ${animeData[index]['watched_episodes']}/${anime[WatchlistDatabase.columnEpisodeCount]}',
                            )
                      : Text(
                          'Episodes watched: 0/${anime[WatchlistDatabase.columnEpisodeCount]}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

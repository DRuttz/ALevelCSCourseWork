import 'package:flutter/material.dart';
import 'package:cs_project/watchlist_database.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isDarkModeEnabled}) : super(key: key);
  final bool isDarkModeEnabled;
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
} // creates the stateful widget which will display the watchlist database

class _HomePageState extends State<HomePage> {
  // creates the HomePageState which is displayed by the HomePage widget
  bool _isListViewVisible =
      true; //boolean logic for whether the list shall bew viewable or not.
  Future<List<Map<String, dynamic>>> _animeDataFuture =
      WatchlistDatabase.instance.getAll(); // calls all of the database data

  @override
  Widget build(BuildContext context) {
    print('home isDarkModeEnabled: ${widget.isDarkModeEnabled}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Watchlist',
          style: TextStyle(
              color: widget.isDarkModeEnabled ? Colors.white : Colors.white),
        ),
        shape: const Border(
            bottom: BorderSide(
                color: Colors.black,
                width:
                    1)), // creates the thin line between watchlist and the animes
        elevation:
            0, // causes there to not be any shadow between the watchlist appbar and animes
        backgroundColor: Colors.grey[850], // makes the app bar transparent
        actions: [
          IconButton(
            // creates a button
            icon: Icon(_isListViewVisible
                ? Icons.visibility_off
                : Icons.visibility), //changes the appearance of the button
            onPressed: () {
              setState(() {
                _isListViewVisible =
                    !_isListViewVisible; // changes the boolean value of isListViewVisible
              });
            },
          ),
        ],
      ),
      body: Visibility(
        //visibility class, can hide or show the child
        visible:
            _isListViewVisible, // links the visibility class to the boolean variable
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future:
              _animeDataFuture, // sets the future to the received database data
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
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
                  // sets the title to the title of the anime at the current index on the database
                  leading:
                      Image.network(anime[WatchlistDatabase.columnPosterImage]),
                  // displays the poster of the anime at the current index on the database
                  trailing: IconButton(
                    // creates a button
                    icon: const Icon(Icons.delete),
                    // sets the button icon to a bin
                    onPressed: () async {
                      await WatchlistDatabase.instance.delete(
                        anime[WatchlistDatabase.columnId],
                        // calls the delete method to remove the anim from the database
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
                        title:
                            const Text('How many episodes have you watched?'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(controller.text);
                            },
                            child: const Text('OK'),
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
                          // Updates the displayed list with the updated data on the database
                          _animeDataFuture =
                              WatchlistDatabase.instance.getAll();
                        });
                      }
                    }
                  },
                  subtitle: animeData[index]['watched_episodes'] != null
                      ? animeData[index]['watched_episodes'] >=
                              anime[WatchlistDatabase.columnEpisodeCount]
                          ? const Text(
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

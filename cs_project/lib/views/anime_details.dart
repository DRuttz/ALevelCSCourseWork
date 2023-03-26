import 'package:flutter/material.dart';
import 'package:cs_project/watchlist_database.dart';
import 'package:sqflite/sqflite.dart';

class AnimeDetailScreen extends StatelessWidget {
  final dynamic animeData;

  const AnimeDetailScreen({Key? key, required this.animeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animeAttributes = animeData['attributes'];
    return Scaffold(
        appBar: AppBar(
          title: Text(animeAttributes['canonicalTitle']),
          backgroundColor: Colors.redAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(animeAttributes['posterImage']['large']),
                const SizedBox(height: 16.0),
                Text(animeAttributes['canonicalTitle'],
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8.0),
                Text(animeAttributes['synopsis'],
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8.0),
                Text('Start Date: ${animeAttributes['startDate']}',
                    style: Theme.of(context).textTheme.bodySmall),
                Text('End Date: ${animeAttributes['endDate']}',
                    style: Theme.of(context).textTheme.bodySmall),
                Text('Status: ${animeAttributes['status']}',
                    style: Theme.of(context).textTheme.bodySmall),
                Text('Episode Count: ${animeAttributes['episodeCount']}',
                    style: Theme.of(context).textTheme.bodySmall),
                Text('Episode Length: ${animeAttributes['episodeLength']}',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _addToWatchlist(animeData);
                  },
                  child: Text('Add to Watchlist'),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> _addToWatchlist(dynamic animeData) async {
  final animeAttributes = animeData['attributes'];
  final database = await WatchlistDatabase.instance.database;
  await database.insert(
    WatchlistDatabase.tableAnime,
    {
      WatchlistDatabase.columnId: animeData['id'],
      WatchlistDatabase.columnTitle: animeAttributes['canonicalTitle'],
      WatchlistDatabase.columnPosterImage: animeAttributes['posterImage']
          ['large'],
      WatchlistDatabase.columnEpisodeCount: animeAttributes['episodeCount'],
    },
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

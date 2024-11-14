import 'package:flutter/material.dart';
import 'anime.dart';
import 'database_helper.dart';
import 'anime_list_tile.dart';

class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Anime> _watchlist = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final watchlist = await _dbHelper.getWatchlist();
    setState(() {
      _watchlist = watchlist;
    });
  }

  Future<void> _confirmDeleteAnime(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Anime'),
          content: Text('Tem certeza de que deseja excluir este anime da sua watchlist?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _dbHelper.deleteAnime(id);
      _loadWatchlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Watchlist'),
      ),
      body: _watchlist.isEmpty
          ? Center(child: Text('Sua watchlist está vazia'))
          : ListView.builder(
              itemCount: _watchlist.length,
              itemBuilder: (context, index) {
                final anime = _watchlist[index];
                return AnimeListTile(
                  anime: anime,
                  onAction: () => _confirmDeleteAnime(anime.id!),
                  actionIcon: Icon(Icons.delete),
                );
              },
            ),
    );
  }
}

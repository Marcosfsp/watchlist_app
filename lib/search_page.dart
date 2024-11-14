import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'anime.dart';
import 'database_helper.dart';
import 'anime_list_tile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Anime> _searchResults = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _searchAnime() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final url = Uri.parse('https://api.jikan.moe/v4/anime?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = (data['data'] as List).map((animeData) {
            return Anime(
              title: animeData['title'],
              description: animeData['synopsis'] ?? 'Sem descrição',
              imageUrl: animeData['images']['jpg']['image_url'],
            );
          }).toList();
        });
      } else {
        throw Exception('Falha ao carregar animes');
      }
    }
  }

  Future<void> _saveAnime(Anime anime) async {
    await _dbHelper.insertAnime(anime);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${anime.title} foi adicionado à sua watchlist!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Anime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nome do Anime',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchAnime,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('Nenhum resultado'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final anime = _searchResults[index];
                        return AnimeListTile(
                          anime: anime,
                          onAction: () => _saveAnime(anime),
                          actionIcon: Icon(Icons.add),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

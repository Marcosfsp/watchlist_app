import 'package:flutter/material.dart';
import 'anime.dart';

class AnimeListTile extends StatelessWidget {
  final Anime anime;
  final VoidCallback onAction;
  final Icon actionIcon;

  AnimeListTile({
    required this.anime,
    required this.onAction,
    required this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        anime.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(anime.title),
      subtitle: Text(anime.description),
      trailing: IconButton(
        icon: actionIcon,
        onPressed: onAction,
      ),
    );
  }
}

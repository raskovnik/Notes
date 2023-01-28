import 'package:flutter/material.dart';

import '../main.dart';
import 'noteListPreview.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Favorites")),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).
            push(MaterialPageRoute(
                builder: (_)=> const MyHomePage()),)
                .then((val)=> setState(() {}) );
      },
        )
      ),
      body: favorites.isEmpty?
        const Center(
            child: Text("Your favorite notes will appear here")
        ):
        NoteListPreview(collection: favorites),
    );
  }
}

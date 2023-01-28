import 'package:flutter/material.dart';
import '../main.dart';
import 'note.dart';

class CustomSearch extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var results = [];
    if (query.isNotEmpty) {
      collection.forEach((key, value) {
        var res = value[0] + value[1];
        if (res.toLowerCase().contains(query.toLowerCase())) {
          results.add([key, value[0], value[1]]);
        }
      });
    }

    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          var query = results[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Note(
                      noteId: query[0],
                      title: query[1],
                      note: query[2],
                      isStarred: query[3],
                      isArchived: false,))
                );
              },
              title: Text(query[1]),
              subtitle: Text(query[2]),
            ),
          );
        }
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var results = [];
    if (query.isNotEmpty) {
      collection.forEach((key, value) {
        var res = value[0] + value[1];
        if (res.toLowerCase().contains(query.toLowerCase())) {
          results.add([key, value[0], value[1]]);
        }
      });
    }

    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          var query = results[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Note(
                      noteId: query[0],
                      title: query[1],
                      note: query[2],
                      isStarred: query[3],
                      isArchived: false,))
                );
              },
              title: Text(query[1]),
              subtitle: Text(query[2]),
            ),
          );
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:keep_notes/utils/NoteGridPreview.dart';
import 'package:keep_notes/utils/navbar.dart';
import 'package:keep_notes/utils/note.dart';
import 'package:keep_notes/utils/noteListPreview.dart';
import 'package:keep_notes/utils/search.dart';
import 'package:hive_flutter/hive_flutter.dart';

Map<int, List<String>> collection = {
  // noteId: [note_title, note_content, isFavorite, isArchived]
};

List<int> favorites = [];
Map<int, List<String>> archived = {
};

Map<int, List<String>> trash = {

};
bool isListView = false;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("Collection");
  await Hive.openBox("Trash");
  await Hive.openBox("Archive");

  var notes = Hive.box("Collection");
  var bin = Hive.box("Trash");
  var archive = Hive.box("Archive");

  notes.keys.toList().forEach((key) {
    collection[key] = notes.get(key);
    if (collection[key]![2] == true.toString()) {
      favorites.add(key);
    }
  });
  bin.keys.toList().forEach((key) {
    trash[key] = bin.get(key);
  });
  archive.keys.toList().forEach((key) {
    archived[key] = archive.get(key);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      drawer: const NavBar(),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearch()
              );
            },
          ),
          IconButton(
            icon: isListView? const Icon(
                Icons.grid_view):
            const Icon(Icons.view_list),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
        ],
        title: const Center(child: Text("Search Notes")),
      ),
      body: collection.isEmpty? const Center(
          child: Text("Your notes will appear here")):
      !isListView? NoteListPreview(collection: collection) :
      NoteGridPreview(collection: collection),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Note(
              noteId: collection.length + 1,
              title: '',
              note: '',
              isStarred: false,
              isArchived: false))
          ).then((res) => setState(() {}));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
var _notes = Hive.box("Collection");
var _bin = Hive.box("Trash");
var _archive = Hive.box("Archive");

class Note extends StatefulWidget {
  final int noteId;
  final String title;
  final String note;
  bool isStarred;
  bool isArchived;
  Note({Key? key,
    required this.noteId,
    required this.title,
    required this.note,
    required this.isStarred,
    required this.isArchived}) : super(key: key);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  String? _title;
  String? _content;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  SnackBar addFavorite = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    action: SnackBarAction(
        label: "UNDO",
        onPressed: () {}),
    content: const Center(child: Text("Added note to favorites!")),
  );
  SnackBar removeFavorite = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    action: SnackBarAction(
        label: "UNDO",
        onPressed: () {

        }),
    content: const Center(child: Text("Removed note from favorites!")),
  );

  SnackBar deleteNote = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    action: SnackBarAction(
        label: "UNDO",
        onPressed: () {

        }),
    content: const Center(child: Text("Note moved to trash!")),
  );
  SnackBar addArchive = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    action: SnackBarAction(
        label: "UNDO",
        onPressed: () {}),
    content: const Center(child: Text("Added note to archive!")),
  );

  void _toggleStar() {
    setState(() {
      widget.isStarred = !widget.isStarred;
      if (widget.isStarred == false) {
        favorites.remove(widget.noteId);
        _notes.put(widget.noteId,
            [collection[widget.noteId]![0],
              collection[widget.noteId]![1],
              false.toString(), collection[widget.noteId]![3]]);
        ScaffoldMessenger.of(context).showSnackBar(removeFavorite);
      } else {
        favorites.add(widget.noteId);
        _notes.put(widget.noteId,
            [collection[widget.noteId]![0],
              collection[widget.noteId]![1],
              false.toString(), collection[widget.noteId]![3]]);
        ScaffoldMessenger.of(context).showSnackBar(addFavorite);
      }
    });
  }

  void _toggleArchive() {
    setState(() {
      widget.isArchived = !widget.isArchived;
      archived[widget.noteId] = collection[widget.noteId]!;
      archived[widget.noteId]![3] = true.toString();
      collection.remove(widget.noteId);
      _archive.put(widget.noteId, archived[widget.noteId]);
      _notes.delete(widget.noteId);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(addArchive);
    });
  }

  void _saveInput() {
    _title ??= widget.title;
    _content ??= widget.note;
    if (_title!.isEmpty && _content!.isEmpty) {
      collection.remove(widget.noteId);
      Navigator.pop(context);
    }
    else {
      collection[widget.noteId] = [_title!,
        _content!,
        widget.isStarred.toString(),
        widget.isArchived.toString()];
      _notes.put(widget.noteId, collection[widget.noteId]);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: widget.title.isEmpty && widget.note.isEmpty? AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _saveInput,
          ),
        ): AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _saveInput,
          ),
          actions: [
            IconButton(
              icon: widget.isStarred==false? const Icon(Icons.star_border):
              const Icon(Icons.star),
              onPressed: _toggleStar,
            ),
            IconButton(
              icon: widget.isArchived==false? const Icon(Icons.archive_outlined):
              const Icon(Icons.archive),
              onPressed: _toggleArchive,
            ),
            IconButton(
              onPressed: () {
                  trash[widget.noteId] = collection[widget.noteId]!;
                  trash[widget.noteId]![2] = false.toString();
                  collection.remove(widget.noteId);
                  //make changes to the boxes
                  favorites.remove(widget.noteId);
                  _bin.put(widget.noteId, trash[widget.noteId]);
                  _notes.delete(widget.noteId);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_)=> const MyHomePage()),)
                      .then((val)=> setState(() {}) );
                  ScaffoldMessenger.of(context).showSnackBar(deleteNote);
              },
              icon: widget.title.isEmpty && widget.note.isEmpty?
              const Icon(Icons.delete, color: Colors.blue):const Icon(Icons.delete),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: widget.title.isNotEmpty?
                TextEditingController(text: widget.title): titleController,
                onChanged: (text) {
                  _title = text;
                },
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) {
                  return value;
                },
              ),
              TextFormField(
                controller: widget.note.isNotEmpty?
                TextEditingController(text: widget.note): noteController,
                onChanged: (text) {
                  _content = text;
                },
                maxLines: null,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Note",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  return value;
                },
              )
            ],
          ),
        ),
    );
  }
}
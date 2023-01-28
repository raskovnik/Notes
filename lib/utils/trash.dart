import 'package:flutter/material.dart';

import '../main.dart';
import 'package:hive_flutter/hive_flutter.dart';

var _notes = Hive.box("Collection");
var _bin = Hive.box("Trash");

class Note extends StatefulWidget {
  final int noteId;
  final String title;
  final String note;
  //TODO: Remove this and make necessary changes
  bool isStarred; //This stays here atm for the sake of my mental health
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

  SnackBar removeTrash = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    // width: MediaQuery.of(context).size.width * 0.75,
    action: SnackBarAction(
        label: "UNDO",
        onPressed: () {

        }),
    content: const Center(child: Text("Removed note from trash!")),
  );
  SnackBar deleteNote = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    // width: MediaQuery.of(context).size.width * 0.75,
    action: SnackBarAction(
        label: "UNDO",
        onPressed: () {

        }),
    content: const Center(child: Text("Deleted note!")),
  );

  void _restore() {
    setState(() {
      collection[widget.noteId] = trash[widget.noteId]!;
      collection[widget.noteId]![3] = false.toString();
      trash.remove(widget.noteId);
      _notes.put(widget.noteId, collection[widget.noteId]);
      _bin.delete(widget.noteId);
      ScaffoldMessenger.of(context).showSnackBar(removeTrash);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.recycling_sharp),
            onPressed: _restore,
          ),
          IconButton(
            onPressed: () {
              trash.remove(widget.noteId);
              _bin.delete(widget.noteId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(deleteNote);
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: widget.title.isNotEmpty?
              TextEditingController(text: widget.title):
              titleController,
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
              TextEditingController(text: widget.note):
              noteController,
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


class Trash extends StatefulWidget {
  const Trash({Key? key}) : super(key: key);

  @override
  State<Trash> createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text("Trash")),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_)=> const MyHomePage()),)
                  .then((val)=> setState(() {}) );
            },
          ),
      ),
      body: trash.isEmpty? const Center(
          child: Text("Your deleted notes will appear here")):
      ListView.builder(
        itemCount: trash.length,
        itemBuilder: (BuildContext context, int index) {
          int noteId = trash.keys.elementAt(index);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              hoverColor: Colors.white38,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Note(
                      noteId: noteId,
                      title: trash[noteId]![0],
                      note: trash[noteId]![1],
                      isStarred: false,
                      isArchived: trash[noteId]![3] == true.toString()? true: false,))
                ).then((res) => setState(() {}));
              },
              title: Text(
                trash[noteId]![0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                trash[noteId]![1],
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}

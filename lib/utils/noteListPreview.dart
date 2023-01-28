import 'package:flutter/material.dart';

import '../main.dart';
import 'note.dart';

class NoteListPreview extends StatefulWidget {
  var collection;
  NoteListPreview({Key? key, required this.collection}) : super(key: key);

  @override
  State<NoteListPreview> createState() => _NoteListPreviewState();
}

class _NoteListPreviewState extends State<NoteListPreview> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.collection.length,
      itemBuilder: (BuildContext context, int index) {
        int noteId;
        try {
          noteId = widget.collection.keys.elementAt(index);

        } on NoSuchMethodError {
          noteId = widget.collection.elementAt(index);
        }
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
                    title: collection[noteId]![0],
                    note: collection[noteId]![1],
                    isStarred: collection[noteId]![2] == true.toString()? true: false,
                    isArchived: false))
              ).then((res) => setState(() {}));
            },
            title: Text(
                collection[noteId]![0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
            ),
            subtitle: Text(
              collection[noteId]![1],
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

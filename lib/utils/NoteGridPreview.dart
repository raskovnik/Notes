import 'package:flutter/material.dart';

import '../main.dart';
import 'note.dart';

class NoteGridPreview extends StatefulWidget {
  var collection;
  NoteGridPreview({Key? key, required this.collection}) : super(key: key);

  @override
  State<NoteGridPreview> createState() => _NoteGridPreviewState();
}

class _NoteGridPreviewState extends State<NoteGridPreview> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.collection.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 8,
        mainAxisExtent: 120,
      ),
      itemBuilder: (BuildContext context, int index) {
        int noteId = widget.collection.keys.elementAt(index);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 2, color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Note(
                      noteId: noteId,
                      title: widget.collection[noteId]![0],
                      note: widget.collection[noteId]![1],
                      isStarred: widget.collection[noteId]![2] == true.toString()? true: false,
                      isArchived: false,)
                    )
                ).then((res) => setState(() {}));
              },
              title: Text(
                collection[noteId]![0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.collection[noteId]![1],
                maxLines: 5,
                overflow: TextOverflow.ellipsis,)
          ),
        );
      },
    );
  }
}

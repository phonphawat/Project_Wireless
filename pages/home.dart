import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:memorykeeper/models/note.dart';
import 'package:memorykeeper/pages/edit.dart';
import 'package:memorykeeper/pages/support.dart';
import 'package:memorykeeper/service/db.dart';
import 'package:memorykeeper/widgets/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Keeper',
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.dark(
        scheme: FlexScheme.redWine,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Color(0xFF4B3C3D),
        actions: [
          IconButton(
            icon: Icon(Icons.support),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: loading
            ? Loading()
            : notes.isEmpty
                ? Center(
                    child: Text(
                      'You have no notes yet.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      Note note = notes[index];
                      return Card(
                        color: Color(0xFF1F1919),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            note.title,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color(0xFFDF7E8E),
                            ),
                          ),
                          subtitle: Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xfff3e3e2).withOpacity(0.7),
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            setState(() => loading = true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Edit(note: note),
                              ),
                            ).then((v) => refresh());
                          },
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF4B3C3D),
        onPressed: () {
          setState(() => loading = true);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Edit(note: new Note()),
            ),
          ).then((v) => refresh());
        },
      ),
    );
  }

  Future<void> refresh() async {
    notes = await DB().getNotes();
    setState(() => loading = false);
  }
}

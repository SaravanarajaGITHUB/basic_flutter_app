import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:english_words/english_words.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(primaryColor: Colors.white),
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestion = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestion() {
    return ListView.builder(itemBuilder: (BuildContext _context, int i) {
      print("position : $i");
      if (i.isOdd) {
        return Divider();
      }
      final int index = i ~/
          2; // 0/2 = 0 PASS , 1/2 =0.5, 2/2 = 1 PASS, 3/2 = FAIL, 4/2 = 2 PASS
      print("index : $index");
      if (index >= _suggestion.length) {
        print("Condition passed for index: $index");
        _suggestion.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestion[index]);
    });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        print("onTap() called");
        setState(() {
          if (alreadySaved) {
            print("alredy saved true");
            _saved.remove(pair);
          } else {
            print("alredy saved false");
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Start up Name Generator'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
          ],
        ),
        body: _buildSuggestion());
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> titles = _saved.map((WordPair pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: _biggerFont),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: titles).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }
}

class MyStatelessWidget extends StatelessWidget {
  final String name;

  MyStatelessWidget(this.name);

  @override
  Widget build(BuildContext context) {
    _call();
    return Container(
      color: Color(0xFF444444),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Hi, $name',
              style: TextStyle(
                  color: Color(0xFFFD620A),
                  fontSize: 50.0,
                  background: Paint()..color = Colors.blue),
            )
          ]),
    );
  }

  void _call() async {
    var response =
        await http.get("https://dev2.gim.com.bd/ejogajog/api/v1/master/all");
    if (response.statusCode == 200) {
      debugPrint(response.body);
    }
  }
}

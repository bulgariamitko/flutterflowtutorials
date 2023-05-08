// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=K-Xbub484lA
// widgets - Cg9Db2x1bW5fNmxmcjk3aHESvwEKEkNvbnRhaW5lcl85bmI5cndhZRgBIgP6AwBikAESPgoKZGltZW5zaW9ucxIwChQKCmRpbWVuc2lvbnMSBnQyZHI5ZTIYIhYKCREAAAAAAABZQBIJEQAAAAAAAFRAEkEKBGxpc3QSOQoOCgRsaXN0EgY1Yms1czgiJwgEEhFTY2FmZm9sZF9zaWtqY3IxdEICEgBKDIIBCQoHCgVvcmRlchoLUmVvcmRlckxpc3SCAQtSZW9yZGVyTGlzdJgBARKwAgoPQnV0dG9uX3hqZmV3bWZsGAkiZkphChYKClNhdmUgb3JkZXI6Bgj/////D0AFKQAAAAAAQGBAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQPoDAGIAigGvARKoAQoIOGpoZHlvcTMSmwEijQESigESZgpkCgVvcmRlchJbCgcKBW9yZGVyKlAIBRpMCgcKBW9yZGVyMkEIClI9EhgSFggMQhIiEAoMCgpjaXRpZXNKc29uEAEaIQoYY3JlYXRlU3RyaW5nTGlzdEZyb21Kc29uEgV6NmNnZRogCAQSEVNjYWZmb2xkX3Npa2pjcjF0QgISAEoFggECEAGqAggzNXl1NmplbBoCCAES/AEKD0J1dHRvbl9mMHZ5eXNyaRgJIm1KaAodChFTYXZlIHRvIEFwcCBTdGF0ZToGCP////8PQAUpAAAAAABAYEAxAAAAAAAAREBJAAAAAAAA8D9SAhABWgIIAHIkCQAAAAAAACBAEQAAAAAAACBAGQAAAAAAACBAIQAAAAAAACBA+gMAYgCKAXUSbwoIcnRqOGQxcnMSY+IBVUJPCggKBmNpdGllcxJDEkEIClI9EhgSFggMQhIiEAoMCgpjaXRpZXNKc29uEAEaIQoYY3JlYXRlU3RyaW5nTGlzdEZyb21Kc29uEgV6NmNnZVACWAGqAghzMHkzMHBtbhoCCAEYBCIFIgD6AwA=
// replace - [{"Argument name": "list"}, {"App state name - list of JSON's": "citiesJson"}]
// support my work - https://github.com/sponsors/bulgariamitko

class ReorderList extends StatefulWidget {
  const ReorderList({
    Key? key,
    this.width,
    this.height,
    this.list,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<String>? list;

  @override
  _ReorderListState createState() => _ReorderListState();
}

class _ReorderListState extends State<ReorderList> {
  late List<String> _displayedList;

  @override
  void initState() {
    super.initState();

    _displayedList = widget.list ?? [];

    if (widget.list != null &&
        FFAppState().citiesJson.isNotEmpty &&
        FFAppState().citiesJson.length == widget.list!.length) {
      Map<String, int> indexMap = {};
      for (Map<String, dynamic> entry in FFAppState().citiesJson) {
        entry.forEach((key, value) {
          indexMap[key] = value;
        });
      }
      _displayedList =
          List<String>.generate(widget.list!.length, (index) => '');
      for (int i = 0; i < widget.list!.length; i++) {
        int newIndex = indexMap[widget.list![i]] ?? -1;
        if (newIndex >= 0 && newIndex < widget.list!.length) {
          _displayedList[newIndex] = widget.list![i];
        } else {
          _displayedList[i] = widget.list![i];
        }
      }
    } else if (widget.list != null) {
      // If the list is not empty and FFAppState().citiesJson is empty, initialize it
      FFAppState().update(() {
        FFAppState().citiesJson = widget.list!
            .asMap()
            .entries
            .map((entry) => {entry.value: entry.key})
            .toList();
      });
      _displayedList = List<String>.from(widget.list!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = _displayedList.removeAt(oldIndex);
            _displayedList.insert(newIndex, item);

            FFAppState().update(() {
              FFAppState().citiesJson = _displayedList
                  .asMap()
                  .entries
                  .map((entry) => {entry.value: entry.key})
                  .toList();
            });
          });
        },
        children: _displayedList.map((String item) {
          return ListTile(
            key: ValueKey(item),
            title: Text(item),
            trailing: Icon(Icons.drag_handle),
          );
        }).toList(),
      ),
    );
  }
}

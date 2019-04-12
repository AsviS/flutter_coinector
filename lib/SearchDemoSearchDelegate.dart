import 'package:flutter/material.dart';
import 'SuggestionList.dart';
import 'Tags.dart';
import 'SuggestionMatch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDemoSearchDelegate extends SearchDelegate<String> {
  final Set<String> _history = Set.from(<String>[]);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  buildHistory() async {
    List<String> historyItems = await getHistory();
    if (historyItems == null || historyItems.isEmpty) return;

    historyItems = _reverseList(historyItems);
    _history.clear();
    historyItems.forEach((item) => _history.add(item));
  }

  _reverseList(List<String> list) {
    List<String> reversedList = [];
    list.forEach((item) => reversedList.insert(0, item));
    return reversedList;
  }

  var _kNotificationsPrefs = "historyItems";

  Future<List<String>> getHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_kNotificationsPrefs);
  }

  Future<bool> setHistory(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(_kNotificationsPrefs, value);
  }

  _getSuggestions(String pattern) {
    List<String> matches = new List();

    if (pattern.length < 3) {
      matches.add(ENTER_ATLEAST_THREE);
      return matches;
    }

    addMatches(pattern, matches, Tags.tagText);
    addMatches(pattern, matches, Tags.locations);

    if (matches.length == 0) {
      matches.add(TRY_ANOTHER_WORD);
    }

    return matches;
  }

  void addMatches(String pattern, List<String> matches, set) {
    for (int x = 0; x < set.length; x++) {
      addMatch(x, pattern, matches, set.elementAt(x));
    }
  }

  void addMatch(
      int x, String pattern, List<String> matches, String currentItem) {
    if (contains(currentItem, pattern)) {
      matches.add(currentItem);
    }
  }

  bool contains(String currentItem, String pattern) =>
      currentItem.toLowerCase().contains(pattern.toLowerCase());

  static final TRY_ANOTHER_WORD = 'Try another word!';
  static final ENTER_ATLEAST_THREE = 'Enter atleast 3 characters!';

  _addHistoryItem(String item) async {
    List<String> historyItems = await getHistory();

    if (historyItems == null) historyItems = [];

    historyItems.add(item);
    _history.add(item);
    setHistory(historyItems);
    buildHistory();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions =
        query.isEmpty ? _history : _getSuggestions(query);

    return SuggestionList(
      query: query,
      suggestions: suggestions.map<String>((String i) => i).toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        _addHistoryItem(suggestion);
        close(context, suggestion);
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    //DONT SHOW ANY RESULTS HERE, SIMPLY REMOVE THE WIDGET
    close(context, null);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.delete_forever),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }
}

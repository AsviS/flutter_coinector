import 'package:flutter/material.dart';

import 'SearchDemoSearchDelegate.dart';
import 'SuggestionList.dart';
import 'Tag.dart';
import 'Toaster.dart';

class AddPlaceTagSearchDelegate extends SearchDelegate<String> {
  Set<int> alreadySelected = Set.from([]);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  _getSuggestions(String pattern) {
    Set<String> matches = Set.from([]);

    addMatches(pattern, matches, Tag.tagText);
    addMatches(pattern, matches, Tag.tagTextES);
    addMatches(pattern, matches, Tag.tagTextDE);
    addMatches(pattern, matches, Tag.tagTextFR);
    addMatches(pattern, matches, Tag.tagTextIT);
    addMatches(pattern, matches, Tag.tagTextINDONESIA);
    addMatches(pattern, matches, Tag.tagTextJP1);
    addMatches(pattern, matches, Tag.tagTextJP2);

    if (matches.length == 0) {
      matches.add(SearchDemoSearchDelegate.TRY_ANOTHER_WORD);
    }

    return matches;
  }

  void addMatches(String pattern, Set<String> matches, set) {
    for (int x = 0; x < set.length; x++) {
      addMatch(x, pattern, matches, set.elementAt(x));
    }
  }

  void addMatch(
      int x, String pattern, Set<String> matches, String currentItem) {
    if (startsWith(currentItem, pattern)) {
      matches.add(currentItem);
    }
  }

  bool startsWith(String currentItem, String pattern) =>
      currentItem.toLowerCase().startsWith(pattern.toLowerCase());

  static const YOU_CAN_SCROLL = "You can scroll this list!";
  static const COINECTOR_SUPPORTS_MANY_LANGUAGES =
      "🇪🇸 🇩🇪 🇫🇷 🇮🇹 🇬🇧 🇯🇵 🇮🇩";

  Set<String> unfilteredSuggestions;

  @override
  Widget buildSuggestions(BuildContext context) {
    Set<String> suggestions = Set.from([
      COINECTOR_SUPPORTS_MANY_LANGUAGES,
      YOU_CAN_SCROLL
    ]);

    if (unfilteredSuggestions != null && query.isEmpty)
      suggestions = unfilteredSuggestions;
    else if (query.isEmpty) {
      addAllTagsInAllLanguages(suggestions);
      unfilteredSuggestions = suggestions;
    } else {
      suggestions = cleanSuggestions(_getSuggestions(query));
    }

    return SuggestionList(
      query: query,
      suggestions: suggestions.map<String>((String i) => i).toList(),
      onSelected: (String match) {
        unfilteredSuggestions = null;
        close(context, match);
      },
    );
  }

  void addAllTagsInAllLanguages(Set<String> suggestions) {
    suggestions.addAll(cleanSuggestions(Tag.tagText));
    //TODO show the device language FIRST
    suggestions.addAll(cleanSuggestions(Tag.tagTextES));
    suggestions.addAll(cleanSuggestions(Tag.tagTextDE));
    suggestions.addAll(cleanSuggestions(Tag.tagTextFR));
    suggestions.addAll(cleanSuggestions(Tag.tagTextIT));
    suggestions.addAll(cleanSuggestions(Tag.tagTextINDONESIA));
    suggestions.addAll(cleanSuggestions(Tag.tagTextJP1));
    suggestions.addAll(cleanSuggestions(Tag.tagTextJP2));
  }

  @override
  void showResults(BuildContext context) {
    //DONT SHOW ANY RESULTS HERE, SIMPLY REMOVE THE WIDGET
    //THIS METHOD IS CALLED WHEN USER HITS THE SEARCH ICON OF THE KEYBOARD LAYOUT
    Toaster.showWarning("Please select a suggestion from the list!");
    //close(context, null);
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

  Iterable<String> cleanSuggestions(Iterable<String> suggestions) {
    List<String> cleanSuggestions = [];
    int index=0;
    suggestions.forEach((String suggestion) {
      if (!suggestion.contains("🍔🍔🍔")) {
        cleanSuggestions = checkIfAlreadySelectedAndAddIfNot(index++, suggestion, cleanSuggestions);
      }
    });
    return cleanSuggestions;
  }

  List<String> checkIfAlreadySelectedAndAddIfNot(int index, String suggestion, List<String> cleanSuggestions) {
    alreadySelected.forEach((suggestionIndex) {
      if (suggestionIndex != index) {
        cleanSuggestions.add(suggestion);
      } else {
        print("filtered already selected item:" + suggestion + " index:" + index.toString());
      }
    });

    if (alreadySelected.length == 0)
      cleanSuggestions.add(suggestion);

    return cleanSuggestions;
  }
}

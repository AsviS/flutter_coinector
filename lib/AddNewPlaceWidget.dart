import 'package:flutter/material.dart';

import 'AddPlaceTagSearchDelegate.dart';

class AddNewPlaceWidget extends StatefulWidget {
  final int selectedType;
  final Color accentColor;
  final Color actionBarColor;
  final String typeTitle;

  const AddNewPlaceWidget(
      {Key key,
      this.selectedType,
      this.accentColor,
      this.typeTitle,
      this.actionBarColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddNewPlaceWidgetState(
        selectedType, accentColor, typeTitle, actionBarColor);
  }
}

class _AddNewPlaceWidgetState extends State<AddNewPlaceWidget> {
  final int selectedType;
  final Color accentColor;
  final String typeTitle;
  final Color actionBarColor;
  final AddPlaceTagSearchDelegate searchTagsDelegate =
      AddPlaceTagSearchDelegate();
  static const TEXT_COLOR = Colors.white;

  String inputName;
  String inputAdr;
  bool showInputAdr = false;
  bool showInputTags = false;

  List<String> allSelectedTags = [];

  _AddNewPlaceWidgetState(
      this.selectedType, this.accentColor, this.typeTitle, this.actionBarColor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: actionBarColor,
        title: Text("ADD: " + typeTitle),
      ),
      body: Builder(
          builder: (ctx) => Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    buildColumnName(),
                    wrapBuildColumnAdr(),
                    wrapBuildColumnTag(ctx)
                  ],
                ),
              )),
    );
  }

  RenderObjectWidget wrapBuildColumnTag(ctx) =>
      (showInputTags ? buildColumnTag(ctx) : buildEmptyPaddingAsPlaceholder());

  RenderObjectWidget wrapBuildColumnAdr() =>
      (showInputAdr ? buildColumnAdr() : buildEmptyPaddingAsPlaceholder());

  Padding buildEmptyPaddingAsPlaceholder() {
    return Padding(
      padding: EdgeInsets.all(0.0),
    );
  }

  Column buildColumnName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "What is the name of that place?",
          style: textStyleLabel(),
        ),
        SizedBox(height: 10.0),
        Text(
          "Use the same name as in Google Maps",
          style: textStyleHint(),
        ),
        buildTextField(Icons.title, 50, "name", updateInputName),
      ],
    );
  }

  Column buildColumnTag(ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Choose tags that describe your products/service.",
          style: textStyleLabel(),
        ),
        SizedBox(height: 10.0),
        Text(
          "Hit the button, scroll the list, select a tag",
          style: textStyleHint(),
        ),
        SizedBox(height: 10.0),
        buildSearchTagButton(ctx),
        SizedBox(height: 10.0),
        wrapBuildSelectedTagsList()
      ],
    );
  }

  Widget wrapBuildSelectedTagsList() {
    return allSelectedTags.length > 0
        ? Row(
            //scrollDirection: Axis.horizontal,
            children: buildTagsRow(),
          )
        : buildEmptyPaddingAsPlaceholder();
  }

  List<Text> buildTagsRow() {
    return allSelectedTags.map<Text>((String tag) {
      return Text(tag + "  ");
    }).toList();
  }

  Column buildColumnAdr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "What is the postal address?",
          style: textStyleLabel(),
        ),
        SizedBox(height: 10.0),
        Text(
          "Street + Number, State, Country",
          style: textStyleHint(),
        ),
        buildTextField(Icons.local_post_office, 50, "address", updateInputAdr),
      ],
    );
  }

  RaisedButton buildSearchTagButton(ctx) {
    return RaisedButton(
      onPressed: () async {
        final String selected = await showSearch<String>(
          context: ctx,
          delegate: searchTagsDelegate,
        );
        if (selected == null || selected.isEmpty) return;

        addSelectedTag(selected);
      },
      textColor: TEXT_COLOR,
      color: actionBarColor,
      splashColor: accentColor,
      child: Row(
        children: <Widget>[Icon(Icons.search), Text("CHOOSE TAGS")],
      ),
    );
  }

  TextField buildTextField(icon, maxLength, String label, updateInputCallback) {
    return TextField(
      decoration: InputDecoration(
          icon: Icon(icon),
          contentPadding: EdgeInsets.all(10.0),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: accentColor)),
          labelText: "Insert " + label + " here."),
      cursorColor: Colors.white70,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: maxLength,
      maxLines: 1,
      onChanged: updateInputCallback,
      style: textStyleInput(),
    );
  }

  TextStyle textStyleInput() =>
      TextStyle(color: TEXT_COLOR, fontWeight: FontWeight.w300);

  TextStyle textStyleLabel() => TextStyle(
      color: TEXT_COLOR,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);
  TextStyle textStyleHint() => TextStyle(
      color: TEXT_COLOR.withOpacity(0.8),
      fontSize: 14.0,
      fontWeight: FontWeight.w300);

  void showInputAddress() {
    setState(() {
      showInputAdr = true;
    });
  }

  void showInputTag() {
    setState(() {
      showInputTags = true;
    });
  }

  void updateInputAdr(String input) {
    if (input.length > 20) {
      showInputTag();
    }

    this.inputAdr = input;
  }

  void updateInputName(String input) {
    if (input.length > 5) {
      showInputAddress();
    }

    this.inputName = input;
  }

  void addSelectedTag(String selected) {
    setState(() {
      allSelectedTags.add(selected);
    });
  }
}

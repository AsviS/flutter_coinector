import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:endlisch/Merchant.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:geolocator/geolocator.dart';

class ItemInfoStackLayer extends StatelessWidget {
  const ItemInfoStackLayer({
    Key key,
    @required this.item,
    @required this.textStyle,
    @required this.textStyleSmall,
    @required this.tagText,
    @required this.position,
  }) : super(key: key);

  final Merchant item;
  final TextStyle textStyle;
  final TextStyle textStyleSmall;
  final Set<String> tagText;
  final Position position;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Text(item.name + "   ", style: textStyle, maxLines: 1,),
            Row(
              children: <Widget>[
                Text(item.location + "   ", style: textStyleSmall),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  position != null ? position.latitude.toString() : "0,1 km   ",
                  style: textStyleSmall,
                ),
                Stack(
                  children: <Widget>[
                    SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: double.parse(item.reviewStars),
                      size: 15.0,
                      color: Colors.yellow[700],
                      borderColor: Colors.white,
                    ),
                    Container(
                      child: Text(item.reviewStars, style: textStyleSmall),
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                )
              ],
            ),
            Text(
                parseElementAt(0) +
                    ", " +
                    parseElementAt(1) +
                    ", " +
                    parseElementAt(2) +
                    ", " +
                    parseElementAt(3),
                style: textStyleSmall)
          ],
        ),
      ),
    );
  }

  String parseElementAt(int pos) =>
      tagText.elementAt(int.parse(item.tags.split(",").elementAt(pos)));
}

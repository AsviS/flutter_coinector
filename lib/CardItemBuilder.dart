import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'CardItem.dart';
import 'ListModel.dart';
import 'Merchant.dart';

class CardItemBuilder {
  List<ListModel<Merchant>> _lists;
  Position pos;

  CardItemBuilder(lists, Position pos) {
    _lists = lists;
    this.pos = pos;
  }

  CardItem _buildItem(
      int index, Animation<double> animation, ListModel<Merchant> listModel) {
    try {
      if (listModel != null &&
          listModel[index] != null &&
          listModel.length > 0) {
        return CardItem(
          index: index,
          position: pos,
          animation: animation,
          merchant: listModel[index],
        );
      }
    } catch (e) {
      //not catching RangeErrors caused issues with filterbar
      return null;
    }
    return null;
  }

  // Used to build list items that haven't been removed.
  Widget buildItemRestaurant(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[0]);
  }

  // Used to build list items that haven't been removed.
  Widget buildItemTogo(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[1]);
  }

  Widget buildItemBar(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[2]);
  }

  Widget buildItemMarket(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[3]);
  }

  Widget buildItemShop(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[4]);
  }

  Widget buildItemHotel(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[5]);
  }

  Widget buildItemWellness(
      BuildContext context, int index, Animation<double> animation) {
    return _buildItem(index, animation, _lists[6]);
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains  visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  static Widget buildRemovedItem(
      Merchant item, BuildContext context, Animation<double> animation) {
    return CardItem(
      index: 0,
      animation: animation,
      merchant: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }
}

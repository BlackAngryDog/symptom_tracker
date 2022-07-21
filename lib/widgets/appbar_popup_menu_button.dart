import 'package:flutter/material.dart';

class AppBarMenuButton extends StatelessWidget {
  final Map<String, Function> menuItems;
  const AppBarMenuButton(this.menuItems, {Key? key}) : super(key: key);

  List<PopupMenuEntry<String>> getPopupItems() {
    List<PopupMenuEntry<String>> list = [];
    for (String key in menuItems.keys) {
      list.add(
        PopupMenuItem(
          value: key,
          child: Text(key),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton<String>(
        itemBuilder: (context) {
          return getPopupItems();
        },
        onSelected: (String value) {
          menuItems[value]?.call();
        },
      ),
    );
  }
}

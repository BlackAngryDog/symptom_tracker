import 'package:flutter/cupertino.dart';

class AddTrackerPopup extends StatefulWidget {
  const AddTrackerPopup({Key? key}) : super(key: key);

  @override
  State<AddTrackerPopup> createState() => _AddTrackerPopupState();
}

class _AddTrackerPopupState extends State<AddTrackerPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

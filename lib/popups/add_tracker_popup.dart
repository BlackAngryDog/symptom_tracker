import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/tracker.dart';

import '../model/track_option.dart';

class AddTracker extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);
  final valueController = TextEditingController();
  final Function(TrackOption option) onAddTracker;

  final TrackOption option;

  AddTracker(this.onAddTracker, this.option, {Key? key}): super(key: key);

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

enum States { tile, type, autofill, value, icon, summery}

class _AddTrackerState extends State<AddTracker> {
  final titleController = TextEditingController();

  final FocusNode unitCodeCtrlFocusNode = FocusNode();
  final Map<String, IconData> myIconCollection = {
    'favorite': Icons.favorite,
    'home': Icons.home,
    'android': Icons.android,
    'album': Icons.album,
    'ac_unit': Icons.ac_unit,
  };

  var state = States.tile;

  String selectedValue = "counter";
  String? selectedIcon = "favorite";



  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "counter",
        child: Text("counter"),
      ),
      const DropdownMenuItem(
        value: "quality",
        child: Text("quality"),
      ),
      const DropdownMenuItem(
        value: "rating",
        child: Text("satisfaction"),
      ),
      const DropdownMenuItem(
        value: "value",
        child: Text("value"),
      ),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<AutoFill>> get autofillItems {
    return AutoFill.values
        .map((e) => DropdownMenuItem<AutoFill>(
            value: e, child: Text(e.toShortString())))
        .toList();
  }

  void OnSubmitTracker() {

    widget.option.save();
    widget.onAddTracker(widget.option);
    // ADD STARTING VALUE;
    // var tracker =
    //     Tracker.fromTrackOption(EventManager.selectedTarget.id ?? '', option);
    // tracker.updateLog(value, DateTime.now());

    Navigator.of(context).pop();
  }

  void prevState(){
    nextState(back:true);
  }

  void nextState({bool back = false}){

    if (state == States.summery){
      OnSubmitTracker();
      return;
    }

    setState(() {
      switch (state){
        case States.tile:
          state = back ? States.tile : States.type;
          break;
        case States.type:
          state = back ? States.tile : States.autofill;
          break;
        case States.autofill:
          state = back ? States.type : States.value;
          break;
        case States.value:
          state = back ? States.autofill : States.icon;
          break;
        case States.icon:
          state = back ? States.value : States.summery;
          break;
      }
    });
  }

  Widget getState(BuildContext context){
    switch (state) {
      case States.tile:
        return TextField(
          decoration: const InputDecoration(labelText: 'Title'),
          controller: titleController,
          textAlign: TextAlign.end,
          focusNode: unitCodeCtrlFocusNode,

          onChanged: (value) {
            widget.option.title = value;
          },
          onSubmitted: (value) {
            widget.option.title = value;
            nextState();
          },
        );
      case States.type:
        return DropdownButton(
            value: widget.option.trackType,
            onChanged: (String? newValue) {
              setState(() {
                widget.option.trackType = newValue!;
              });
            },
            items: dropdownItems);
       case States.autofill:
        return  DropdownButton(
            value: widget.option.autoFill,
            onChanged: (AutoFill? newValue) {
              setState(() {
                widget.option.autoFill = newValue!;
              });
            },
            items: autofillItems);
      case States.value:
        return getControl(context);
      case States.icon:
        return IconPicker(
          initialValue: 'favorite',
          icon: const Icon(Icons.apps),
          labelText: "Icon",
          title: "Select an icon",
          cancelBtn: "CANCEL",
          enableSearch: true,
          searchHint: 'Search icon',
          iconCollection: myIconCollection,
          onChanged: (val) => {widget.option.icon = val},
          onSaved: (val) => {widget.option.icon = val},
        );
      default:
        return Container(
          child: Text("TODO:Summery"),
        );
    }
  }

  Widget getControl(BuildContext context) {
    switch (selectedValue) {
      case "counter":
      // ADD BASELINE VALUE (textfield)
      case "quality":
        return RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            widget.valueController.text = rating.toString();
          },
        ); // ADD BASELINE VALUE (as 1-X picker)
      default:
        return TextField(
          decoration: const InputDecoration(labelText: 'Current Value'),
          controller: widget.valueController,
          textAlign: TextAlign.end,
        );
    }
  }

  @override
  Widget build(BuildContext context) {

    titleController.text = widget.option.title ?? '';

    return Card(
      elevation:5,
      child : Container(
        height: MediaQuery.of(context).size.height / 3,
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getState(context),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: prevState,
                    style: TextButton.styleFrom(foregroundColor: Colors.purple),
                    child: const Text(
                      "Back",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: nextState,
                    style: TextButton.styleFrom(foregroundColor: Colors.purple),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
/*
    return Card(
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
              textAlign: TextAlign.end,
              onChanged: (value) {
                option.title = value;
              },
            ),
            DropdownButton(
                value: option.trackType,
                onChanged: (String? newValue) {
                  setState(() {
                    option.trackType = newValue!;
                  });
                },
                items: dropdownItems),
            DropdownButton(
                value: option.autoFill,
                onChanged: (AutoFill? newValue) {
                  setState(() {
                    option.autoFill = newValue!;
                  });
                },
                items: autofillItems),
            //getControl(context),

            // TODO - need an icon for quality and ratings - do we need one for tracker ?

            IconPicker(
              initialValue: 'favorite',
              icon: const Icon(Icons.apps),
              labelText: "Icon",
              title: "Select an icon",
              cancelBtn: "CANCEL",
              enableSearch: true,
              searchHint: 'Search icon',
              iconCollection: myIconCollection,
              onChanged: (val) => {selectedIcon = val},
              onSaved: (val) => {selectedIcon = val},
            ),

            /*Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(DateFormat.yMMMd().format(_selectedDate)),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      "Choose Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(primary: Colors.purple),
                  )
                ],
              ),
            ),

             */
            TextButton(
              onPressed: OnSubmitTracker,
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
              child: const Text(
                "Add Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
    */
  }
}

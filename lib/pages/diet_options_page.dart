import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/diet_option.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/add_diet_option_popup.dart';
import 'package:symptom_tracker/widgets/diet_option_item.dart';
import 'package:collection/collection.dart';

class DietOptionsPage extends StatefulWidget {
  const DietOptionsPage({Key? key}) : super(key: key);

  @override
  State<DietOptionsPage> createState() => _DietOptionsPageState();
}

class _DietOptionsPageState extends State<DietOptionsPage> {
  List<DietOptionItem> options = [];

  void _addOptionopup(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: AddDietOption(_addOption),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addOption(DietOption value) {
    setState(() {
      value.save();
    });
  }

  Future<List<DietOptionItem>> _getData() async {
    DataLog? log =
        await EventManager.selectedTarget.getDietTracker().getLastEntry(false);

    if (log == null) return options;

    // SELECT OPTIONS FROM DATA
    final test = log.value;

    for (var entry in test!.entries) {
      DietOptionItem? option = options
          .where((element) => element.item.title == entry.key)
          .firstOrNull;
      option?.selected = entry.value;
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
        title: Text('Select current Foods types'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                _addOptionopup(context);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).copyWith().size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: DietOption.getCollection().orderBy('title').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  options = snapshot.data?.docs.map((doc) {
                    return DietOptionItem(
                        false,
                        DietOption.fromJson(
                            doc.id, doc.data() as Map<String, dynamic>));
                  }).toList() as List<DietOptionItem>;

                  return FutureBuilder<List<DietOptionItem>>(
                      future: _getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: options,
                          );
                        } else {
                          return Center(
                              //child: CircularProgressIndicator(),
                              );
                        }
                      });
                }
              }),
        ),
      ),
      floatingActionButton: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              // To do - save data
              final result = Map.fromEntries(options
                  .map((value) => MapEntry(value.item.title, value.selected)));
              EventManager.selectedTarget
                  .getDietTracker()
                  .updateLog(result, DateTime.now());
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              // To do - pop nav
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

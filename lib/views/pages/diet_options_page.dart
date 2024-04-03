import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/model/database_objects/diet_option.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/views/widgets/diet_options/add_diet_option_popup.dart';
import 'package:symptom_tracker/views/widgets/diet_options/diet_option_item.dart';

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
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddDietOption(_addOption),
          );
        });
  }

  void _addOption(DietOption value) {
    setState(() {
      value.save();
    });
  }

  Future<List<DietOptionItem>> _getData() async {
    DataLog? log = await EventManager.selectedTarget.getDietTracker().getLog();

    if (log == null) return options;

    // SELECT OPTIONS FROM DATA
    final test = log.value;
    try {
      for (var entry in test!.entries) {
        DietOptionItem? option = options
            .where((element) => element.item.id == entry.key.toString())
            .firstOrNull;
        option?.selected = true ;
      }
    }catch (error ){
      print('error');
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
        title: const Text('Select current Foods types'),
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
        child: SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: DietOption().getCollection().orderBy('title').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
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
                          return const Center(
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
            child: const Text('Save'),
            onPressed: () {
              // To do - save data
              final result = Map.fromEntries(options.where((element) => element.selected == true)
                  .map((value) => MapEntry(value.item.id, value.item.title)));
              EventManager.selectedTarget
                  .getDietTracker()
                  .updateLog(result, DateTime.now());
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Cancel'),
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

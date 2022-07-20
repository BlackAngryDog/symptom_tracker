import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/pages/tracker_options_page.dart';
import 'package:symptom_tracker/widgets/diet_option_item.dart';

class TrackableSetupPage extends StatefulWidget {
  Trackable? trackable;

  TrackableSetupPage({Key? key, this.trackable}) : super(key: key);

  @override
  State<TrackableSetupPage> createState() => _TrackableSetupPageState();
}

const OutlineInputBorder _enabledBoader = OutlineInputBorder(
  gapPadding: 10,
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.black, width: 1.0),
);

const OutlineInputBorder _focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.blue, width: 2.0),
);

class _TrackableSetupPageState extends State<TrackableSetupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Trackable newTrackable = widget.trackable ??= Trackable();

  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _dateController.text = date;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newTrackable.title ?? "Add Trackable"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: TextEditingController(text: newTrackable.title),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        //labelStyle: Theme.of(context)
                        hintText: 'Please enter a name',
                        prefixIcon: Icon(Icons.date_range),
                        suffixIcon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        enabledBorder: _enabledBoader,
                        focusedBorder: _focusedBorder,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        newTrackable.title = value;
                      },
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          onSaved: (val) {
                            //task.date = selectedDate;
                          },
                          controller: TextEditingController(text: DateTime.now().toString()),
                          decoration: InputDecoration(
                            labelText: "Date",
                            icon: Icon(Icons.calendar_today),
                            enabledBorder: _enabledBoader,
                            focusedBorder: _focusedBorder,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return "Please enter a date for your task";
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  keyboardAppearance: Brightness.dark,
                  controller: TextEditingController(text: newTrackable.title),
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    //labelStyle: Theme.of(context)
                    hintText: 'Please enter a Weight',
                    prefixIcon: Icon(Icons.scale_outlined),
                    suffixIcon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    enabledBorder: _enabledBoader,
                    focusedBorder: _focusedBorder,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Weight';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    //newTrackable.title = value;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        // Process data.
                        _formKey.currentState!.save();
                        // newTrackable.save();

                        // LOAD TRACKER OPTIONS  - DEFAULT AND CUSTOM

                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackerOptionsPage(newTrackable),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

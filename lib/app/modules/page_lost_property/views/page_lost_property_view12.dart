import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PageLostPropertyView12 extends StatefulWidget {
  const PageLostPropertyView12({super.key});

  @override
  State<PageLostPropertyView12> createState() => _PageLostPropertyViewState12();
}

class _PageLostPropertyViewState12 extends State<PageLostPropertyView12> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  late String selectedValue;
  late DateTime? selectedDate;

  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _fbKey, // Assign the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // DropdownSearchFormField(
                    //   key: const Key('dropdownKey'), // Assign the dropdown key
                    //   name: 'dropdown',
                    //   items: items,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedValue = value;
                    //     });
                    //   },
                    // ),
                    FormBuilderDateTimePicker(
                      key: const Key(
                        'datePickerKey',
                      ), // Assign the date picker key
                      name: 'datePicker',
                      onChanged: (DateTime? value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _fbKey.currentState?.reset();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modal Bottom Sheet Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showModalBottomSheet(context),
          child: const Text('Show Modal'),
        ),
      ),
    );
  }
}

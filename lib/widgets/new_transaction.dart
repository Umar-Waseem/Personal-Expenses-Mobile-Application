import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore_for_file: avoid_print, deprecated_member_use

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  const NewTransaction({Key? key, required this.addTransaction}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    _selectedDate ??= DateTime.now(); // if user doesnot enter a date, set the date as now

    if (enteredTitle.isEmpty || enteredAmount < 0) {
      return;
    }

    widget.addTransaction(
      _titleController.text,
      double.parse(_amountController.text),
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate; //* picked date is the date returned by date picker, selected date is the variable to store the choosed date
          });
        } else {
          return;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(
              height: 65,
              child: Row(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                _selectedDate == null ? 'No Date Chosen' : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                              ),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                onPressed: _presentDatePicker,
                                child: const Text(
                                  'Choose A Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: _submitData,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Enter Transaction'),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button!.color,
                  padding: const EdgeInsets.only(left: 2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

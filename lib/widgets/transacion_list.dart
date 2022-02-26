import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: transactions.isEmpty
          ? Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'No Transaction Added Yet',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 10,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(transactions[index].title.toString().toUpperCase()),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                    ),
                    dense: true,
                    trailing: const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
    );
  } // build context function
}

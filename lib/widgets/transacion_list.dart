import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList({Key? key, required this.transactions, required this.deleteTransaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'No Transaction Added Yet',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
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
                  trailing: MediaQuery.of(context).size.width > 460
                      // ignore: deprecated_member_use
                      ? FlatButton.icon(
                          onPressed: () => deleteTransaction(transactions[index].id),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete this transaction'),
                          textColor: Theme.of(context).errorColor,
                        )
                      : IconButton(
                          onPressed: (() => deleteTransaction(transactions[index].id)),
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                        ),
                ),
              );
            },
          );
  } // build context function
}

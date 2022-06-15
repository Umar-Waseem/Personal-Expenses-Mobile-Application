import 'package:expenses_app/widgets/chart.dart';
import 'package:expenses_app/widgets/transacion_list.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './model/transaction.dart';

void main() {
  // ?force device to potrait mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );

  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' expenses application',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              button: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light().textTheme.copyWith().bodyText2,
          titleTextStyle: ThemeData.light().textTheme.copyWith().headline6,
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'shoes',
    //   amount: 345,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'eggs',
    //   amount: 200,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (element) {
        return element.date.isAfter(
          DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _addTransaction(String txtitle, double txamount, DateTime chosenDate) {
    final newTransaction = Transaction(
      title: txtitle,
      amount: txamount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddingNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: (() {}),
          child: NewTransaction(
            addTransaction: _addTransaction,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // ignore: unrelated_type_equality_checks
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final varAppbar = AppBar(
      title: const Text(
        'Expenses App',
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddingNewTransaction(context),
          icon: const Icon(
            Icons.add,
          ),
        )
      ],
    );

    final transactionListWidget = SizedBox(
      height: (MediaQuery.of(context).size.height - varAppbar.preferredSize.height - mediaQuery.padding.top) * 0.75,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTransaction: _deleteTransaction,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: varAppbar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              SizedBox(
                height: (MediaQuery.of(context).size.height - varAppbar.preferredSize.height - mediaQuery.padding.top) * 0.25,
                child: Chart(recentTransactions: _recentTransactions),
              ),
            if (!isLandscape) transactionListWidget,
            if (isLandscape)
              _showChart
                  ? SizedBox(
                      height: (MediaQuery.of(context).size.height - varAppbar.preferredSize.height - mediaQuery.padding.top) * 1,
                      child: Chart(recentTransactions: _recentTransactions),
                    )
                  : transactionListWidget,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddingNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

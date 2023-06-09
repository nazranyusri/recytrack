import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>>? recycleHistory;
  String? errorMessage;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchRecycleHistory();
    getUserId();
  }

  Future<void> fetchRecycleHistory() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference recycleCollection =
            FirebaseFirestore.instance.collection('recycle');

        QuerySnapshot querySnapshot = await recycleCollection
            .doc(user.email)
            .collection('data')
            .get();

        List<Map<String, dynamic>> history = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          recycleHistory = history;
          errorMessage = null;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching recycle history: $error';
      });
    }
  }

  Future<void> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  double calculateTotalWeight(List<Map<String, dynamic>> recycleHistory) {
  double totalWeight = 0;
  for (Map<String, dynamic> historyEntry in recycleHistory) {
    double weight = historyEntry['weight'];
    totalWeight += weight;
  }
  return totalWeight;
}

double calculateTotalMoney(List<Map<String, dynamic>> recycleHistory) {
  double totalMoney = 0;
  for (Map<String, dynamic> historyEntry in recycleHistory) {
    double money = historyEntry['money'];
    totalMoney += money;
  }
  return totalMoney;
}


 @override
Widget build(BuildContext context) {
  // double totalWeights = calculateTotalWeight(recycleHistory!);
  // double totalMoney = calculateTotalMoney(recycleHistory!);

  double totalWeights = 0;
  double totalMoney = 0;
  if (recycleHistory != null ){
    totalWeights = calculateTotalWeight(recycleHistory!);
    totalMoney = calculateTotalMoney(recycleHistory!);
  }

  return Scaffold(
    appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Recycle History',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageUser()),
              (route) => false,
            );
          },
        ),
      ),
    body: errorMessage != null
        ? Center(
            child: Text(
              errorMessage!,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          )
        : recycleHistory != null && recycleHistory!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 8,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      color: Colors.green,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Total Weight: ' + totalWeights.toStringAsFixed(2) + ' kg',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Total Earned: RM ' + totalMoney.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: recycleHistory!.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> historyEntry =
                            recycleHistory![index];
                        double weight = historyEntry['weight'];
                        double plastic = historyEntry['plastic'];
                        double glass = historyEntry['glass'];
                        double paper = historyEntry['paper'];
                        double rubber = historyEntry['rubber'];
                        double metal = historyEntry['metal'];
                        double paymentTotal = historyEntry['money'];
                        double point = historyEntry['point'];

                        // Increment the entry number by 1
                        int entryNumber = index + 1;

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entry $entryNumber',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Total Earned: RM ${paymentTotal.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 16),
                              Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8), // Adjust the padding value as needed
                                        child: TableCell(
                                          child: Text(
                                            'Type',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8), // Adjust the padding value as needed
                                        child: TableCell(
                                          child: Text(
                                            'Weight (kg)',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:Text('Plastic'),
                                      ),
                                      TableCell(
                                        child: Text(plastic.toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Text('Glass'),
                                      ),
                                      TableCell(
                                        child: Text(glass.toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Text('Paper'),
                                      ),
                                      TableCell(
                                        child: Text(paper.toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Text('Rubber'),
                                      ),
                                      TableCell(
                                        child: Text(rubber.toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Text('Metal'),
                                      ),
                                      TableCell(
                                        child: Text(metal.toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  'No recycle history available.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
  );
}

}
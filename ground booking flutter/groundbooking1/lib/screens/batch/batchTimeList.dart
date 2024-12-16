import 'package:demo123/main.dart';
import 'package:demo123/screens/batch/BatchBooking.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class BatchTimeList extends StatelessWidget {
  const BatchTimeList(
      {super.key,
      required this.title,
      required this.item,
      required this.amount});
  final title;
  final item;
  final amount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF108554),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: selectedBatchTimeList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text('From: ' +
                    selectedBatchTimeList[index]['fromtime'] +
                    '   --  ' +
                    'To: ' +
                    selectedBatchTimeList[index]['totime']),
                trailing: TextButton(
                    onPressed: () async {
                      await getaccNoIfsc(memuid);
                      navigation(
                          context,
                          BatchBooking(
                            batchTime: 'From: ' +
                                selectedBatchTimeList[index]['fromtime'] +
                                '   --  ' +
                                'To: ' +
                                selectedBatchTimeList[index]['totime'],
                            item: item,
                            batch: title,
                            amount: amount.toString(),
                            id: selectedBatchTimeList[index]['batid'],
                          ));
                    },
                    child: const Text('Book Now')),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:demo123/main.dart';
import 'package:demo123/screens/batch/batchTimeList.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class BatchList extends StatelessWidget {
  const BatchList({super.key, required this.title});
  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedBatchList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () async {
                        await getBatchTimeListUsingId(
                            selectedBatchList[index]['id']);
                        navigation(
                            context,
                            BatchTimeList(
                              title: selectedBatchList[index]['batchname'],
                              item: title,
                              amount: selectedBatchList[index]['paymentperday'],
                            ));
                      },
                      title: Text(selectedBatchList[index]['batchname']),
                      subtitle: Text(selectedBatchList[index]['description']),
                      trailing: Text(
                          'Fee /day: ${selectedBatchList[index]['paymentperday']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

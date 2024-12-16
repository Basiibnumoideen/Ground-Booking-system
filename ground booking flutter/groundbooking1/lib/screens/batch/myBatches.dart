import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class MyBatches extends StatelessWidget {
  const MyBatches({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: const Text('My batches', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/batchbg.png'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: myBatchList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(myBatchList[index]['Sportsitem']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Batch: ' + myBatchList[index]['batch']),
                      Text('Batchtime: ' + myBatchList[index]['batchtime']),
                      Text('Fromdate: ' + myBatchList[index]['fromdate']),
                      Text('Todate: ' + myBatchList[index]['todate']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

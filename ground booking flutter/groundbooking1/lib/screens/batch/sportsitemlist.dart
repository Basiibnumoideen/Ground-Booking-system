import 'package:demo123/main.dart';
import 'package:demo123/screens/batch/batchList.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class SportsItemList extends StatelessWidget {
  const SportsItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title:
            const Text('Sports Items', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: sportsItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.green[50],
                    child: ListTile(
                      onTap: () async {
                        await getBatchListUsingId(sportsItemList[index]['id']);
                        navigation(
                            context,
                            BatchList(
                                title: sportsItemList[index]['item_name']));
                      },
                      title: Text(sportsItemList[index]['item_name']),
                      subtitle: Text(sportsItemList[index]['description']),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}

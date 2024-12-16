import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class ViewNews extends StatefulWidget {
  const ViewNews({super.key});

  @override
  State<ViewNews> createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {
  @override
  void initState() {
    getNews();
    super.initState();
  }

  void getNews() async {
    await fetchNewsListFromApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(newsList.length);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: const Text('Newses', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: newsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(newsList[index]['news']),
                trailing: Text(newsList[index]['date']),
              ),
            );
          },
        ),
      ),
    );
  }
}

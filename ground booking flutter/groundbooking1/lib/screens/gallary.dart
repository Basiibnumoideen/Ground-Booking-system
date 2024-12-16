import 'package:demo123/main.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  void initState() {
    getImage();
    super.initState();
  }

  void getImage() async {
    await fetchImagesFromDjango();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xFFaedc99),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: const Text('Gallery', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
          ),
          itemCount: imageUrlsList.length,
          itemBuilder: (BuildContext context, int index) {
            print(imageUrlsList.length);
            return InkWell(
              onTap: () {
                navigation(
                    context,
                    ImageView(
                      img: imageUrlsList[index],
                    ));
              },
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                  imageUrlsList[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.img});
  final img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.network(
            img,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

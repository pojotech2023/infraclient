import 'package:flutter/material.dart';



class DrawingDetailPage extends StatefulWidget {
  const DrawingDetailPage({super.key, required this.url, required this.title});
  final String url,title;
  @override
  State<DrawingDetailPage> createState() => _DrawingDetailPageState();
}

class _DrawingDetailPageState extends State<DrawingDetailPage> {



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
  
      body:

          Column(
            children: [
              Expanded(child: Image.network(
                Uri.encodeFull(widget.url),
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.grey),
              )
              ),

            ],
          )


    );
  }

}
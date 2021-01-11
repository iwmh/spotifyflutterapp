import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String id;
  final String name;
  final String artists;
  final String imageUrl;
  final ValueChanged<String> onTapped;

  const AlbumCard({this.id, this.name, this.artists, this.imageUrl, @required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapped(id),
      onLongPress: () => {},
      child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.width * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.network(imageUrl),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(children: [
                  Text(
                    name,
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.25, fontWeightDelta: 1),
                  ),
                  Text(
                    artists,
                    style: DefaultTextStyle.of(context).style.apply(color: Colors.grey[700]),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center),
              )
            ],
          )),
    );
  }
}
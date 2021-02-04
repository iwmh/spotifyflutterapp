import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String owner;
  final ValueChanged<String> onTapped;

  const PlaylistCard({
    this.id,
    this.name,
    this.owner,
    this.imageUrl,
    @required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                child: Column(
                  children: [
                    Text(
                      name,
                      style: DefaultTextStyle.of(context).style.apply(
                            fontSizeFactor: 1.25,
                            fontWeightDelta: 1,
                          ),
                    ),
                    Text(
                      'owner: ' + owner,
                      style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[400],
                          ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              )
            ],
          )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/data/widgets/album_card.dart';
import 'package:spotifyflutterapp/util/constants.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistId;
  const PlaylistScreen(this.playlistId);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final _albumList = <PlaylistTrack>[];
  ApiService _apiService;
  bool _isLoading = true;
  bool _hasMore = true;
  _ItemFetcher _itemFetcher;

  // playlist name used for title.
  String _playlistName = "";

  @override
  void initState() {
    _apiService = Provider.of<ApiService>(context, listen: false);

    _itemFetcher = _ItemFetcher(widget.playlistId, _apiService);

    // get playlist's name
    _apiService.getPlaylistName(widget.playlistId).then((value) {
      setState(() {
        _playlistName = value.name;
      });
    });

    // load playlist's items
    _loadData();

    super.initState();
  }

  void _loadData() {
    _isLoading = true;
    _itemFetcher.fetch().then((fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _albumList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_playlistName),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _hasMore ? _albumList.length + 1 : _albumList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index >= _albumList.length) {
            if (!_isLoading) {
              _loadData();
            }
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 24,
                width: 24,
              ),
            );
          }
          final album = _albumList[index].track.album;
          final artistsName = <String>[];
          album.artists.forEach((element) {
            artistsName.add(element.name);
          });
          return AlbumCard(
            id: album.id,
            name: album.name,
            artists: artistsName.join(', '),
            imageUrl: album.images[0].url,
            onTapped: (String value) {},
          );
        },
      ),
    );
  }
}

class _ItemFetcher {
  final String _playlistId;
  final ApiService _apiService;
  String _url;
  _ItemFetcher(this._playlistId, this._apiService) {
    _url = Constants.tracks_in_playlist(_playlistId) + Constants.albums;
  }

  Future<List<PlaylistTrack>> fetch() async {
    // if url is null (therefore you finished loading all the items),
    // return empty list.
    if (_url == null) {
      return <PlaylistTrack>[];
    }

    final result = await _apiService.getTracksInPlaylist(_url);
    // next url to use.
    _url = result.next;
    // get items from the result.
    List<PlaylistTrack> list = result.items;

    return list;
  }
}

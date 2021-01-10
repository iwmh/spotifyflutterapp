import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/util/constants.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistId;
  const PlaylistScreen(this.playlistId);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final _list = <PlaylistTrack>[];
  ApiService _apiService;
  bool _isLoading = true;
  bool _hasMore = true;
  _ItemFetcher _itemFetcher;

  @override
  void initState() {
    _apiService = Provider.of<ApiService>(context, listen: false);

    _itemFetcher = _ItemFetcher(widget.playlistId, _apiService);

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
          _list.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('playlist ${widget.playlistId} page!'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _hasMore ? _list.length + 1 : _list.length,
        itemBuilder: (BuildContext context, int index) {
          if (index >= _list.length) {
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
          return Text(
            _list[index].track.album.name,
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

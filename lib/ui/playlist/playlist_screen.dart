import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/albumInPlaylistPage.dart';
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
  // unfiltered list of tracks in this playlist.
  final _trackList = <PlaylistTrack>[];

  // The list of "albums".
  // This "album" includes as its member those tracks
  // which are adjacent with each other in the fetched list of tracks.
  final _albumList = <AlbumInPlaylistPage>[];

  ApiService _apiService;
  bool _isLoading = true;
  bool _hasMore = true;
  _ItemFetcher _itemFetcher;

  // playlist's current snapshot id.
  String _snapshotId = '';

  // playlist name used for title.
  String _playlistName = "";

  @override
  void initState() {
    _apiService = Provider.of<ApiService>(context, listen: false);

    // get the snapshot_id of this playlist.
    _apiService.getPlaylistSnapshotId(widget.playlistId).then((value) {
      setState(() {
        _snapshotId = value.snapshotId;
      });
    });

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

          // keep the tracks as you got.
          _trackList.addAll(fetchedList);

          // (1) First, create the list of albums based on the fetched track list.
          final albums = _apiService.aggregateTracksToAlbums(fetchedList);

          // (2) Add obtained album list to the aggregate list.
          // Merge albums list with _albumList.
          if (_albumList.isEmpty) {
            _albumList.addAll(albums);
          } else {
            // Merge the tracks
            if (_albumList.last.id == albums.first.id) {
              final countToAdd = _albumList.last.numberOfTracksOnAggregating;
              _albumList.removeLast();
              albums.first.numberOfTracks += countToAdd;
              _albumList.addAll(albums);
            } else {
              _albumList.last.numberOfTracks = _albumList.last.numberOfTracksOnAggregating;
              _albumList.addAll(albums);
            }
          }
          print('object');
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
        centerTitle: true,
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
          final album = _albumList[index];
          return AlbumCard(
            album: album,
            onFunction: (String value) {},
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

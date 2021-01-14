import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/album.dart';
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

          // keep the tracks as you got.
          _trackList.addAll(fetchedList);

          // (1) First, create the list of albums.
          String albumIdToCompare;
          final albums = <AlbumInPlaylistPage>[];
          var numberOfTracks = 1;
          for (var i = 0; i < fetchedList.length; i++) {
            // First, you group the tracks which have the same album id.
            PlaylistTrack currentPlaylistTrack = fetchedList[i];
            // in the first iteration you just set albumId and regard it as representative
            // because you have no track to compare its albumId.
            if (i == 0) {
              albumIdToCompare = currentPlaylistTrack.track.album.id;
              final convertedAlbum = _convertAlbumToAlbumInPlaylistPage(currentPlaylistTrack.track.album);
              albums.add(convertedAlbum);
              continue;
            } else {
              // Compare the albumId you kept with the current tracks albumId.
              // If you have the same albumId's track, then it means you are still
              // in between the tracks that need to be grouped as an album.
              if (albumIdToCompare == currentPlaylistTrack.track.album.id) {
                numberOfTracks++;
              } else {
                // Otherwise, rename albumIdToCompare and make that track as representative.
                // ... and set the numberOfTracks to the previous album.
                albums.last.numberOfTracks = numberOfTracks;

                albumIdToCompare = currentPlaylistTrack.track.album.id;
                final convertedAlbum = _convertAlbumToAlbumInPlaylistPage(currentPlaylistTrack.track.album);
                albums.add(convertedAlbum);

                // reset the number.
                numberOfTracks = 1;
              }

              // record the number of tracks in the middle of the aggregation.
              if (i == fetchedList.length - 1) {
                albums.last.numberOfTracks = numberOfTracks;
                albums.last.numberOfTracksOnAggregating = numberOfTracks;
              }
              continue;
            }
          }

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

  _convertAlbumToAlbumInPlaylistPage(Album album) {
    return AlbumInPlaylistPage(
      albumType: album.albumType,
      artists: album.artists,
      availableMarkets: album.availableMarkets,
      externalUrls: album.externalUrls,
      href: album.href,
      id: album.id,
      images: album.images,
      name: album.name,
      releaseDate: album.releaseDate,
      releaseDatePrecision: album.releaseDatePrecision,
      totalTracks: album.totalTracks,
      type: album.type,
      uri: album.uri,
    );
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

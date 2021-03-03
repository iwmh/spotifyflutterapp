import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:spotifyflutterapp/data/models/albumInPlaylistPage.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/data/models/reorder_items.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/data/widgets/album_card.dart';
import 'package:spotifyflutterapp/util/constants.dart';
import 'package:after_layout/after_layout.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistId;
  const PlaylistScreen(this.playlistId);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with AfterLayoutMixin<PlaylistScreen> {
  // unfiltered list of tracks in this playlist.
  final _trackList = <PlaylistTrack>[];

  // The list of "albums".
  // This "album" includes as its member those tracks
  // which are adjacent with each other in the fetched list of tracks.
  var _albumList = <AlbumInPlaylistPage>[];

  ApiService _apiService;
  bool _isLoading = true;
  bool _hasMore = true;
  _ItemFetcher _itemFetcher;

  // playlist's current snapshot id.
  String _snapshotId = '';

  // playlist name used for title.
  String _playlistName = "";

  // reordering...
  bool _reordering = false;

  // scroll controller for controlling scrolling detection
  ScrollController _scrollController;

  @override
  void initState() {
    // scroll controller for the list
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScrollExtend = _scrollController.position.maxScrollExtent;
      final currentPosition = _scrollController.position.pixels;
      if (_hasMore && !_isLoading && maxScrollExtend > 0 && (maxScrollExtend / 4 * 3) <= currentPosition) {
        _loadData();
      }
    });

    // obtain the ApiService
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

    super.initState();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    final fetchedList = await _itemFetcher.fetch();
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
        final mergedAlbumList = _apiService.mergeAlbumLists(
          merged: _albumList,
          merge: albums,
        );

        // (3) update the _albumList.
        setState(() {
          _albumList = mergedAlbumList;
        });
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await _loadData();
    // not smart, but this is a quick fix to avoid stopped loading issue after the first load
    // because you didn't get enough data to enable scrolling.
    double height = MediaQuery.of(context).size.height;
    while (_scrollController.position.maxScrollExtent < height && _hasMore && !_isLoading) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) async {
      // start reordering
      setState(() {
        _reordering = true;
      });
      // walkaround..
      final originalNewIndex = newIndex;
      if (oldIndex < newIndex) newIndex++;
      // walkaround..
      final range_start = _apiService.determineStartingIndexToReorder(_albumList, oldIndex);
      final insert_before = _apiService.determineStartingIndexToReorder(_albumList, newIndex);
      final range_length = _albumList[oldIndex].numberOfTracks;
      final reqBody = ReorderItems(
        range_start: range_start,
        insert_before: insert_before,
        range_length: range_length,
        snapshot_id: _snapshotId,
      ).toJson();
      final result = await _apiService.reorderItemsInPlaylist(widget.playlistId, jsonEncode(reqBody));
      // when updating at the server side succeeded,
      setState(() {
        // update snapshot id when successfully reordered the items.
        _snapshotId = result.snapshotId;
        // And also reorder the items in the managed state in this screen.
        final reorderdList = _apiService.reorderList(
          albumList: _albumList,
          oldIndex: oldIndex,
          newIndex: originalNewIndex,
        );
        _albumList = reorderdList;
      });
      setState(() {
        _reordering = false;
      });
      // end reordering
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_playlistName),
        automaticallyImplyLeading: false,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: null,
          child: Visibility(
            child: const LinearProgressIndicator(),
            visible: _reordering,
          ),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _reordering,
        child: SingleChildScrollView(
          child: ReorderableColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            scrollController: _scrollController,
            onReorder: _onReorder,
            children: _albumList
                .map(
                  (e) => AlbumCard(
                    key: ValueKey(e),
                    album: e,
                    onFunction: (String value) {},
                  ),
                )
                .toList(),
          ),
        ),
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

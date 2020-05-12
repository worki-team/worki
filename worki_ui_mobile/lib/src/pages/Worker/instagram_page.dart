import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_html_parser/insta_html_parser.dart';
import 'package:worki_ui/src/values/colors.dart';

class InstagramPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  InstagramPage({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _InstagramPageState createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _profileUrlController = TextEditingController();
  TextEditingController _postUrlController = TextEditingController();
  TextStyle _textStyleBold = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle _textStyleUrl = TextStyle(fontSize: 16.0);
  List<Widget> _parsedWidgets = [];
  String urlProfile = 'https://www.instagram.com/';
  String urlPhoto;

  @override
  void initState() {
    super.initState();
    _profileUrlController.text = 'losdulcesdemajo';
    _postUrlController.text = 'https://www.instagram.com/p/Bmja7GxgCbJ/';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Insta HTML Parser',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.workiColor),
      ),
      body: Center(
        child: ListView(children: [
          Container(
              // Profile url input field
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
              child: Form(
                  child: TextFormField(
                      controller: _profileUrlController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2.0, bottom: 2.0),
                          labelText: 'Profile URL',
                          labelStyle: _textStyleUrl,
                          hintText:
                              'https://www.instagram.com/contreirasgustavo/',
                          hintStyle: TextStyle(
                              color: Colors.grey[500], fontSize: 13))))),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                // Profile avatar submit button
                width: 160,
                padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 16.0),
                child: RaisedButton(
                    child: Text(
                      'Get user data',
                      style: _textStyleUrl,
                    ),
                    onPressed: () async {
                      List<Widget> _widgetsList = [];
                      Map<String, String> _userData =
                          await InstaParser.userDataFromProfile(
                              '${_profileUrlController.text}');

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Is private?
                      _widgetsList
                          .add(Text('Private profile?', style: _textStyleBold));
                      _widgetsList.add(Text(
                          '${_userData['isPrivate'] != null ? _userData['isPrivate'] : ''}',
                          style: _textStyleUrl));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Is private?
                      _widgetsList.add(
                          Text('Verified profile?', style: _textStyleBold));
                      _widgetsList.add(Text(
                          '${_userData['isVerified'] != null ? _userData['isVerified'] : ''}',
                          style: _textStyleUrl));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Posts count
                      _widgetsList
                          .add(Text('Posts count:', style: _textStyleBold));
                      _widgetsList.add(Text(
                          '${_userData['postsCount'] != null ? _userData['postsCount'] : ''}',
                          style: _textStyleUrl));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Followers count
                      _widgetsList
                          .add(Text('Followers count:', style: _textStyleBold));
                      _widgetsList.add(Text(
                          '${_userData['followersCount'] != null ? _userData['followersCount'] : ''}',
                          style: _textStyleUrl));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Followings count
                      _widgetsList.add(
                          Text('Followings count:', style: _textStyleBold));
                      _widgetsList.add(Text(
                          '${_userData['followingsCount'] != null ? _userData['followingsCount'] : ''}',
                          style: _textStyleUrl));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Full name
                      _widgetsList
                          .add(Text('Full name:', style: _textStyleBold));
                      _widgetsList.add(GestureDetector(
                          child: Text(
                              '${_userData['fullName'] != null ? _userData['fullName'] : ''}',
                              style: _textStyleUrl),
                          onTap: () async {
                            setState(() {});
                            Clipboard.setData(ClipboardData(
                                text: '${_userData['fullName']}'));
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Copied full name")));
                          }));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Username
                      _widgetsList
                          .add(Text('Username:', style: _textStyleBold));
                      _widgetsList.add(GestureDetector(
                          child: Text(
                              '${_userData['username'] != null ? _userData['username'] : ''}',
                              style: _textStyleUrl),
                          onTap: () async {
                            setState(() {});
                            Clipboard.setData(ClipboardData(
                                text: '${_userData['username']}'));
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Copied username")));
                          }));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Biography
                      _widgetsList
                          .add(Text('Biography:', style: _textStyleBold));
                      _widgetsList.add(GestureDetector(
                          child: Text(
                            '${_userData['biography'] != null ? _userData['biography'] : ''}',
                            style: _textStyleUrl,
                          ),
                          onTap: () async {
                            setState(() {});
                            Clipboard.setData(ClipboardData(
                                text: '${_userData['biography']}'));
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Copied biography")));
                          }));

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Avatar photo url
                      _widgetsList
                          .add(Text('Avatar photo:', style: _textStyleBold));
                      _widgetsList.add(GestureDetector(
                          child: Text(
                            '${_userData['profilePicUrl'] != null ? _userData['profilePicUrl'] : ''}',
                            style: _textStyleUrl,
                          ),
                          onTap: () async {
                            setState(() {});
                            Clipboard.setData(ClipboardData(
                                text: '${_userData['profilePicUrl']}'));
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Copied profile pic url")));
                          }));
                      if (_userData['profilePicUrl'] != null) {
                        _widgetsList.add(
                            Image.network('${_userData['profilePicUrl']}'));
                      }

                      // Divider
                      _widgetsList.add(Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Divider(height: 0.0, color: Colors.black)));

                      // Avatar photo url hd
                      _widgetsList.add(
                          Text('Avatar photo (HD):', style: _textStyleBold));
                      _widgetsList.add(GestureDetector(
                          child: Text(
                            '${_userData['profilePicUrlHd'] != null ? _userData['profilePicUrlHd'] : ''}',
                            style: _textStyleUrl,
                          ),
                          onTap: () async {
                            setState(() {});
                            Clipboard.setData(ClipboardData(
                                text: '${_userData['profilePicUrlHd']}'));
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Copied profile pic url hd")));
                          }));
                      if (_userData['profilePicUrlHd'] != null) {
                        _widgetsList.add(
                            Image.network('${_userData['profilePicUrlHd']}'));
                      }

                      _widgetsList.add(Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                      ));

                      setState(() => _parsedWidgets = _widgetsList);
                    }),
              ),
              Container(
                // Posts submit button
                width: 128,
                padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 16.0),
                child: RaisedButton(
                    child: Text(
                      'Get posts',
                      style: _textStyleUrl,
                    ),
                    onPressed: () async {
                      List<Widget> _widgetsList = [];
                      List<String> _postsUrls =
                          await InstaParser.postsUrlsFromProfile(
                              '${_profileUrlController.text}');

                      for (int i = 0; i < 12; i++) {
                        // Divider
                        _widgetsList.add(Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Divider(height: 0.0, color: Colors.black)));

                        // Post URL
                        _widgetsList
                            .add(Text('Post ${i + 1}:', style: _textStyleBold));
                        _widgetsList.add(GestureDetector(
                            child: Text(
                              '${_postsUrls.length > 0 ? _postsUrls[i] : ''}',
                              style: _textStyleUrl,
                            ),
                            onTap: () async {
                              setState(() {});
                              Clipboard.setData(
                                  ClipboardData(text: '${_postsUrls[i]}'));
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Copied post url")));
                            }));

                        if (i == _postsUrls.length - 1) {
                          _widgetsList.add(Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                          ));
                        }

                        if (_postsUrls != null) {
                          if (_postsUrls.length > 0) {
                            setState(() {
                              _postUrlController.text = _postsUrls[1];
                              _parsedWidgets = _widgetsList;
                            });
                          }
                        } else {
                          setState(() => _parsedWidgets = _widgetsList);
                        }
                      }
                    }),
              ),
            ],
          ),
          Container(
              // Post url input field
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
              child: Form(
                  child: TextFormField(
                      controller: _postUrlController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2.0, bottom: 2.0),
                          labelText: 'Post URL',
                          labelStyle: _textStyleUrl,
                          hintText: 'https://www.instagram.com/p/BQQrPauBgvn/',
                          hintStyle: TextStyle(
                              color: Colors.grey[500], fontSize: 13))))),
          Row(
            // Photos and video submit button
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                // Parse photos
                width: 160,
                padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 16.0),
                child: RaisedButton(
                  child: Text(
                    'Get photos',
                    style: _textStyleUrl,
                  ),
                  onPressed: () async {
                    List<Widget> _widgetsList = [];
                    Map<String, String> photosUrls =
                        await InstaParser.photoUrlsFromPost(
                            '${_postUrlController.text}');

                    // Divider
                    _widgetsList.add(Container(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Divider(height: 0.0, color: Colors.black)));

                    // Small photo URL
                    _widgetsList
                        .add(Text('Small photo:', style: _textStyleBold));
                    _widgetsList.add(GestureDetector(
                        child: Text(
                          '${photosUrls['small'] != null ? photosUrls['small'] : ''}',
                          style: _textStyleUrl,
                        ),
                        onTap: () async {
                          setState(() {});
                          Clipboard.setData(
                              ClipboardData(text: '${photosUrls['small']}'));
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Copied small size photo url")));
                        }));
                    if (photosUrls['small'] != null) {
                      _widgetsList.add(Image.network(photosUrls['small']));
                    }

                    // Divider
                    _widgetsList.add(Container(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Divider(height: 0.0, color: Colors.black)));

                    // Medium photo URL
                    _widgetsList
                        .add(Text('Medium photo:', style: _textStyleBold));
                    _widgetsList.add(GestureDetector(
                        child: Text(
                          '${photosUrls['medium'] != null ? photosUrls['medium'] : ''}',
                          style: _textStyleUrl,
                        ),
                        onTap: () async {
                          setState(() {});
                          Clipboard.setData(
                              ClipboardData(text: '${photosUrls['medium']}'));
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Copied medium size photo url")));
                        }));
                    if (photosUrls['medium'] != null) {
                      _widgetsList.add(Image.network(photosUrls['medium']));
                    }

                    // Divider
                    _widgetsList.add(Container(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Divider(height: 0.0, color: Colors.black)));

                    // Large photo URL
                    _widgetsList
                        .add(Text('Large photo:', style: _textStyleBold));
                    _widgetsList.add(GestureDetector(
                        child: Text(
                          '${photosUrls['large'] != null ? photosUrls['large'] : ''}',
                          style: _textStyleUrl,
                        ),
                        onTap: () async {
                          setState(() {});
                          Clipboard.setData(
                              ClipboardData(text: '${photosUrls['large']}'));
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Copied large size photo url")));
                        }));
                    if (photosUrls['large'] != null) {
                      _widgetsList.add(Image.network(photosUrls['large']));
                    }

                    setState(() => _parsedWidgets = _widgetsList);
                  },
                ),
              ),
              Container(
                // Parse video
                width: 128,
                padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 16.0),
                child: RaisedButton(
                  child: Text(
                    'Get video',
                    style: _textStyleUrl,
                  ),
                  onPressed: () async {
                    List<Widget> _widgetsList = [];
                    String _videoUrl = await InstaParser.videoUrlFromPost(
                        '${_postUrlController.text}');

                    // Divider
                    _widgetsList.add(Container(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Divider(height: 0.0, color: Colors.black)));

                    // Video URL
                    _widgetsList.add(Text('Video:', style: _textStyleBold));
                    _widgetsList.add(GestureDetector(
                        child: Text(
                          '$_videoUrl\n',
                          style: _textStyleUrl,
                        ),
                        onTap: () async {
                          setState(() {});
                          Clipboard.setData(ClipboardData(text: '$_videoUrl'));
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Copied video url")));
                        }));

                    setState(() => _parsedWidgets = _widgetsList);
                  },
                ),
              ),
            ],
          ),
          Column(children: _parsedWidgets),
        ]),
      ),
    );
  }
}
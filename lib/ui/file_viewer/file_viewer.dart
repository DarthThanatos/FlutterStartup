import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/service/file_service.dart';
import 'package:flutter_app/di/main_app.dart';
import 'package:inject/inject.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'file_viewer_contract.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

@provide
class FileViewer extends StatefulWidget{

  final FileViewerPresenter presenter;

  FileViewer(this.presenter);

  @override
  State<StatefulWidget> createState() => FileViewerState();

}

class FileViewerState extends State<FileViewer> implements FileViewerView {

  int testInt = 0;

  @override
  void initState() {
    super.initState();
    widget.presenter.attachView(this);
//    widget.presenter.loadTest();
  }

  @override
  void dispose() {
    widget.presenter.detachView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer.container.filePickerDemo;
  }

  @override
  void displayTestInt(int testInt) {
    setState((){
      this.testInt = testInt;
    });
  }

}

@provide
class FilePickerDemo extends StatefulWidget {

  final FileService fileService;

  FilePickerDemo(this.fileService);

  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  void _openFileExplorerAndUpload() async {
    setState(() => _loadingPath = true);
    try{
      _path = await FilePicker.getFilePath(
          type: _pickingType,
          fileExtension: _extension
      );

    } on PlatformException catch(e){
      print("Unsupported operation" + e.toString());
    }
    if(!mounted) return;
    widget.fileService.postFile(_path).then((_) => setState(() => _loadingPath = false));
  }

  void _download() async {
    final String fileName = "Screenshot_20190826-120920.png";
    widget.fileService.getFile(fileName).then(createAndGetFile);
  }

  Future<File> createAndGetFile(Response<Uint8List> response) async{
    final dir = await getExternalStorageDirectory();
    await dir.create(recursive: true);
    final fileName = _fileNameFromResponse(response);
    final newFilePath = join(dir.path, fileName);
    print("Downloaded a file with length: ${response.body.length}, now saving it under the path: $newFilePath");
    final file = File(newFilePath);
    print(response.body.length);
    return file.writeAsBytes(response.body);
//    return file.writeAsString(response.body);
  }

  String _fileNameFromResponse(Response response){
    final RegExp contentDispositionRegex = RegExp(r'filename="(.+)"');
    final String dispositionValue =
    response.headers.entries.firstWhere(
            (entry) => entry.key == "content-disposition"
    ).toString();
    String fileName = contentDispositionRegex.firstMatch(dispositionValue).group(1);
    return fileName;

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('File Picker example app'),
        ),
        body: new Center(
            child: new Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: new DropdownButton(
                          hint: new Text('LOAD PATH FROM'),
                          value: _pickingType,
                          items: <DropdownMenuItem>[
                            new DropdownMenuItem(
                              child: new Text('FROM AUDIO'),
                              value: FileType.AUDIO,
                            ),
                            new DropdownMenuItem(
                              child: new Text('FROM IMAGE'),
                              value: FileType.IMAGE,
                            ),
                            new DropdownMenuItem(
                              child: new Text('FROM VIDEO'),
                              value: FileType.VIDEO,
                            ),
                            new DropdownMenuItem(
                              child: new Text('FROM ANY'),
                              value: FileType.ANY,
                            ),
                            new DropdownMenuItem(
                              child: new Text('CUSTOM FORMAT'),
                              value: FileType.CUSTOM,
                            ),
                          ],
                          onChanged: (value) => setState(() {
                            _pickingType = value;
                            if (_pickingType != FileType.CUSTOM) {
                              _controller.text = _extension = '';
                            }
                          })),
                    ),
                    new ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 100.0),
                      child: _pickingType == FileType.CUSTOM
                          ? new TextFormField(
                        maxLength: 15,
                        autovalidate: true,
                        controller: _controller,
                        decoration:
                        InputDecoration(labelText: 'File extension'),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
                          if (reg.hasMatch(value)) {
                            _hasValidMime = false;
                            return 'Invalid format';
                          }
                          _hasValidMime = true;
                          return null;
                        },
                      )
                          : new Container(),
                    ),
                    new ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 200.0),
                      child: new SwitchListTile.adaptive(
                        title: new Text('Pick multiple files',
                            textAlign: TextAlign.right),
                        onChanged: (bool value) =>
                            setState(() => _multiPick = value),
                        value: _multiPick,
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new RaisedButton(
                                onPressed: () => _openFileExplorer(),
                                child: Text("Open file picker"),
                              ),
                              new RaisedButton(
                                onPressed: () => _openFileExplorerAndUpload(),
                                child: Text("Select file and upload"),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new RaisedButton(
                                onPressed: () => _download(),
                                child: Text("Download"),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    new Builder(
                      builder: (BuildContext context) => _loadingPath
                          ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator())
                          : _path != null || _paths != null
                          ? new Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: new Scrollbar(
                            child: new ListView.separated(
                              itemCount: _paths != null && _paths.isNotEmpty
                                  ? _paths.length
                                  : 1,
                              itemBuilder: (BuildContext context, int index) {
                                final bool isMultiPath =
                                    _paths != null && _paths.isNotEmpty;
                                final String name = 'File $index: ' +
                                    (isMultiPath
                                        ? _paths.keys.toList()[index]
                                        : _fileName ?? '...');
                                final path = isMultiPath
                                    ? _paths.values.toList()[index].toString()
                                    : _path;

                                return new ListTile(
                                  title: new Text(
                                    name,
                                  ),
                                  subtitle: new Text(path),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                              new Divider(),
                            )),
                      )
                          : new Container(),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

}
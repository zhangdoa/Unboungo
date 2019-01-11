import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/WidgetBuilders.dart';
import 'package:camera/camera.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Theme.dart';

class CameraScreen extends StatefulWidget {
  @override
  State createState() => new CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> implements PagePresenter {
  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  @override
  Widget buildWidget() {
    return new MaterialApp(
        title: "CameraScreen",
        theme: getThemeData(),
        home: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  color: getThemeData().backgroundColor,
                ),
                child: _isLoadedCamera
                    ? _buildCameraPreview()
                    : _buildInitialPage())));
  }

  Column _buildInitialPage() {
    return Column(
      children: <Widget>[
        UBWidgetBuilder().buildCenterLogo(context, 'CAMERA PREVIEW', 20.0,
            Icons.camera, getThemeData().accentColor),
        UBWidgetBuilder().buildDivider(
          context,
          24.0,
        ),
        UBWidgetBuilder().buildRoundButton(
            context, 'Open Camera', getThemeData().accentColor, _prepareCamera),
        UBWidgetBuilder().buildDivider(
          context,
          24.0,
        ),
        UBWidgetBuilder().buildRoundButton(
            context, 'Scan QR Code', getThemeData().accentColor, _scanQRCode),
        UBWidgetBuilder().buildDivider(
          context,
          24.0,
        ),
        UBWidgetBuilder().buildInputFieldContainer(
            context, "original text", _textController),
        UBWidgetBuilder().buildDivider(
          context,
          24.0,
        ),
        UBWidgetBuilder().buildRoundButton(context, 'Generate QR Code',
            getThemeData().accentColor, _generateQRCode),
      ],
    );
  }

  Future<bool> _prepareCamera() async {
    setState(() {
      _isLoadingCamera = true;
    });
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return false;
      }
      setState(() {
        _isLoadingCamera = false;
        _isLoadedCamera = true;
      });
    });

    return true;
  }

  Widget _buildCameraPreview() {
    if (_isLoadingCamera) {
      return Text('Opening camera...',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ));
    } else {
      if (_isLoadedCamera) {
        return Column(children: <Widget>[
          Expanded(
              child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController)),
            ),
            decoration: BoxDecoration(
              color: getThemeData().backgroundColor,
              border: Border.all(
                color: _cameraController != null &&
                        _cameraController.value.isRecordingVideo
                    ? getThemeData().accentColor
                    : Colors.grey,
                width: 3.0,
              ),
            ),
          )),
          _captureControlRowWidget(),
        ]);
      } else {
        return Text('Camera not loaded yet',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
            ));
      }
    }
  }

  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: onTakePictureButtonPressed,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: onVideoRecordButtonPressed,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: onStopButtonPressed,
        )
      ],
    );
  }

  void onTakePictureButtonPressed() {}

  void onVideoRecordButtonPressed() {}

  void onStopButtonPressed() {}

  Future _scanQRCode() async {}

  void _generateQRCode() {}

  bool _isLoadedCamera = false;
  bool _isLoadingCamera = false;
  CameraController _cameraController;
  List<CameraDescription> _cameras;

  final TextEditingController _textController = new TextEditingController();
  String _barcode = "";
}

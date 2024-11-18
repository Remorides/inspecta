import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/overlay/overlay.dart';

mixin LoadingHandler<T extends StatefulWidget> on State<T> {
  OverlayEntry? _loading;
  OverlayState? _overlayState;

  void showLoading() {
    _overlayState = Overlay.of(context);
    Future<void>.delayed(
      const Duration(milliseconds: 100),
      () {
        _loading = _customLoading;
        _overlayState!.insert(_loading!);
      },
    );
  }

  void hideLoading() {
    Future<void>.delayed(
      const Duration(milliseconds: 100),
      () {
        if (_overlayState != null && _loading != null) {
          _loading!.remove();
          _loading = null;
        }
      },
    );
  }

  OverlayEntry get _customLoading => OverlayEntry(
        builder: (BuildContext context) => SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(color: Colors.black.withOpacity(0.3)),
              const Center(child: LoadingLogo()),
            ],
          ),
        ),
      );
}

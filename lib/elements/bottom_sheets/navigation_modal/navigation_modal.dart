import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:omdk/elements/pages/pages.dart';

class OMDKBottomSheetNavigation extends StatelessWidget {
  /// Create [OMDKBottomSheetNavigation] instance
  const OMDKBottomSheetNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Navigator(
        onGenerateRoute: (_) => CupertinoPageRoute(
          builder: (context) => OMDKAnimatedNavigationPage(
            bodyPage: Container(),
            appBarTitle: 'Node Organization',
            navigationTree: [nodeMap],
            childrenKey: 'nodes',
            withDrawer: false,
            withBottomBar: false,
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context) => showCupertinoModalBottomSheet<void>(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const OMDKBottomSheetNavigation(),
      );

  static Map<String, dynamic> nodeMap = {
    "node": "5d1684ba-84ac-46e4-ba24-ff15285676d9",
    "title": "DT Node",
    "nodes": [
      {
        "node": "bf9e41c6-6353-4d29-a068-4d3e6d014d47",
        "title": "00 1704",
        "nodes": [],
        "type": "Node",
        "path": "DT Node"
      },
      {
        "node": "90cf9cf9-4159-4fb2-82d6-9db4483a76b4",
        "title": "1846",
        "nodes": [
          {
            "asset": "3f21c388-a25e-468f-88dc-905215a99d57",
            "title": "1847",
            "type": "Asset",
            "path": "DT Node > 1846"
          }
        ],
        "type": "Node",
        "path": "DT Node"
      },
      {
        "asset": "379735db-a410-43d3-a46d-e65a46f41e10",
        "title": "00 1256",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "4e67b3b5-d43e-455b-aea2-dc9b8f99efa9",
        "title": "00 1407",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "e45b283c-a2c5-496a-af29-f6800bef98bd",
        "title": "00 1518",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "64eefa95-fb64-4d0e-b5d9-602a346ac8bc",
        "title": "13 1138",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "a4b19f27-1ec7-4c14-a112-088874275c55",
        "title": "A1",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "cd85ea02-cf9d-4fbb-8e96-080f48128e27",
        "title": "A1504",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "d920564e-5326-416a-95e1-7f653ffa82d9",
        "title": "A2",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "e2d9140d-383f-41ee-abe0-72b3ec638ef2",
        "title": "A3",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "e864cdb0-84be-4aa3-b0e2-a7857c03085c",
        "title": "A4",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "5ca6b29f-4374-4e24-87aa-ea23de69b2ea",
        "title": "A5",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "54d06d45-a113-4dba-a150-4842ac6e5e1c",
        "title": "A6",
        "type": "Asset",
        "path": "DT Node"
      },
      {
        "asset": "77b1d68b-2f09-4ab6-b91d-97467cbb3207",
        "title": "A7",
        "type": "Asset",
        "path": "DT Node"
      }
    ],
    "type": "Node"
  };
}

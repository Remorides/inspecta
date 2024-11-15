import 'package:flutter/material.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';

extension SyncColorHelper on SyncStatus? {
  Color get color => switch (this) {
        null => Colors.redAccent,
        SyncStatus.ok => Colors.green,
        SyncStatus.toUpload => Colors.blueAccent,
        SyncStatus.newToUpload => Colors.blueAccent,
        SyncStatus.toDelete => Colors.red,
        SyncStatus.error => Colors.red,
        SyncStatus.unknown => Colors.grey,
      };

  IconData get icon => switch (this) {
        null => Icons.bug_report_outlined,
        SyncStatus.ok => Icons.cloud_done_outlined,
        SyncStatus.toUpload => Icons.cloud_upload_outlined,
        SyncStatus.newToUpload => Icons.cloud_upload_outlined,
        SyncStatus.toDelete => Icons.cloud_off_outlined,
        SyncStatus.error => throw Exception('SyncStatus enum cannot be null'),
        SyncStatus.unknown => Icons.save,
      };
}

extension MediaSyncColorHelper on MediaStatus? {
  Color get color => switch (this) {
        null => throw Exception('MediaStatus enum cannot be null'),
        MediaStatus.synced => Colors.green,
        MediaStatus.toDownload => Colors.lightBlue,
        MediaStatus.toUpload => Colors.lightBlue,
        MediaStatus.toDelete => Colors.red,
      };

  IconData get icon => switch (this) {
        null => throw Exception('MediaStatus enum cannot be null'),
        MediaStatus.synced => Icons.cloud_done_outlined,
        MediaStatus.toDownload => Icons.cloud_download_outlined,
        MediaStatus.toUpload => Icons.cloud_upload_outlined,
        MediaStatus.toDelete => Icons.delete_outline_outlined,
      };
}

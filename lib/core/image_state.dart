import 'dart:core';

import 'dart:typed_data';
import 'package:flutter/material.dart';

class _LocalImageInfo {
  final String fileName;
  final Uint8List? bytes;

  _LocalImageInfo(this.fileName, this.bytes);

  _LocalImageInfo copy() {
    return _LocalImageInfo(fileName, bytes);
  }
}

enum _ImageStateStorageType { none, asset, file, network }

class ImageState {
  final int id;
  final String? imageUri;
  final _LocalImageInfo? localFile;
  final String? assetPath;
  final bool isLocal;
  final bool isAsset;
  late bool isEmpty;

  ImageState._({
    this.id = -1,
    this.imageUri,
    this.localFile,
    this.assetPath,
    this.isLocal = false,
    this.isAsset = false,
  }) {
    if (isLocal == true || isAsset == true || imageUri != null) {
      isEmpty = false;
      return;
    }

    isEmpty = true;
  }

  factory ImageState.none() {
    return ImageState._();
  }

  factory ImageState.network({
    required int id,
    required String imageUri,
  }) {
    return ImageState._(
      id: id,
      imageUri: imageUri,
    );
  }

  factory ImageState.file({
    required int id,
    required String fileName,
    Uint8List? bytes,
  }) {
    return ImageState._(
      id: id,
      localFile: _LocalImageInfo(fileName, bytes),
      isLocal: true,
    );
  }

  factory ImageState.asset({
    required String assetPath,
  }) {
    return ImageState._(
      assetPath: assetPath,
      isAsset: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }

    final otherImageState = other as ImageState;
    if (isEmpty == true && otherImageState.isEmpty == true) {
      return true;
    }

    if (imageStateStorageType == otherImageState.imageStateStorageType) {
      if (isLocal == otherImageState.isLocal) {
        final selfFileName = localFile?.fileName ?? '';
        final otherFileName = otherImageState.localFile ?? '';
        return selfFileName == otherFileName;
      }

      if (isAsset == otherImageState.isAsset) {
        final selfAssetPath = assetPath ?? '';
        final otherAssetPath = otherImageState.assetPath ?? '';
        return selfAssetPath == otherAssetPath;
      }

      if (isNetwork == otherImageState.isNetwork) {
        if (id != otherImageState.id) {
          return false;
        }

        final selfImageUrl = imageUri ?? '';
        final otherImageUrl = otherImageState.imageUri ?? '';
        return selfImageUrl == otherImageUrl;
      }
      return false;
    }

    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  bool get isNetwork {
    if (isLocal == true || isAsset == true) {
      return false;
    }

    return imageUri != null ? true : false;
  }

  _ImageStateStorageType get imageStateStorageType {
    if (isAsset) {
      return _ImageStateStorageType.asset;
    }

    if (isLocal) {
      return _ImageStateStorageType.file;
    }

    if (imageUri != null) {
      return _ImageStateStorageType.network;
    }

    return _ImageStateStorageType.none;
  }

  ImageProvider getImagePovider() {
    if (isLocal == false && imageUri != null) {
      return NetworkImage(imageUri!);
    }

    if (localFile != null) {
      return MemoryImage(localFile!.bytes!);
    }

    if (isAsset == true && assetPath != null) {
      return AssetImage(assetPath!);
    }

    return const AssetImage('assets/notfound.png');
  }

  Image getIamge({
    BoxFit? fit,
  }) {
    if (isLocal == false && imageUri != null) {
      return Image.network(
        imageUri!,
        fit: fit,
      );
    }

    if (localFile != null) {
      return Image.memory(
        localFile!.bytes!,
        fit: fit,
      );
    }

    if (isAsset == true && assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: fit,
      );
    }

    return Image.asset(
      'assets/notfound.png',
      fit: fit,
    );
  }

  ImageState copy() {
    return ImageState._(
      id: id,
      imageUri: imageUri,
      localFile: localFile?.copy(),
      assetPath: assetPath,
      isLocal: isLocal,
      isAsset: isAsset,
    );
  }
}

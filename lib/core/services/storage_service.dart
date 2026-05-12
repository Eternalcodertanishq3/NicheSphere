/// NicheSphere — Storage Service (Phase 2)
/// Firebase Storage upload with image compression.
library;

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<Either<Failure, String>> uploadEventImage(File file) async {
    return _uploadImage(file, 'event_images');
  }

  Future<Either<Failure, String>> uploadAvatar(File file) async {
    return _uploadImage(file, 'avatars');
  }

  Future<Either<Failure, String>> _uploadImage(File file, String folder) async {
    try {
      final compressed = await _compress(file);
      final fileName = '${_uuid.v4()}.jpg';
      final ref = _storage.ref().child('$folder/$fileName');
      await ref.putFile(compressed);
      final url = await ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left(const StorageFailure());
    }
  }

  Future<File> _compress(File file) async {
    final dir = await getTemporaryDirectory();
    final target = '${dir.path}/${_uuid.v4()}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      target,
      quality: 75,
      minWidth: 1080,
      minHeight: 1080,
    );
    return result != null ? File(result.path) : file;
  }
}

import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/create_post_request.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

class CreatePostService {
  final ApiRepository _api = RepositoryModule.apiRepository();

  Future createPost(
      String? authorId, String? description, List<AttachMeta> contents) async {
    if (authorId != null && description != null && contents.isNotEmpty) {
      try {
        _api.createPost(CreatePostRequest(
            authorId: authorId, contents: contents, description: description));
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[500].contains(e.response?.statusCode)) {
          throw ServerException();
        }
      }
    }
  }
}

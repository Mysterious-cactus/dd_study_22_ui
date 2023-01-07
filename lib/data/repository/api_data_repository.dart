import 'dart:io';

import 'package:dd_study_22_ui/data/clients/api_client.dart';
import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/create_post_request.dart';
import 'package:dd_study_22_ui/domain/models/create_user_model.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/profile_post_model.dart';
import 'package:dd_study_22_ui/domain/models/refresh_token_request.dart';
import 'package:dd_study_22_ui/domain/models/subscription_model.dart';
import 'package:dd_study_22_ui/domain/models/token_request.dart';
import 'package:dd_study_22_ui/domain/models/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      pass: password,
    ));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);

  @override
  Future<List<AttachMeta>> uploadTemp({required List<File> files}) =>
      _api.uploadTemp(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);

  @override
  Future createUser(CreateUserModel model) => _auth.createUser(model);

  @override
  Future createPost(CreatePostRequest model) => _api.createPost(model);

  @override
  Future<List<ProfilePostModel>> getCurrentUserPosts() =>
      _api.getCurrentUserPosts();

  @override
  Future<List<User>> getUsers() => _api.getUsers();

  @override
  Future subscribe(String onWhom) => _api.subscribe(onWhom);

  @override
  Future unSubscribe(String fromWhom) => _api.unSubscribe(fromWhom);

  @override
  Future<User> getUserById(String userId) => _api.getUserById(userId);

  @override
  Future<PostModel> getPostById(String postId) => _api.getPostById(postId);

  @override
  Future createComment(CommentModel model) => _api.createComment(model);
}

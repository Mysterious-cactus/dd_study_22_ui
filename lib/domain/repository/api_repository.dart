import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/create_post_request.dart';
import 'package:dd_study_22_ui/domain/models/create_user_model.dart';
import 'package:dd_study_22_ui/domain/models/profile_post_model.dart';
import 'package:dd_study_22_ui/domain/models/subscription_model.dart';

import '../models/post_model.dart';
import '../models/token_response.dart';
import '../models/user.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});
  Future<TokenResponse?> refreshToken(String refreshToken);
  Future<User?> getUser();
  Future<List<PostModel>> getPosts(int skip, int take);
  Future<List<AttachMeta>> uploadTemp({required List<File> files});
  Future addAvatarToUser(AttachMeta model);
  Future createUser(CreateUserModel model);
  Future createPost(CreatePostRequest model);
  Future<List<ProfilePostModel>> getCurrentUserPosts();
  Future<List<User>> getUsers();
  Future subscribe(String onWhom);
  Future unSubscribe(String fromWhom);
}

import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/create_post_request.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/profile_post_model.dart';
import 'package:dd_study_22_ui/domain/models/subscription_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/models/user.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
      @Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetCurrentUserPosts")
  Future<List<ProfilePostModel>> getCurrentUserPosts();

  @GET("/api/User/GetUsers")
  Future<List<User>> getUsers();

  @POST("/api/Attach/UploadFiles")
  Future<List<AttachMeta>> uploadTemp(
      {@Part(name: "files") required List<File> files});

  @POST("/api/User/AddAvatarToUser")
  Future addAvatarToUser(@Body() AttachMeta model);

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostRequest model);

  @POST("/api/Subscription/Subscribe")
  Future subscribe(@Query("onWhom") String onWhom);

  @POST("/api/Subscription/UnSubscribe")
  Future unSubscribe(@Query("fromWhom") String fromWhom);
}

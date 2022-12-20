import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/domain/models/create_user_model.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

class CreateUserService {
  final ApiRepository _api = RepositoryModule.apiRepository();
  final DataService _dataService = DataService();

  Future registerUser(String? name, String? email, DateTime? birthDate,
      String? password, String? retryPassword) async {
    if (name != null &&
        email != null &&
        birthDate != null &&
        password != null &&
        retryPassword != null) {
      try {
        _api.createUser(CreateUserModel(
            name: name,
            email: email,
            birthDate: birthDate,
            password: password,
            retryPassword: retryPassword));
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

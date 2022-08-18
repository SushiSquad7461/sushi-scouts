import 'package:dio/dio.dart';
import 'package:sushi_scouts/src/logic/helpers/error_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/secret/secret.dart';
import 'package:sushi_scouts/src/logic/helpers/secret/secret_loader.dart';
import 'package:sushi_scouts/src/logic/models/match_schedule.dart';
import 'dart:convert';

import 'package:sushi_scouts/src/logic/network/rest_client.dart';

class ApiRepository {
  RestClient? _restClient;

  Future<MatchSchedule?> getMatchSchedule(String event, String tournamentLevel) async {
    final dio = Dio();
    Secret secrets = await SecretLoader(secretPath: "assets/secrets.json").load();
    dio.options.headers['Authorization'] = 'Basic ${base64.encode(utf8.encode("${secrets.getApiKey("tbaUsername")}:${secrets.getApiKey("tbaPassword")}"))}';
    dio.options.headers['If-Modified-Since'] = '';
    _restClient = RestClient(dio, baseUrl: '');
    try{
      return await _restClient!.getMatchSchedule(event, tournamentLevel);
    } catch(error) {
      print(ErrorHelper.handleError(error as Exception));
    }
  }

  Future<String?> getConfigFile(int year, int teamNum) async {
    final dio = Dio();
    _restClient = RestClient(dio, baseUrl: '');
    try{
      return await _restClient!.getConfigFile(year, teamNum);
    } catch(error) {
      print(ErrorHelper.handleError(error as Exception));
    }
  }
}
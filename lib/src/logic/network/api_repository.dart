// Dart imports:
import "dart:convert";
import "dart:developer";

// Package imports:
import "package:dio/dio.dart";
import 'package:flutter/gestures.dart';

// Project imports:
import "../helpers/error_helper.dart";
import "../helpers/secret/secret.dart";
import "../helpers/secret/secret_loader.dart";
import "../models/match_schedule.dart";
import "rest_client.dart";

/*
 * Functions that wrap api calls.
 */
class structures {
  RestClient? _restClient;
  late Secret secrets;

  structures() {
    SecretLoader(secretPath: "assets/secrets.json")
        .load()
        .then((value) => secrets = value);
  }

  /*
   * Gets dio object for using tba, sets Authorization and If-Modified-Since headers.
   */
  Future<Dio> _getTbaDioObject() async {
    Secret secrets =
        await SecretLoader(secretPath: "assets/secrets.json").load();
    final dio = Dio();
    dio.options.headers["Authorization"] =
        'Basic ${base64.encode(utf8.encode("${secrets.getApiKey("tbaUsername")}:${secrets.getApiKey("tbaPassword")}"))}';
    dio.options.headers["If-Modified-Since"] = "";
    return dio;
  }

  Future<MatchSchedule?> getMatchSchedule(
      String event, String tournamentLevel) async {
    final dio = await _getTbaDioObject();
    _restClient = RestClient(dio, baseUrl: "");

    try {
      return await _restClient!
          .getMatchSchedule(event, tournamentLevel, DateTime.now().year);
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
      return null;
    }
  }

  Future<int?> getRank(String event, int teamNum) async {
    final dio = await _getTbaDioObject();
    _restClient = RestClient(dio, baseUrl: "");

    try {
      String data =
          await _restClient!.getRanking(event, teamNum, DateTime.now().year);
      Map<String, dynamic> parsed = json.decode(data);

      if (parsed["Rankings"].length == 0) {
        return 0;
      }
      return parsed["Rankings"][0]["rank"];
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
    }
  }

  /*
   * Gets all of the team numbers that are going to an event
   */
  Future<List<int>?> getTeamNums(String event) async {
    final dio = await _getTbaDioObject();
    _restClient = RestClient(dio, baseUrl: "");

    try {
      String data = await _restClient!.getTeams(DateTime.now().year, event);
      Map<String, dynamic> parsed = json.decode(data);

      List<int> teamNums = [];

      for (final i in parsed["teams"]) {
        teamNums.add(i["teamNumber"]);
      }

      return teamNums;
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
      return null;
    }
  }

  /*
   * Get a map of teamNumbers to teamNames based on event name
   */
  Future<Map<String, String>?> getTeamName(String event) async {
    final dio = await _getTbaDioObject();
    _restClient = RestClient(dio, baseUrl: "");

    try {
      String data = await _restClient!.getTeams(DateTime.now().year, event);
      Map<String, dynamic> parsed = json.decode(data);

      Map<String, String> teamNames = {};

      for (final i in parsed["teams"]) {
        teamNames[i["teamNumber"].toString()] = i["nameShort"];
      }

      return teamNames;
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
      return null;
    }
  }

  /*
   * Gets a url of images for a certain team number.
   */
  Future<List<String>?> getImage(int teamNum) async {
    final dio = Dio();

    dio.options.headers["X-TBA-Auth-Key"] = secrets.getApiKey("tbaReadKey");
    dio.options.headers["accept"] = "application/json";
    dio.options.headers["User-Agent"] = "frcScouter";
    dio.options.headers["If-Modified-Since"] = "";

    _restClient = RestClient(dio, baseUrl: "");

    try {
      String data = await _restClient!.getImage(DateTime.now().year, teamNum);
      List<dynamic> parsed = json.decode(data);

      List<String> ret = [];

      for (final i in parsed) {
        if (i["type"]! == "imgur") {
          ret.add(i["view_url"]);
        }
      }

      return ret;
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
      return null;
    }
  }

  /*
   * Get config file for sushi structures api. 
   */
  Future<String?> getConfigFile(int year, int teamNum) async {
    final dio = Dio();
    _restClient = RestClient(dio, baseUrl: "");
    try {
      return await _restClient!.getConfigFile(year, teamNum);
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
    }
    return null;
  }
}

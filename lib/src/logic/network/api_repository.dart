// Dart imports:
import "dart:convert";
import "dart:developer";

// Package imports:
import "package:dio/dio.dart";

// Project imports:
import "../helpers/error_helper.dart";
import "../helpers/secret/secret.dart";
import "../helpers/secret/secret_loader.dart";
import "../models/match_schedule.dart";
import "rest_client.dart";

class ApiRepository {
  RestClient? _restClient;

  Future<MatchSchedule?> getMatchSchedule(
      String event, String tournamentLevel) async {
    final dio = Dio();
    Secret secrets =
        await SecretLoader(secretPath: "assets/secrets.json").load();
    dio.options.headers["Authorization"] =
        'Basic ${base64.encode(utf8.encode("${secrets.getApiKey("tbaUsername")}:${secrets.getApiKey("tbaPassword")}"))}';
    dio.options.headers["If-Modified-Since"] = "";
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
    final dio = Dio();
    Secret secrets =
        await SecretLoader(secretPath: "assets/secrets.json").load();
    dio.options.headers["Authorization"] =
        'Basic ${base64.encode(utf8.encode("${secrets.getApiKey("tbaUsername")}:${secrets.getApiKey("tbaPassword")}"))}';
    dio.options.headers["If-Modified-Since"] = "";
    _restClient = RestClient(dio, baseUrl: "");
    try {
      String data =
          await _restClient!.getRanking(event, teamNum, DateTime.now().year);
      Map<String, dynamic> parsed = json.decode(data);
      return parsed["Rankings"][0]["rank"];
    } catch (error) {
      log(ErrorHelper.handleError(error as Exception));
      return null;
    }
  }

  Future<List<int>?> getTeamNums(String event) async {
    final dio = Dio();
    Secret secrets =
        await SecretLoader(secretPath: "assets/secrets.json").load();
    dio.options.headers["Authorization"] =
        'Basic ${base64.encode(utf8.encode("${secrets.getApiKey("tbaUsername")}:${secrets.getApiKey("tbaPassword")}"))}';
    dio.options.headers["If-Modified-Since"] = "";
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

  Future<List<String>?> getImage(int teamNum) async {
    final dio = Dio();

    Secret secrets =
        await SecretLoader(secretPath: "assets/secrets.json").load();

    dio.options.headers["X-TBA-Auth-Key"] = ((secrets.getApiKey("tbaReadKey")));
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
      print(error);
      log(ErrorHelper.handleError(error as Exception));
      return null;
    }
  }

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

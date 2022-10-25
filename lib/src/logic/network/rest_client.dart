// Package imports:
import "package:dio/dio.dart";
import "package:retrofit/retrofit.dart";

// Project imports:
import "../models/match_schedule.dart";

part "rest_client.g.dart";

@RestApi(baseUrl: "")
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;

  @GET(
      "https://frc-api.firstinspires.org/v3.0/{year}/schedule/{eventCode}?tournamentLevel={tournamentLevel}")
  Future<MatchSchedule> getMatchSchedule(@Path("eventCode") String eventCode,
      @Path("tournamentLevel") String tournamentLevel, @Path("year") int year);

  @GET(
      "https://frc-api.firstinspires.org/v3.0/{year}/rankings/{eventCode}?teamNumber={teamNum}")
  Future<String> getRanking(@Path("eventCode") String eventCode,
      @Path("teamNum") int teamNum, @Path("year") int year);

  @GET(
      "https://sushi-structeres.herokuapp.com/api/getconfigfile?teamNum={teamNum}&year={year}")
  Future<String> getConfigFile(
      @Path("year") int year, @Path("teamNum") int teamNum);

  @GET("https://www.thebluealliance.com/api/v3/team/frc{teamNum}/media/{year}")
  Future<String> getImage(@Path("year") int year, @Path("teamNum") int teamNum);

  @GET("https://frc-api.firstinspires.org/v3.0/{year}/teams?eventCode={eventCode}")
  Future<String> getTeams(
      @Path("year") int year, @Path("eventCode") String eventCode);
}

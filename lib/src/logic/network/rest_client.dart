import "package:retrofit/retrofit.dart";
import "package:dio/dio.dart";
import "package:sushi_scouts/src/logic/models/match_schedule.dart";

part "rest_client.g.dart";

@RestApi(baseUrl: "")
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;

  @GET(
      "https://frc-api.firstinspires.org/v3.0/2020/schedule/{eventCode}?tournamentLevel={tournamentLevel}")
  Future<MatchSchedule> getMatchSchedule(@Path("eventCode") String eventCode,
      @Path("tournamentLevel") String tournamentLevel);

  @GET(
      "https://sushi-structeres.herokuapp.com/api/getconfigfile?teamNum={teamNum}&year={year}")
  Future<String> getConfigFile(
      @Path("year") int year, @Path("teamNum") int teamNum);
}

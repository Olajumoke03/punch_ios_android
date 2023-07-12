import 'package:punch_ios_android/live_video/live_video_model.dart';

class LiveVideoResponse {
 late  List<LiveVideoModel> liveVideos;

  LiveVideoResponse({required this.liveVideos});

  LiveVideoResponse.fromJson(List<dynamic> json) {
    liveVideos = <LiveVideoModel>[];
    json.forEach((v) {
      liveVideos.add(new LiveVideoModel.fromJson(v));
    });
  }

}


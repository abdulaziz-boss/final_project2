enum FeedType { opportunity }

class FeedModel {
  final FeedType type;
  final dynamic data;

  FeedModel({required this.type, required this.data});
}
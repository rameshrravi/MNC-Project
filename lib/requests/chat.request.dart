import 'package:flutter/material.dart';
import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/models/api_response.dart';
import 'package:midnightcity/services/http.service.dart';

class ChatRequest extends HttpService {
  //
  // Future<ApiResponse> sendNotification({
  //   @required String? title,
  //   @required String? body,
  //   @required String? topic,
  //   @required String? path,
  //   @required PeerUser user,
  //   @required PeerUser otherUser,
  // }) async {
  //   //
  //   dynamic userObject = {
  //     "id": user.documentId,
  //     "name": user.name,
  //     "photo": user.image,
  //   };
  //
  //   //
  //   dynamic otherUserObject = {
  //     "id": otherUser.documentId,
  //     "name": otherUser.name,
  //     "photo": otherUser.image,
  //   };
  //
  //   final apiResult = await post(Api.chat, {
  //     "title": title,
  //     "body": body,
  //     "topic": topic,
  //     "path": path,
  //     "user": userObject,
  //     "peer": otherUserObject,
  //   });
  //   return ApiResponse.fromResponse(apiResult);
  // }
}

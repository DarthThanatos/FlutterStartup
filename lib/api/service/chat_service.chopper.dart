// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$ChatService extends ChatService {
  _$ChatService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = ChatService;

  Future<Response<BuiltChat>> createChat() {
    final $url = '/chat';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send<BuiltChat, BuiltChat>($request);
  }

  Future<Response<BuiltList<BuiltChat>>> getAllChats() {
    final $url = '/chat';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltChat>, BuiltChat>($request);
  }

  Future<Response<int>> getTestInt() {
    final $url = '/chat/int';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<int, int>($request);
  }

  Future<Response<BuiltList<int>>> getTestIntList() {
    final $url = '/chat/int-list';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<int>, int>($request);
  }
}

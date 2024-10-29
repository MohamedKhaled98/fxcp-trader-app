abstract class ISocket {
  Future connect(Function onMessageReceived);
  void close();
  void subscribe(dynamic data);
  void unsubscribe(dynamic data);
  void resetSubscriptions();
}
typedef EventCallback = Future<void> Function([List<dynamic>? data]);

class GlobalEvents {
  Map<String, List<EventCallback>> events = {};
  void on(String eventName, EventCallback callback) {
    if (events.containsKey(eventName)) {
      events[eventName]!.add(callback);
    } else {
      events[eventName] = [callback];
    }
  }

  void emit(String eventName, [List<dynamic>? data]) {
    events[eventName]?.forEach((element) {
      element(data);
    });
  }

  void off(String eventName, EventCallback callback) {
    events[eventName]?.remove(callback);
  }
}

final globalEvents = GlobalEvents();

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';

class AmplitudeService {
  static late Amplitude amplitude;

  // Constructor to initialize Amplitude
  static void initializeAmplitude() async {
    amplitude = Amplitude(Configuration(
      apiKey: "feb049885887051bb097ac7f73572f6c",
      // serverZone: ServerZone.eu,
      // defaultTracking: DefaultTrackingOptions(
      //   sessions: true,
      // ),
    ));
    await amplitude.isBuilt;
    amplitude.flush();
  }
  // Async function to initialize Amplitude

  // Method to track events
  void trackEvent(String eventType, {Map<String, dynamic>? properties}) {
    amplitude.track(BaseEvent(eventType, eventProperties: properties));
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver getObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);
}

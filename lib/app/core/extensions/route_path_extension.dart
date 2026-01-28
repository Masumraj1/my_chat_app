
import '../routes/router_path.dart';

extension RouteBasePathExt on String {
  String get addBasePath => RoutePath.basePath + this;
}
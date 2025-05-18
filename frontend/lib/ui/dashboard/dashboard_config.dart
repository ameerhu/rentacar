import '/ui/config/base_widget_config.dart';

abstract class DashboardConfig extends BaseWidgetConfig {
  /*factory DashboardConfig.of(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    if (width >= 1100) {
      return DesktopDashboardConfig();
    }
    return DesktopDashboardConfig();
  }*/

  double getAnimatedSizedBoxHeight();
}

class DesktopDashboardConfig extends DashboardConfig {
  @override
  getAnimatedSizedBoxHeight() => 200;
}

class MobileDesktopDashboardConfig extends DashboardConfig {
  MobileDesktopDashboardConfig();

  @override
  getAnimatedSizedBoxHeight() => 50;
}

class TabletDashboardConfig extends DashboardConfig {
  TabletDashboardConfig();

  @override
  getAnimatedSizedBoxHeight() => 200;
}

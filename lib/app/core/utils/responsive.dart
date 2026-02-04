import 'package:flutter/material.dart';

/// Enum untuk tipe device
enum DeviceType { mobile, tablet, desktop }

/// Utility class untuk responsive design
class Responsive {
  // Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  /// Mendapatkan tipe device berdasarkan lebar layar
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check apakah device adalah mobile
  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  /// Check apakah device adalah tablet
  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  /// Check apakah device adalah desktop
  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  /// Mendapatkan lebar layar
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Mendapatkan tinggi layar
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Responsive value berdasarkan device type
  /// Contoh: Responsive.value(context, mobile: 16.0, tablet: 20.0, desktop: 24.0)
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Responsive padding
  static EdgeInsets padding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return value(
      context,
      mobile: mobile ?? const EdgeInsets.all(16),
      tablet: tablet ?? const EdgeInsets.all(24),
      desktop: desktop ?? const EdgeInsets.all(32),
    );
  }

  /// Responsive font size
  static double fontSize(
    BuildContext context, {
    double mobile = 14,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile + 2,
      desktop: desktop ?? mobile + 4,
    );
  }

  /// Responsive spacing
  static double spacing(
    BuildContext context, {
    double mobile = 16,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2,
    );
  }

  /// Responsive icon size
  static double iconSize(
    BuildContext context, {
    double mobile = 24,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile + 4,
      desktop: desktop ?? mobile + 8,
    );
  }

  /// Responsive grid column count
  static int gridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    return value(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Responsive border radius
  static double borderRadius(
    BuildContext context, {
    double mobile = 12,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile + 2,
      desktop: desktop ?? mobile + 4,
    );
  }

  /// Responsive horizontal padding (left/right)
  static double horizontalPadding(BuildContext context) {
    return value(context, mobile: 16.0, tablet: 32.0, desktop: 48.0);
  }

  /// Responsive vertical padding (top/bottom)
  static double verticalPadding(BuildContext context) {
    return value(context, mobile: 16.0, tablet: 24.0, desktop: 32.0);
  }
}

/// Widget wrapper untuk responsive layout
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, Responsive.getDeviceType(context));
  }
}

/// Widget untuk menampilkan widget berbeda berdasarkan device
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = Responsive.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Extension untuk BuildContext agar lebih mudah digunakan
extension AppResponsiveContext on BuildContext {
  bool get isAppMobile => Responsive.isMobile(this);
  bool get isAppTablet => Responsive.isTablet(this);
  bool get isAppDesktop => Responsive.isDesktop(this);
  DeviceType get appDeviceType => Responsive.getDeviceType(this);
  double get appScreenWidth => Responsive.screenWidth(this);
  double get appScreenHeight => Responsive.screenHeight(this);
}

/// Extension untuk responsive sizing berdasarkan persentase layar
extension ResponsiveSizing on num {
  /// Persentase dari lebar layar
  double wp(BuildContext context) =>
      (this / 100) * MediaQuery.of(context).size.width;

  /// Persentase dari tinggi layar
  double hp(BuildContext context) =>
      (this / 100) * MediaQuery.of(context).size.height;

  /// Responsive scaling factor
  double sp(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Base width 375 (iPhone standard)
    return (this * width) / 375;
  }
}

// =============================================================================
// RESPONSIVE PAGE WRAPPER
// =============================================================================

/// Widget wrapper untuk halaman yang otomatis responsive.
/// Menggunakan LayoutBuilder untuk detect width dan center content pada tablet.
///
/// Contoh penggunaan:
/// ```dart
/// ResponsivePageWrapper(
///   child: Column(children: [...]),
/// )
/// ```
class ResponsivePageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final double maxWidth;
  final Color? backgroundColor;

  const ResponsivePageWrapper({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.maxWidth = 750.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrLarger =
            constraints.maxWidth >= Responsive.mobileMaxWidth;

        final padding = isTabletOrLarger
            ? (tabletPadding ??
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 24))
            : (mobilePadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16));

        Widget content = Padding(padding: padding, child: child);

        // Pada tablet, center dan constrain width
        if (isTabletOrLarger) {
          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: content,
            ),
          );
        }

        if (backgroundColor != null) {
          content = Container(color: backgroundColor, child: content);
        }

        return content;
      },
    );
  }
}

/// Widget wrapper untuk ScrollView yang responsive
class ResponsiveScrollWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final double maxWidth;

  const ResponsiveScrollWrapper({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.maxWidth = 750.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrLarger =
            constraints.maxWidth >= Responsive.mobileMaxWidth;

        final padding = isTabletOrLarger
            ? (tabletPadding ??
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 24))
            : (mobilePadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16));

        Widget content = Padding(padding: padding, child: child);

        if (isTabletOrLarger) {
          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: content,
            ),
          );
        }

        return SingleChildScrollView(child: content);
      },
    );
  }
}

// =============================================================================
// RESPONSIVE FLEX (Column ↔ Row)
// =============================================================================

/// Widget yang otomatis berubah dari Column (mobile) ke Row (tablet).
///
/// Contoh:
/// ```dart
/// ResponsiveFlex(
///   children: [
///     Expanded(child: TextField(...)),
///     Expanded(child: TextField(...)),
///   ],
/// )
/// ```
class ResponsiveFlex extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const ResponsiveFlex({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrLarger =
            constraints.maxWidth >= Responsive.mobileMaxWidth;

        final spacedChildren = <Widget>[];
        for (int i = 0; i < children.length; i++) {
          spacedChildren.add(children[i]);
          if (i < children.length - 1) {
            spacedChildren.add(
              SizedBox(
                width: isTabletOrLarger ? spacing : 0,
                height: isTabletOrLarger ? 0 : spacing,
              ),
            );
          }
        }

        if (isTabletOrLarger) {
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: spacedChildren,
          );
        } else {
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: spacedChildren,
          );
        }
      },
    );
  }
}

// =============================================================================
// RESPONSIVE DIALOG WRAPPER
// =============================================================================

/// Wrapper untuk dialog yang responsive
class ResponsiveDialogWrapper extends StatelessWidget {
  final Widget child;
  final double mobileInsetPadding;
  final double tabletMaxWidth;

  const ResponsiveDialogWrapper({
    super.key,
    required this.child,
    this.mobileInsetPadding = 20,
    this.tabletMaxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrLarger =
            constraints.maxWidth >= Responsive.mobileMaxWidth;

        if (isTabletOrLarger) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tabletMaxWidth),
              child: child,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(mobileInsetPadding),
          child: child,
        );
      },
    );
  }
}

// =============================================================================
// RESPONSIVE SIZING HELPERS
// =============================================================================

/// Helper class untuk mendapatkan ukuran responsif
class R {
  /// Padding horizontal
  static double hPadding(BuildContext context) =>
      Responsive.isMobile(context) ? 16.0 : 32.0;

  /// Padding vertical
  static double vPadding(BuildContext context) =>
      Responsive.isMobile(context) ? 16.0 : 24.0;

  /// Spacing antar item
  static double itemSpacing(BuildContext context) =>
      Responsive.isMobile(context) ? 12.0 : 16.0;

  /// Card width untuk equipment
  static double cardWidth(BuildContext context) =>
      Responsive.isMobile(context) ? 130.0 : 150.0;

  /// Card height untuk equipment
  static double cardHeight(BuildContext context) =>
      Responsive.isMobile(context) ? 220.0 : 240.0;

  /// Image height dalam card
  static double imageHeight(BuildContext context) =>
      Responsive.isMobile(context) ? 130.0 : 150.0;

  /// Category item width
  static double categoryWidth(BuildContext context) =>
      Responsive.isMobile(context) ? 90.0 : 100.0;

  /// Category item height
  static double categoryHeight(BuildContext context) =>
      Responsive.isMobile(context) ? 90.0 : 100.0;

  /// Icon size dalam category
  static double categoryIconSize(BuildContext context) =>
      Responsive.isMobile(context) ? 28.0 : 32.0;
}

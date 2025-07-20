import 'package:flutter/material.dart';
import 'app_spacings.dart';

/// Defines a typedef for clarity: a builder that receives context and children.
typedef AdaptiveWidgetBuilder =
    Widget Function(BuildContext context, List<Widget> children);

/// Enum representing screen types based on width breakpoints.
enum DeviceType { smallScreen, mediumScreen, largeScreen }

/// The final version of our responsive layout builder.
///
/// It combines breakpoint-based layout construction logic with the ability
/// to apply responsive padding around the entire layout, creating a powerful
/// and convenient UI component.
class PaddedAdaptiveLayoutBuilder extends StatelessWidget {
  final List<Widget> children;
  final AdaptiveWidgetBuilder smallScreen;
  final AdaptiveWidgetBuilder? mediumScreen;
  final AdaptiveWidgetBuilder? largeScreen;
  final EdgeInsetsGeometry smallPadding;
  final EdgeInsetsGeometry? mediumPadding;
  final EdgeInsetsGeometry? largePadding;
  final double smallBreakpoint;
  final double mediumBreakpoint;

  /// Constructor with default values based on design spacing constants.
  const PaddedAdaptiveLayoutBuilder({
    super.key,
    required this.children,
    required this.smallScreen,
    this.mediumScreen,
    this.largeScreen,
    this.smallPadding = const EdgeInsets.all(AppSpacings.small),
    this.mediumPadding = const EdgeInsets.all(AppSpacings.small),
    this.largePadding = const EdgeInsets.symmetric(
      horizontal: AppSpacings.xxxLarge,
      vertical: AppSpacings.xxSmall,
    ),
    this.smallBreakpoint = 1000,
    this.mediumBreakpoint = 1700,
  });

  DeviceType _getDeviceType(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    if (width >= mediumBreakpoint) return DeviceType.largeScreen;
    if (width >= smallBreakpoint) return DeviceType.mediumScreen;
    return DeviceType.smallScreen;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints);
        // 1. Choose the layout builder based on device type.
        final Widget builtLayout;
        switch (deviceType) {
          case DeviceType.largeScreen:
            builtLayout = (largeScreen ?? mediumScreen ?? smallScreen)(
              context,
              children,
            );
            break;
          case DeviceType.mediumScreen:
            builtLayout = (mediumScreen ?? smallScreen)(context, children);
            break;
          case DeviceType.smallScreen:
            builtLayout = smallScreen(context, children);
            break;
        }
        // 2. Choose the appropriate padding based on device type.
        final EdgeInsetsGeometry finalPadding;
        switch (deviceType) {
          case DeviceType.largeScreen:
            finalPadding = largePadding ?? mediumPadding ?? smallPadding;
            break;
          case DeviceType.mediumScreen:
            finalPadding = mediumPadding ?? smallPadding;
            break;
          case DeviceType.smallScreen:
            finalPadding = smallPadding;
            break;
        }
        // 3. Return the layout wrapped with responsive padding.
        if (finalPadding == EdgeInsets.zero) {
          return builtLayout;
        }
        return Padding(padding: finalPadding, child: builtLayout);
      },
    );
  }
}

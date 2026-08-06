import 'package:flutter/material.dart';

class ThemeScope extends StatefulWidget {
  const ThemeScope({
    super.key,
    required this.child,
    this.initialMode = ThemeMode.light,
  });

  final Widget child;
  final ThemeMode initialMode;

  static ThemeScopeController of(BuildContext context) {
    final _ThemeScopeInherited? inherited =
        context.dependOnInheritedWidgetOfExactType<_ThemeScopeInherited>();
    assert(inherited != null, 'No ThemeScope found in context');
    return inherited!.controller;
  }

  static ThemeScopeController read(BuildContext context) {
    final _ThemeScopeInherited? inherited =
        context.getInheritedWidgetOfExactType<_ThemeScopeInherited>();
    assert(inherited != null, 'No ThemeScope found in context');
    return inherited!.controller;
  }

  @override
  State<ThemeScope> createState() => ThemeScopeController();
}

class ThemeScopeController extends State<ThemeScope> {
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialMode;
  }

  void toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() {
        _themeMode = mode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeScopeInherited(
      controller: this,
      themeMode: _themeMode,
      child: widget.child,
    );
  }
}

class _ThemeScopeInherited extends InheritedWidget {
  const _ThemeScopeInherited({
    required this.controller,
    required this.themeMode,
    required super.child,
  });

  final ThemeScopeController controller;
  final ThemeMode themeMode;

  @override
  bool updateShouldNotify(_ThemeScopeInherited oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}

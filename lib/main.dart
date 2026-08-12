import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeEngine()),
        ChangeNotifierProvider(create: (_) => WindowManager()),
      ],
      child: const SKOSApp(),
    ),
  );
}

class SKOSApp extends StatefulWidget {
  const SKOSApp({super.key});

  @override
  State<SKOSApp> createState() => _SKOSAppState();
}

class _SKOSAppState extends State<SKOSApp> {
  bool _isBooted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKOS 2.0 — Shrawan Kumar Thakur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: _isBooted
          ? const SKOSAdaptiveShell()
          : BootSequenceScreen(
              onBootComplete: () {
                setState(() {
                  _isBooted = true;
                });
              },
            ),
    );
  }
}

// ==========================================
// 1. HELPER METHOD FOR URL LAUNCHING
// ==========================================

Future<void> _launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not launch $urlString');
  }
}

// ==========================================
// 2. CORE STATE MODELS & THEME ENGINE
// ==========================================

enum SKOSTheme {
  developerGreen,
  nord,
  catppuccin,
  tokyoNight,
  dracula,
  gruvbox,
  gitHubDark,
  oledBlack,
  blueprint,
  cyberpunk,
}

class SystemThemeData {
  final String name;
  final Color bg;
  final Color surface;
  final Color card;
  final Color accent;
  final Color textPrimary;
  final Color textMuted;
  final Color border;
  final String font;

  const SystemThemeData({
    required this.name,
    required this.bg,
    required this.surface,
    required this.card,
    required this.accent,
    required this.textPrimary,
    required this.textMuted,
    required this.border,
    this.font = 'JetBrains Mono',
  });
}

class ThemeEngine extends ChangeNotifier {
  SKOSTheme _currentTheme = SKOSTheme.developerGreen;

  SKOSTheme get currentTheme => _currentTheme;

  static final Map<SKOSTheme, SystemThemeData> themes = {
    SKOSTheme.developerGreen: const SystemThemeData(
      name: 'Developer Green',
      bg: Color(0xFF080C0E),
      surface: Color(0xFF0E1518),
      card: Color(0xFF141E22),
      accent: Color(0xFF20E382),
      textPrimary: Color(0xFFE2E8F0),
      textMuted: Color(0xFF8B9BB0),
      border: Color(0xFF1B272C),
    ),
    SKOSTheme.nord: const SystemThemeData(
      name: 'Nord',
      bg: Color(0xFF2E3440),
      surface: Color(0xFF3B4252),
      card: Color(0xFF434C5E),
      accent: Color(0xFF88C0D0),
      textPrimary: Color(0xFFECEFF4),
      textMuted: Color(0xFFD8DEE9),
      border: Color(0xFF4C566A),
    ),
    SKOSTheme.catppuccin: const SystemThemeData(
      name: 'Catppuccin Mocha',
      bg: Color(0xFF1E1E2E),
      surface: Color(0xFF181825),
      card: Color(0xFF313244),
      accent: Color(0xFFCBA6F7),
      textPrimary: Color(0xFFCDD6F4),
      textMuted: Color(0xFFA6ADC8),
      border: Color(0xFF45475A),
    ),
    SKOSTheme.tokyoNight: const SystemThemeData(
      name: 'Tokyo Night',
      bg: Color(0xFF1A1B26),
      surface: Color(0xFF16161E),
      card: Color(0xFF24283B),
      accent: Color(0xFF7AA2F7),
      textPrimary: Color(0xFFC0CAF5),
      textMuted: Color(0xFF565F89),
      border: Color(0xFF292E42),
    ),
    SKOSTheme.dracula: const SystemThemeData(
      name: 'Dracula',
      bg: Color(0xFF282A36),
      surface: Color(0xFF21222C),
      card: Color(0xFF44475A),
      accent: Color(0xFFFF79C6),
      textPrimary: Color(0xFFF8F8F2),
      textMuted: Color(0xFF6272A4),
      border: Color(0xFF6272A4),
    ),
    SKOSTheme.gruvbox: const SystemThemeData(
      name: 'Gruvbox Dark',
      bg: Color(0xFF282828),
      surface: Color(0xFF1D2021),
      card: Color(0xFF3C3836),
      accent: Color(0xFFFABD2F),
      textPrimary: Color(0xFFEBDBB2),
      textMuted: Color(0xFFA89984),
      border: Color(0xFF504945),
    ),
    SKOSTheme.gitHubDark: const SystemThemeData(
      name: 'GitHub Dark',
      bg: Color(0xFF0D1117),
      surface: Color(0xFF161B22),
      card: Color(0xFF21262D),
      accent: Color(0xFF58A6FF),
      textPrimary: Color(0xFFC9D1D9),
      textMuted: Color(0xFF8B949E),
      border: Color(0xFF30363D),
    ),
    SKOSTheme.oledBlack: const SystemThemeData(
      name: 'OLED Black',
      bg: Color(0xFF000000),
      surface: Color(0xFF0A0A0A),
      card: Color(0xFF121212),
      accent: Color(0xFFFFFFFF),
      textPrimary: Color(0xFFFFFFFF),
      textMuted: Color(0xFF777777),
      border: Color(0xFF222222),
    ),
    SKOSTheme.blueprint: const SystemThemeData(
      name: 'Blueprint',
      bg: Color(0xFF002B36),
      surface: Color(0xFF00212B),
      card: Color(0xFF073642),
      accent: Color(0xFF2AA198),
      textPrimary: Color(0xFF93A1A1),
      textMuted: Color(0xFF586E75),
      border: Color(0xFF2AA198),
    ),
    SKOSTheme.cyberpunk: const SystemThemeData(
      name: 'Cyberpunk 2077',
      bg: Color(0xFF120428),
      surface: Color(0xFF1A0A3A),
      card: Color(0xFF261050),
      accent: Color(0xFFFFE600),
      textPrimary: Color(0xFF00F0FF),
      textMuted: Color(0xFFFF0055),
      border: Color(0xFF00F0FF),
    ),
  };

  SystemThemeData get current => themes[_currentTheme]!;

  void setTheme(SKOSTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}

class WindowData {
  final String id;
  final String title;
  final IconData icon;
  final Widget content;
  Offset position;
  Size size;
  bool isMinimized;
  bool isMaximized;
  int zIndex;

  WindowData({
    required this.id,
    required this.title,
    required this.icon,
    required this.content,
    this.position = const Offset(120, 60),
    this.size = const Size(850, 580),
    this.isMinimized = false,
    this.isMaximized = false,
    this.zIndex = 1,
  });
}

class WindowManager extends ChangeNotifier {
  final List<WindowData> _windows = [];
  int _topZIndex = 1;

  List<WindowData> get windows => _windows;

  void openWindow(
    String id,
    String title,
    IconData icon,
    Widget content, {
    Size defaultSize = const Size(850, 580),
  }) {
    final existingIndex = _windows.indexWhere((w) => w.id == id);
    if (existingIndex != -1) {
      _windows[existingIndex].isMinimized = false;
      bringToFront(id);
      return;
    }

    _topZIndex++;
    _windows.add(
      WindowData(
        id: id,
        title: title,
        icon: icon,
        content: content,
        size: defaultSize,
        position: Offset(
          80.0 + (_windows.length * 25),
          40.0 + (_windows.length * 25),
        ),
        zIndex: _topZIndex,
      ),
    );
    notifyListeners();
  }

  void closeWindow(String id) {
    _windows.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  void toggleMaximize(String id) {
    final win = _windows.firstWhere((w) => w.id == id);
    win.isMaximized = !win.isMaximized;
    notifyListeners();
  }

  void bringToFront(String id) {
    _topZIndex++;
    final win = _windows.firstWhere((w) => w.id == id);
    win.zIndex = _topZIndex;
    win.isMinimized = false;
    notifyListeners();
  }

  void updatePosition(String id, Offset newPos) {
    final win = _windows.firstWhere((w) => w.id == id);
    win.position = newPos;
    notifyListeners();
  }

  void updateSize(String id, Size newSize) {
    final win = _windows.firstWhere((w) => w.id == id);
    win.size = newSize;
    notifyListeners();
  }
}

// ==========================================
// 3. BOOT SEQUENCE
// ==========================================

class BootSequenceScreen extends StatefulWidget {
  final VoidCallback onBootComplete;

  const BootSequenceScreen({super.key, required this.onBootComplete});

  @override
  State<BootSequenceScreen> createState() => _BootSequenceScreenState();
}

class _BootSequenceScreenState extends State<BootSequenceScreen> {
  int _stage = 0;
  final List<String> _stages = [
    "Initializing SKOS Kernel...",
    "Loading Package Dependencies...",
    "Applying Design Tokens & Color Matrix...",
    "Detecting Hardware Layout & Displays...",
    "Launching SKOS Desktop/Mobile Environment...",
  ];

  @override
  void initState() {
    super.initState();
    _runBootSequence();
  }

  void _runBootSequence() async {
    for (int i = 0; i < _stages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _stage = i);
      }
    }
    await Future.delayed(const Duration(milliseconds: 300));
    widget.onBootComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C0E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SKOS 2.0',
              style: TextStyle(
                color: Color(0xFF20E382),
                fontFamily: 'monospace',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 240,
              child: LinearProgressIndicator(
                value: (_stage + 1) / _stages.length,
                backgroundColor: const Color(0xFF1B272C),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF20E382),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _stages[_stage],
              style: const TextStyle(
                color: Color(0xFF20E382),
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. ADAPTIVE SHELL ROUTER
// ==========================================

class SKOSAdaptiveShell extends StatelessWidget {
  const SKOSAdaptiveShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;
        return isMobile ? const SKOSMobileShell() : const SKOSDesktopShell();
      },
    );
  }
}

// ==========================================
// 5. MOBILE OS SHELL
// ==========================================

class SKOSMobileShell extends StatefulWidget {
  const SKOSMobileShell({super.key});

  @override
  State<SKOSMobileShell> createState() => _SKOSMobileShellState();
}

class _SKOSMobileShellState extends State<SKOSMobileShell> {
  final List<Map<String, dynamic>> _apps = [
    {
      'id': 'about',
      'title': 'About',
      'icon': Icons.person_pin,
      'widget': const AboutApp(),
    },
    {
      'id': 'projects',
      'title': 'Projects',
      'icon': Icons.folder_special,
      'widget': const ProjectsApp(),
    },
    {
      'id': 'career',
      'title': 'Career',
      'icon': Icons.timeline,
      'widget': const CareerApp(),
    },
    {
      'id': 'skills',
      'title': 'Skills',
      'icon': Icons.code,
      'widget': const SkillsApp(),
    },
    {
      'id': 'analytics',
      'title': 'Analytics',
      'icon': Icons.bar_chart,
      'widget': const AnalyticsApp(),
    },
    {
      'id': 'resume',
      'title': 'Resume',
      'icon': Icons.picture_as_pdf,
      'widget': const ResumeApp(),
    },
    {
      'id': 'reviews',
      'title': 'Reviews',
      'icon': Icons.rate_review,
      'widget': const ReviewsApp(),
    },
    {
      'id': 'contact',
      'title': 'Contact',
      'icon': Icons.email,
      'widget': const ContactApp(),
    },
    {
      'id': 'terminal',
      'title': 'Terminal',
      'icon': Icons.terminal,
      'widget': const TerminalApp(),
    },
    {
      'id': 'settings',
      'title': 'Settings',
      'icon': Icons.settings,
      'widget': const SettingsApp(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final winManager = Provider.of<WindowManager>(context);

    final visibleWindows =
        winManager.windows.where((w) => !w.isMinimized).toList()
          ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    final activeWindow = visibleWindows.isNotEmpty ? visibleWindows.last : null;

    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(
                  borderColor: theme.border.withValues(alpha: 0.2),
                ),
              ),
            ),
            Column(
              children: [
                const _MobileTopStatusBar(),
                Expanded(
                  child: activeWindow != null
                      ? _MobileActiveAppView(window: activeWindow)
                      : _MobileAppLauncherGrid(
                          apps: _apps,
                          onOpenApp: (app) {
                            winManager.openWindow(
                              app['id'],
                              app['title'],
                              app['icon'],
                              app['widget'],
                            );
                          },
                        ),
                ),
                _MobileBottomNavBar(
                  hasActiveApp: activeWindow != null,
                  onHomeTap: () {
                    if (activeWindow != null) {
                      winManager.closeWindow(activeWindow.id);
                    }
                  },
                  onCloseTap: () {
                    if (activeWindow != null) {
                      winManager.closeWindow(activeWindow.id);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileTopStatusBar extends StatelessWidget {
  const _MobileTopStatusBar();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: theme.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, size: 14, color: theme.accent),
              const SizedBox(width: 6),
              Text(
                "SKOS Mobile",
                style: TextStyle(
                  color: theme.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: theme.font,
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              final now = DateTime.now();
              return Text(
                "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: theme.font,
                ),
              );
            },
          ),
          Row(
            children: [
              Icon(Icons.wifi, size: 14, color: theme.textMuted),
              const SizedBox(width: 8),
              Icon(Icons.battery_charging_full, size: 14, color: theme.accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileAppLauncherGrid extends StatelessWidget {
  final List<Map<String, dynamic>> apps;
  final Function(Map<String, dynamic>) onOpenApp;

  const _MobileAppLauncherGrid({required this.apps, required this.onOpenApp});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "APPLICATIONS",
            style: TextStyle(
              color: theme.accent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontFamily: theme.font,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return InkWell(
                  onTap: () => onOpenApp(app),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.card,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.accent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            app['icon'] as IconData,
                            color: theme.accent,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          app['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: theme.font,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileActiveAppView extends StatelessWidget {
  final WindowData window;

  const _MobileActiveAppView({required this.window});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final winManager = Provider.of<WindowManager>(context, listen: false);

    return Container(
      color: theme.bg,
      child: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: theme.card,
              border: Border(bottom: BorderSide(color: theme.border)),
            ),
            child: Row(
              children: [
                Icon(window.icon, size: 16, color: theme.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    window.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: theme.font,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => winManager.closeWindow(window.id),
                ),
              ],
            ),
          ),
          Expanded(child: window.content),
        ],
      ),
    );
  }
}

class _MobileBottomNavBar extends StatelessWidget {
  final bool hasActiveApp;
  final VoidCallback onHomeTap;
  final VoidCallback onCloseTap;

  const _MobileBottomNavBar({
    required this.hasActiveApp,
    required this.onHomeTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;

    return Container(
      height: 44,
      color: theme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (hasActiveApp)
            IconButton(
              icon: Icon(Icons.close, color: theme.textMuted, size: 20),
              onPressed: onCloseTap,
            ),
          GestureDetector(
            onTap: onHomeTap,
            child: Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: theme.accent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (hasActiveApp)
            IconButton(
              icon: Icon(Icons.grid_view, color: theme.textMuted, size: 20),
              onPressed: onHomeTap,
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 6. DESKTOP SHELL & WINDOW MANAGEMENT
// ==========================================

class SKOSDesktopShell extends StatefulWidget {
  const SKOSDesktopShell({super.key});

  @override
  State<SKOSDesktopShell> createState() => _SKOSDesktopShellState();
}

class _SKOSDesktopShellState extends State<SKOSDesktopShell> {
  bool _showSpotlight = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final winManager = Provider.of<WindowManager>(context);

    final sortedWindows = List<WindowData>.from(winManager.windows)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (HardwareKeyboard.instance.isLogicalKeyPressed(
              LogicalKeyboardKey.keyK,
            ) &&
            (HardwareKeyboard.instance.isControlPressed ||
                HardwareKeyboard.instance.isMetaPressed)) {
          setState(() => _showSpotlight = !_showSpotlight);
        }
      },
      child: Scaffold(
        backgroundColor: theme.bg,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(
                  borderColor: theme.border.withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Wrap(
                direction: Axis.vertical,
                spacing: 20,
                children: [
                  _DesktopIcon(
                    title: 'About.app',
                    icon: Icons.person_pin,
                    onTap: () => winManager.openWindow(
                      'about',
                      'About — Shrawan Thakur',
                      Icons.person_pin,
                      const AboutApp(),
                    ),
                  ),
                  _DesktopIcon(
                    title: 'Projects.app',
                    icon: Icons.folder_special,
                    onTap: () => winManager.openWindow(
                      'projects',
                      'Projects Repository',
                      Icons.folder_special,
                      const ProjectsApp(),
                    ),
                  ),
                  _DesktopIcon(
                    title: 'Career.app',
                    icon: Icons.timeline,
                    onTap: () => winManager.openWindow(
                      'career',
                      'Career Experience',
                      Icons.timeline,
                      const CareerApp(),
                    ),
                  ),
                  _DesktopIcon(
                    title: 'Terminal.app',
                    icon: Icons.terminal,
                    onTap: () => winManager.openWindow(
                      'terminal',
                      'SKOS Terminal',
                      Icons.terminal,
                      const TerminalApp(),
                    ),
                  ),
                ],
              ),
            ),
            ...sortedWindows.map((win) {
              return Positioned(
                key: ValueKey(win.id),
                left: win.isMaximized ? 0 : win.position.dx,
                top: win.isMaximized ? 0 : win.position.dy,
                width: win.isMaximized
                    ? MediaQuery.of(context).size.width
                    : win.size.width,
                height: win.isMaximized
                    ? MediaQuery.of(context).size.height - 52
                    : win.size.height,
                child: Listener(
                  onPointerDown: (_) => winManager.bringToFront(win.id),
                  child: _DraggableWindowWidget(windowData: win),
                ),
              );
            }),
            if (_showSpotlight)
              SpotlightOverlay(
                onClose: () => setState(() => _showSpotlight = false),
              ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SystemTaskbarDock(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DesktopIcon({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 85,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, size: 40, color: theme.accent),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 11,
                fontFamily: theme.font,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  final Color borderColor;

  GridPatternPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.0;

    const double step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 7. DRAGGABLE WINDOW WIDGET (FIXED TOP LEFT BUTTONS)
// ==========================================

class _DraggableWindowWidget extends StatelessWidget {
  final WindowData windowData;

  const _DraggableWindowWidget({required this.windowData});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final winManager = Provider.of<WindowManager>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border.all(color: theme.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              if (!windowData.isMaximized) {
                winManager.updatePosition(
                  windowData.id,
                  windowData.position + details.delta,
                );
              }
            },
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: theme.card,
              child: Row(
                children: [
                  // Red Close Button
                  InkWell(
                    onTap: () => winManager.closeWindow(windowData.id),
                    child: const CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Grey / Disabled Action Button (Formerly crashing yellow minimize)
                  Tooltip(
                    message: "Disabled",
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Green Maximize Toggle Button
                  InkWell(
                    onTap: () => winManager.toggleMaximize(windowData.id),
                    child: const CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(windowData.icon, size: 16, color: theme.accent),
                  const SizedBox(width: 8),
                  Text(
                    windowData.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 12,
                      fontFamily: theme.font,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: windowData.content),
        ],
      ),
    );
  }
}

// ==========================================
// 8. TASKBAR, DOCK & SPOTLIGHT
// ==========================================

class SystemTaskbarDock extends StatelessWidget {
  const SystemTaskbarDock({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;

    return Container(
      height: 52,
      color: theme.surface.withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "SKOS 2.0",
                  style: TextStyle(
                    color: theme.accent,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.font,
                  ),
                ),
                const SizedBox(width: 20),
                const _DockItem(
                  icon: Icons.person,
                  label: 'About',
                  appId: 'about',
                  appWidget: AboutApp(),
                ),
                const _DockItem(
                  icon: Icons.folder,
                  label: 'Projects',
                  appId: 'projects',
                  appWidget: ProjectsApp(),
                ),
                const _DockItem(
                  icon: Icons.timeline,
                  label: 'Career',
                  appId: 'career',
                  appWidget: CareerApp(),
                ),
                const _DockItem(
                  icon: Icons.code,
                  label: 'Skills',
                  appId: 'skills',
                  appWidget: SkillsApp(),
                ),
                const _DockItem(
                  icon: Icons.bar_chart,
                  label: 'Analytics',
                  appId: 'analytics',
                  appWidget: AnalyticsApp(),
                ),
                const _DockItem(
                  icon: Icons.picture_as_pdf,
                  label: 'Resume',
                  appId: 'resume',
                  appWidget: ResumeApp(),
                ),
                const _DockItem(
                  icon: Icons.rate_review,
                  label: 'Reviews',
                  appId: 'reviews',
                  appWidget: ReviewsApp(),
                ),
                const _DockItem(
                  icon: Icons.email,
                  label: 'Contact',
                  appId: 'contact',
                  appWidget: ContactApp(),
                ),
                const _DockItem(
                  icon: Icons.terminal,
                  label: 'Terminal',
                  appId: 'terminal',
                  appWidget: TerminalApp(),
                ),
                const _DockItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  appId: 'settings',
                  appWidget: SettingsApp(),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              final now = DateTime.now();
              return Text(
                "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: theme.textMuted,
                  fontSize: 12,
                  fontFamily: theme.font,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String appId;
  final Widget appWidget;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.appId,
    required this.appWidget,
  });

  @override
  State<_DockItem> createState() => __DockItemState();
}

class __DockItemState extends State<_DockItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final winManager = Provider.of<WindowManager>(context);
    final isOpen = winManager.windows.any((w) => w.id == widget.appId);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: isHovered
            ? (Matrix4.identity()..scaleByDouble(1.2, 1.2, 1.0, 1.0))
            : Matrix4.identity(),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: IconButton(
          icon: Icon(
            widget.icon,
            color: isOpen ? theme.accent : theme.textMuted,
          ),
          onPressed: () => winManager.openWindow(
            widget.appId,
            widget.label,
            widget.icon,
            widget.appWidget,
          ),
        ),
      ),
    );
  }
}

class SpotlightOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const SpotlightOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final winManager = Provider.of<WindowManager>(context, listen: false);

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 550,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.surface,
            border: Border.all(color: theme.accent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontFamily: theme.font,
                ),
                decoration: InputDecoration(
                  hintText: 'Search apps, skills, projects...',
                  hintStyle: TextStyle(color: theme.textMuted),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: theme.accent),
                ),
                onSubmitted: (query) {
                  onClose();
                  final q = query.toLowerCase();
                  if (q.contains('project')) {
                    winManager.openWindow(
                      'projects',
                      'Projects',
                      Icons.folder,
                      const ProjectsApp(),
                    );
                  } else if (q.contains('career')) {
                    winManager.openWindow(
                      'career',
                      'Career',
                      Icons.timeline,
                      const CareerApp(),
                    );
                  } else if (q.contains('skill')) {
                    winManager.openWindow(
                      'skills',
                      'Skills',
                      Icons.code,
                      const SkillsApp(),
                    );
                  } else if (q.contains('about')) {
                    winManager.openWindow(
                      'about',
                      'About',
                      Icons.person_pin,
                      const AboutApp(),
                    );
                  } else {
                    winManager.openWindow(
                      'terminal',
                      'Terminal',
                      Icons.terminal,
                      const TerminalApp(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 9. TERMINAL APP (AUTO RE-FOCUS ON SUBMIT)
// ==========================================

class TerminalApp extends StatefulWidget {
  const TerminalApp({super.key});

  @override
  State<TerminalApp> createState() => _TerminalAppState();
}

class _TerminalAppState extends State<TerminalApp> {
  final List<String> _history = [
    "SKOS 2.0 Terminal Engine v2.4",
    "Type 'help' to inspect executable commands.\n",
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  void _handleCommand(String cmd) {
    final trimmed = cmd.trim().toLowerCase();
    setState(() {
      _history.add("> $cmd");
      switch (trimmed) {
        case 'help':
          _history.add(
            "Available Commands: about, projects, skills, resume, career, contact, clear, neofetch",
          );
          break;
        case 'about':
          _history.add(
            "Shrawan Kumar Thakur — Senior Mobile Engineer with 5+ years experience scaling Flutter & Android systems.",
          );
          break;
        case 'projects':
          _history.add(
            "Repositories: Cross Platform Design System, UHub AgTech, Asha Connect, MediPuzzle, EPS Topik Nepal, Name Online, Jhigu Store, Chotkari, IPO Connect, BCA Guide Nepal.",
          );
          break;
        case 'skills':
          _history.add(
            "Capabilities: Flutter, Dart, Android SDK, Clean Architecture, BLoC, GetX, Golden Testing, CI/CD.",
          );
          break;
        case 'neofetch':
          _history.add("""
  OS: SKOS 2.0 x86_64 / Mobile Shell
  Host: Shrawan Kumar Thakur
  Kernel: Flutter Engine
  Uptime: 5+ Years
  Shell: sksh 2.0
  Location: Kathmandu, Nepal
  """);
          break;
        case 'resume':
          _history.add("Opening resume download link in a new tab...");
          _launchURL(
            'https://drive.google.com/uc?export=download&id=1YlAWf3Sp84USiC3sBM9mEZFKQT2AD0zQ',
          );
          break;
        case 'career':
          _history.add("""
              === CAREER SUMMARY (5+ YEARS, 4 COMPANIES) ===
              1. Nekologic LLC (Aug 2025 – Jul 2026) | Kyoto, Japan
                 • Software Engineer — Mobile & Web
                 • Built cross-platform design system with 150+ components across 11 monorepo packages.
              
              2. DIT AgTech (Apr 2023 – Jul 2025) | Toowoomba, Australia
                 • Mobile Application Developer
                 • Led frontend mobile architecture for UHub AgTech using Clean Architecture & GetX.
              
              3. Ayata Inc (Apr 2022 – Mar 2023) | Kathmandu, Nepal
                 • Mid-Level Android Developer
                 • Engineered mobile apps (MediPuzzle & Name Online) with offline sync and DRM video.
              
              4. Nectar Digit Pvt Ltd (Apr 2021 – Mar 2022) | Kathmandu, Nepal
                 • Android Developer
                 • Built EPS Topik Nepal (Java) and Jhigu Store e-commerce app (Flutter).
              """);
          break;
        case 'contact':
          _history.add("""
            === CONTACT INFORMATION ===
            • Email: shrawankumarthakur77@gmail.com
            • Phone: +977 9844292280
            • Location: Kathmandu, Nepal
            """);
          break;

        case 'exit':
          _history.add("Closing terminal application...");
          Future.microtask(() {
            if (mounted) {
              Provider.of<WindowManager>(
                context,
                listen: false,
              ).closeWindow('terminal');
            }
          });
          break;
        case 'clear':
          _history.clear();
          break;
        default:
          _history.add(
            "Command not recognized. Type 'help' for available system commands.",
          );
      }
    });
    _controller.clear();

    // Auto scroll & auto re-focus back to input field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        color: theme.bg,
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _history.length + 1,
          itemBuilder: (context, index) {
            if (index < _history.length) {
              return Text(
                _history[index],
                style: TextStyle(
                  color: theme.accent,
                  fontFamily: theme.font,
                  fontSize: 12,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Text(
                    "> ",
                    style: TextStyle(
                      color: theme.accent,
                      fontFamily: theme.font,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontFamily: theme.font,
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _handleCommand,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 10. SOCIAL BUTTONS BAR
// ==========================================

class SocialButtonsBar extends StatelessWidget {
  const SocialButtonsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;

    final socialLinks = [
      {
        'icon': Icons.code,
        'url': 'https://github.com/sk77-git',
        'title': 'GitHub',
      },
      {
        'icon': Icons.business,
        'url': 'https://linkedin.com/in/shrawan-kumar-thakur-3a6a65118',
        'title': 'LinkedIn',
      },
      {
        'icon': Icons.discord,
        'url': 'https://discordapp.com/users/1121060969381105685',
        'title': 'Discord',
      },
      {
        'icon': Icons.phone_android,
        'url': 'https://wa.me/9779844292280',
        'title': 'WhatsApp',
      },
      {
        'icon': Icons.email,
        'url': 'mailto:shrawankumarthakur77@gmail.com',
        'title': 'Email',
      },
      {'icon': Icons.phone, 'url': 'tel:+9779844292280', 'title': 'Phone'},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: socialLinks.map((item) {
        return InkWell(
          onTap: () => _launchURL(item['url'] as String),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.border),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: theme.accent,
              size: 20,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ==========================================
// 11. PROJECTS APP (COMPANIES & PROJECT URLS, GALLERY,)
// ==========================================

class ProjectsApp extends StatefulWidget {
  const ProjectsApp({super.key});

  @override
  State<ProjectsApp> createState() => _ProjectsAppState();
}

class _ProjectsAppState extends State<ProjectsApp> {
  String _selectedCategory = 'Enterprise';

  final Map<String, List<Map<String, dynamic>>> projectsData = {
    'Enterprise': [
      {
        'title': 'Cross Platform Design System',
        'company': 'Nekologic LLC',
        'companyUrl': 'https://neko-logic.com',
        'desc':
            '150+ components across 11 monorepo repositories powering 1M+ downloads.',
        'tech': 'Flutter, Design Tokens, Golden Testing',
        'linkType': 'Web',
        'projectUrl': 'https://components.neko-logic.com/',
        'images': [
          'yds/screenshot_1.png',
          'yds/screenshot_2.png',
          'yds/screenshot_3.png',
          'yds/screenshot_4.png',
          'yds/screenshot_5.png',
        ],
      },
      {
        'title': 'UHub — Agricultural Operations',
        'company': 'DIT AgTech',
        'companyUrl': 'https://ditagtech.com.au',
        'desc':
            'Workforce management, supplement inventory, and IoT doser integration.',
        'tech': 'Flutter, Clean Architecture, SQLite',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=au.com.uhub&hl=en',
        'images': [
          'uhub/screenshot_1.webp',
          'uhub/screenshot_2.webp',
          'uhub/screenshot_3.webp',
          'uhub/screenshot_4.webp',
          'uhub/screenshot_5.webp',
        ],
      },
    ],
    'Consumer': [
      {
        'title': 'Chotkari — Short News',
        'company': 'Chotkari Media',
        'companyUrl': 'https://chotkari.com/',
        'desc':
            'TikTok-style vertical news scrolling app with push notifications.',
        'tech': 'Flutter, Social Auth',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.app.chotkari',
        'images': [
          'chotkari/screenshot_1.webp',
          'chotkari/screenshot_2.webp',
          'chotkari/screenshot_3.webp',
          'chotkari/screenshot_4.webp',
          'chotkari/screenshot_5.webp',
        ],
      },
      {
        'title': 'Jhigu Store',
        'company': 'Nectar Digit Pvt Ltd',
        'companyUrl': 'https://nectardigit.com',
        'desc':
            'E-commerce platform with Google Maps location pin and eSewa & Khalti integration.',
        'tech': 'Flutter, Payment Gateways',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.nectardigit.jhigu',
        'images': [
          'jhigu_store/screenshot_1.webp',
          'jhigu_store/screenshot_2.webp',
          'jhigu_store/screenshot_3.webp',
          'jhigu_store/screenshot_4.webp',
        ],
      },
      {
        'title': 'ALG Express',
        'company': 'Nectar Digit Pvt Ltd',
        'companyUrl': 'https://nectardigit.com',
        'desc': 'Logistics and delivery management application.',
        'tech': 'Flutter, REST API, Maps',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.nectardigit.airlogisticgroup',
        'images': [
          'alg_express/screenshot_1.webp',
          'alg_express/screenshot_2.webp',
          'alg_express/screenshot_3.webp',
          'alg_express/screenshot_4.webp',
        ],
      },
    ],
    'Education': [
      {
        'title': 'EPS Topik Nepal',
        'company': 'Nectar Digit Pvt Ltd',
        'companyUrl': 'https://nectardigit.com',
        'desc': 'Korean test prep app with audio listening engines.',
        'tech': 'Android SDK, Java',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.nectardigit.epstopiktest&hl=en&gl=US',
        'images': [
          'eps_topik/screenshot_1.webp',
          'eps_topik/screenshot_2.webp',
          'eps_topik/screenshot_3.webp',
        ],
      },
      {
        'title': 'Name Online',
        'company': 'Ayata Inc',
        'companyUrl': 'https://ayata.com.np',
        'desc':
            'Learning portal with encrypted video streaming and MCQ engine.',
        'tech': 'Flutter, DRM',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.avyaas.nameonline',
        'images': [
          'name_online/screenshot_1.webp',
          'name_online/screenshot_2.webp',
          'name_online/screenshot_3.webp',
          'name_online/screenshot_4.webp',
        ],
      },
    ],
    'Healthcare': [
      {
        'title': 'Asha Connect',
        'company': 'Ayata Inc',
        'companyUrl': 'https://ayata.com.np',
        'desc':
            'Japan organization funded health data collection app with procedures, media resources, and offline sync capabilities for remote places of Nepal.',
        'tech': 'Flutter, Offline Sync, Media Management',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.asha.ashaconnect&hl=en',
        'images': [
          'asha_connect/screenshot_1.webp',
          'asha_connect/screenshot_2.webp',
          'asha_connect/screenshot_3.webp',
          'asha_connect/screenshot_4.webp',
        ],
      },
      {
        'title': 'MediPuzzle',
        'company': 'Ayata Inc',
        'companyUrl': 'https://ayata.com.np',
        'desc': 'Gamified medical learning app with multi-tier leaderboards.',
        'tech': 'Android SDK, Leaderboards',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.ayata.medipuzzle',
        'images': [
          'medipuzzle/screenshot_1.webp',
          'medipuzzle/screenshot_2.webp',
          'medipuzzle/screenshot_3.webp',
          'medipuzzle/screenshot_4.webp',
          'medipuzzle/screenshot_5.webp',
          'medipuzzle/screenshot_6.webp',
        ],
      },
    ],
    'Personal': [
      {
        'title': 'BCA Guide Nepal',
        'company': 'Personal Project',
        'companyUrl': 'https://bcaguidenepal.com',
        'desc':
            'Educational notes and study portal for BCA university students in Nepal.',
        'tech': 'Flutter, REST APIs, Web',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.skthakur.bcaguidesnepal',
        'images': [
          'bca_guide_nepal/screenshot_1.webp',
          'bca_guide_nepal/screenshot_2.webp',
          'bca_guide_nepal/screenshot_3.webp',
          'bca_guide_nepal/screenshot_4.webp',
          'bca_guide_nepal/screenshot_5.webp',
        ],
      },
      {
        'title': 'IPO Connect',
        'company': 'Personal Project',
        'companyUrl':
            'https://play.google.com/store/apps/details?id=com.skthakur.ipoconnect',
        'desc':
            'MeroShare account automation and bulk IPO result tracking app.',
        'tech': 'Flutter, BLoC, SQLite',
        'linkType': 'Play Store',
        'projectUrl':
            'https://play.google.com/store/apps/details?id=com.skthakur.ipoconnect',
        'images': [
          'ipo_connect/screenshot_1.webp',
          'ipo_connect/screenshot_2.webp',
          'ipo_connect/screenshot_3.webp',
          'ipo_connect/screenshot_4.webp',
          'ipo_connect/screenshot_5.webp',
        ],
      },
    ],
  };

  void _showImageGallery(
    BuildContext context,
    String title,
    List<String> images,
  ) {
    final theme = Provider.of<ThemeEngine>(context, listen: false).current;
    final PageController pageController = PageController();

    showDialog(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final isMobile = screenSize.width < 600;

        // Adaptive width & height tuned specifically for vertical mobile screenshots
        final double dialogWidth = isMobile ? screenSize.width * 0.85 : 420.0;
        final double dialogHeight = isMobile
            ? screenSize.height * 0.65
            : screenSize.height * 0.75;

        return AlertDialog(
          backgroundColor: theme.surface,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          title: Text(
            "$title — Gallery",
            style: TextStyle(
              color: theme.accent,
              fontSize: 14,
              fontFamily: theme.font,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // PageView with Dragging Enabled
                PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  itemBuilder: (context, index) {
                    final imgPath = images[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.card,
                        border: Border.all(color: theme.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/$imgPath",
                          fit: BoxFit.contain,
                          // Preserves screenshot aspect ratio without cropping
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: theme.textMuted,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Asset Image: ${imgPath.split('/').last}",
                                    style: TextStyle(
                                      color: theme.textMuted,
                                      fontSize: 11,
                                      fontFamily: theme.font,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Left Navigation Arrow (Desktop & Mobile)
                if (images.length > 1)
                  Positioned(
                    left: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.bg.withValues(alpha: 0.8),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: theme.accent,
                          size: 14,
                        ),
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),

                // Right Navigation Arrow (Desktop & Mobile)
                if (images.length > 1)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.bg.withValues(alpha: 0.8),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: theme.accent,
                          size: 14,
                        ),
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: TextStyle(color: theme.accent, fontFamily: theme.font),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final categories = projectsData.keys.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 550;

        if (isCompact) {
          return Column(
            children: [
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((cat) {
                    final isSelected = cat == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: ChoiceChip(
                        label: Text(cat, style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        selectedColor: theme.accent,
                        labelStyle: TextStyle(
                          color: isSelected ? theme.bg : theme.textPrimary,
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(child: _buildProjectList(theme)),
            ],
          );
        }

        return Row(
          children: [
            Container(
              width: 150,
              color: theme.surface,
              child: ListView(
                children: categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: theme.card,
                    title: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? theme.accent : theme.textPrimary,
                        fontSize: 12,
                        fontFamily: theme.font,
                      ),
                    ),
                    onTap: () => setState(() => _selectedCategory = cat),
                  );
                }).toList(),
              ),
            ),
            Expanded(child: _buildProjectList(theme)),
          ],
        );
      },
    );
  }

  Widget _buildProjectList(SystemThemeData theme) {
    return Container(
      color: theme.bg,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: projectsData[_selectedCategory]!.length,
        itemBuilder: (context, index) {
          final p = projectsData[_selectedCategory]![index];
          final List<String> images = List<String>.from(p['images'] ?? []);

          return Card(
            color: theme.card,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          p['title']!,
                          style: TextStyle(
                            color: theme.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: theme.font,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _launchURL(p['companyUrl']!),
                        child: Row(
                          children: [
                            Text(
                              p['company']!,
                              style: TextStyle(
                                color: theme.textMuted,
                                fontSize: 10,
                                decoration: TextDecoration.underline,
                                fontFamily: theme.font,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.open_in_new,
                              size: 10,
                              color: theme.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p['desc']!,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 11,
                      height: 1.4,
                      fontFamily: theme.font,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tech: ${p['tech']!}",
                    style: TextStyle(
                      color: theme.textMuted,
                      fontSize: 9,
                      fontFamily: theme.font,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: theme.accent.withValues(alpha: 0.6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                        ),
                        icon: Icon(
                          p['linkType'] == 'Play Store'
                              ? Icons.play_arrow
                              : Icons.language,
                          size: 14,
                          color: theme.accent,
                        ),
                        label: Text(
                          "View ${p['linkType']}",
                          style: TextStyle(
                            color: theme.accent,
                            fontSize: 10,
                            fontFamily: theme.font,
                          ),
                        ),
                        onPressed: () => _launchURL(p['projectUrl']!),
                      ),
                      if (images.isNotEmpty)
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.border),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          icon: Icon(
                            Icons.collections,
                            size: 14,
                            color: theme.textPrimary,
                          ),
                          label: Text(
                            "View Gallery",
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 10,
                              fontFamily: theme.font,
                            ),
                          ),
                          onPressed: () =>
                              _showImageGallery(context, p['title']!, images),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 12. COMPACT ANALYTICS CARDS FOR DESKTOP
// ==========================================

class AnalyticsApp extends StatelessWidget {
  const AnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    return Scaffold(
      backgroundColor: theme.bg,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "System Analytics & Metrics",
              style: TextStyle(
                color: theme.accent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: theme.font,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: GridView.extent(
                    maxCrossAxisExtent: 220,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _ChartCard(
                        title: "Downloads",
                        val: "70,000+",
                        theme: theme,
                      ),
                      _ChartCard(
                        title: "Organizations",
                        val: "27",
                        theme: theme,
                      ),
                      _ChartCard(
                        title: "Enterprise Users",
                        val: "300+",
                        theme: theme,
                      ),
                      _ChartCard(
                        title: "Design System Repos",
                        val: "11 Repos",
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String val;
  final SystemThemeData theme;

  const _ChartCard({
    required this.title,
    required this.val,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.card,
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textMuted,
              fontSize: 10,
              fontFamily: theme.font,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: TextStyle(
              color: theme.accent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: theme.font,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 13. UPDATED REVIEWS APP (5 RECOMMENDATIONS)
// ==========================================

class ReviewsApp extends StatelessWidget {
  const ReviewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final List<Map<String, String>> reviews = [
      {
        'name': 'Prasan Ghimire',
        'role': 'Software Engineer at DIT AgTech',
        'avatar': 'P',
        'msg':
            'Shrawan is a brilliant mobile app developer and a fantastic cross-functional partner. Throughout our time working together at DIT, I was consistently impressed by his architectural foresight and ability to design scalable systems built for long-term stability. He has an incredible knack for unpacking complex logic, which makes him highly effective at solving tough state management and performance bottlenecks. Shrawan brings immense value to both the code and the team culture, and he will be a tremendous asset anywhere he goes.',
      },
      {
        'name': 'Marsden Jacques',
        'role': 'Technical Product Lead, NekoLogic LLC',
        'avatar': 'M',
        'msg':
            'I managed Shrawan for a year and highly recommend him as a dependable and collaborative addition to any engineering team. He has a strong grasp of the business logic behind the software he builds, frequently translating that understanding into insightful suggestions and forward-thinking implementations that anticipate future project needs. Shrawan is a skilled developer who brings a genuinely positive energy to the workspace, and I would gladly work with him again given the chance.',
      },
      {
        'name': 'Adarsha Bajagain',
        'role': 'Chief Technology Officer, Ayata Inc.',
        'avatar': 'A',
        'msg':
            'Shrawan consistently optimized existing projects and delivered new features quickly. What stood out most was his ability to thoroughly understand requirements and implement them correctly the first time. His technical skills and efficiency make him a valuable member of any engineering team.',
      },
      {
        'name': 'Seikh Sazzad Hussain',
        'role': 'CEO, LIGHTCODE',
        'avatar': 'S',
        'msg':
            'Hiring Shrawan for Android app development was one of my best decisions. He designed and developed the application exactly as per the requirements, delivering a high-quality product for my client. There is no doubt he is a talented and reliable mobile developer.',
      },
      {
        'name': 'Om Shrestha',
        'role': 'Project Manager, Chotkari',
        'avatar': 'O',
        'msg':
            'Working with Shrawan was a great experience. He developed the Chotkari News App from scratch, delivered the project successfully, and continued providing support even after the contract had ended. His commitment and professionalism made him a dependable development partner.',
      },
    ];

    return Scaffold(
      backgroundColor: theme.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final r = reviews[index];

              if (isCompact) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: theme.card,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.accent,
                      radius: 16,
                      child: Text(
                        r['avatar']!,
                        style: TextStyle(
                          color: theme.bg,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      r['name']!,
                      style: TextStyle(
                        color: theme.accent,
                        fontWeight: FontWeight.bold,
                        fontFamily: theme.font,
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      r['role']!,
                      style: TextStyle(
                        color: theme.textMuted,
                        fontSize: 10,
                        fontFamily: theme.font,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          r['msg']!,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 11,
                            height: 1.4,
                            fontFamily: theme.font,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                color: theme.card,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.accent,
                      radius: 18,
                      child: Text(
                        r['avatar']!,
                        style: TextStyle(
                          color: theme.bg,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['name']!,
                            style: TextStyle(
                              color: theme.accent,
                              fontWeight: FontWeight.bold,
                              fontFamily: theme.font,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            r['role']!,
                            style: TextStyle(
                              color: theme.textMuted,
                              fontSize: 10,
                              fontFamily: theme.font,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r['msg']!,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 11,
                              height: 1.4,
                              fontFamily: theme.font,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ==========================================
// 14. OTHER APPS (ABOUT, SKILLS, RESUME, CONTACT, SETTINGS)
// ==========================================

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    return Scaffold(
      backgroundColor: theme.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: theme.accent,
                  child: Text(
                    "ST",
                    style: TextStyle(
                      color: theme.bg,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shrawan Kumar Thakur",
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: theme.font,
                        ),
                      ),
                      Text(
                        "Senior Mobile Engineer — Flutter & Android",
                        style: TextStyle(
                          color: theme.accent,
                          fontSize: 11,
                          fontFamily: theme.font,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        color: theme.accent.withValues(alpha: 0.2),
                        child: Text(
                          "open_to_engineering_roles",
                          style: TextStyle(
                            color: theme.accent,
                            fontSize: 10,
                            fontFamily: theme.font,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SocialButtonsBar(),
            const SizedBox(height: 24),
            Text(
              "Mobile Engineer with 5+ years architecting and scaling Flutter & Android apps across Australia, Japan, and Nepal. Specialized in Clean Architecture, BLoC state management, monorepo design systems, and reliable cross-platform delivery.",
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 12,
                height: 1.5,
                fontFamily: theme.font,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CareerApp extends StatelessWidget {
  const CareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final List<Map<String, String>> experiences = [
      {
        'company': 'Nekologic LLC',
        'role': 'Software Engineer — Mobile and Web',
        'period': 'Aug 2025 – Jul 2026',
        'location': 'Kyoto, Japan',
        'desc':
            'Contributed to cross-platform design system comprising 150+ reusable components across 11 repositories. Implemented golden testing strategies.',
      },
      {
        'company': 'DIT AgTech',
        'role': 'Mobile Application Developer',
        'period': 'Apr 2023 – Jul 2025',
        'location': 'Toowoomba, Australia',
        'desc':
            'Led end-to-end mobile engineering for enterprise Flutter applications (UHub). Reduced maintenance overhead using Clean Architecture and GetX.',
      },
      {
        'company': 'Ayata Inc',
        'role': 'Mid-Level Android Developer',
        'period': 'Apr 2022 – Mar 2023',
        'location': 'Kathmandu, Nepal',
        'desc':
            'Optimized performance for MediPuzzle and Name Online. Mentored junior developers.',
      },
      {
        'company': 'Nectar Digit Pvt Ltd',
        'role': 'Android Developer',
        'period': 'Apr 2021 – Mar 2022',
        'location': 'Kathmandu, Nepal',
        'desc':
            'Engineered EPS Topik Nepal in Java and built Jhigu Store e-commerce Flutter app as lead developer.',
      },
    ];

    return Scaffold(
      backgroundColor: theme.bg,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          final exp = experiences[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.card,
              border: Border.all(color: theme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exp['company']!,
                        style: TextStyle(
                          color: theme.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: theme.font,
                        ),
                      ),
                    ),
                    Text(
                      exp['period']!,
                      style: TextStyle(
                        color: theme.textMuted,
                        fontSize: 10,
                        fontFamily: theme.font,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  exp['role']!,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 11,
                    fontFamily: theme.font,
                  ),
                ),
                Text(
                  "📍 ${exp['location']!}",
                  style: TextStyle(
                    color: theme.textMuted,
                    fontSize: 9,
                    fontFamily: theme.font,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exp['desc']!,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 11,
                    height: 1.4,
                    fontFamily: theme.font,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SkillsApp extends StatelessWidget {
  const SkillsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    final skills = [
      {'category': 'Languages', 'items': 'Dart, Kotlin, Java'},
      {'category': 'Mobile Frameworks', 'items': 'Flutter, Android SDK'},
      {
        'category': 'Architecture',
        'items': 'Clean Architecture, MVVM, MVC, Modular',
      },
      {'category': 'State Management', 'items': 'BLoC, Cubit, GetX'},
      {'category': 'Testing', 'items': 'Unit, Widget, Golden, Integration'},
      {
        'category': 'Networking & Storage',
        'items': 'REST APIs, WebSockets, SQLite, SharedPreferences',
      },
    ];

    return Scaffold(
      backgroundColor: theme.bg,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final item = skills[index];
          return ExpansionTile(
            title: Text(
              item['category']!,
              style: TextStyle(
                color: theme.accent,
                fontSize: 13,
                fontFamily: theme.font,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  item['items']!,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 12,
                    fontFamily: theme.font,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ResumeApp extends StatelessWidget {
  const ResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;
    const downloadUrl =
        'https://drive.google.com/uc?export=download&id=1YlAWf3Sp84USiC3sBM9mEZFKQT2AD0zQ';

    return Scaffold(
      backgroundColor: theme.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf, size: 50, color: theme.accent),
              const SizedBox(height: 16),
              Text(
                "Shrawan_Kumar_Thakur_Resume.pdf",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontFamily: theme.font,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: Icon(Icons.download, color: theme.bg, size: 18),
                label: Text(
                  "Download",
                  style: TextStyle(
                    color: theme.bg,
                    fontFamily: theme.font,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => _launchURL(downloadUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactApp extends StatefulWidget {
  const ContactApp({super.key});

  @override
  State<ContactApp> createState() => _ContactAppState();
}

class _ContactAppState extends State<ContactApp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  void _sendEmail() {
    if (_formKey.currentState!.validate()) {
      final String recipient = 'shrawankumarthakur77@gmail.com';
      final String subject = _subjectController.text.trim();
      final String body =
          "Name: ${_nameController.text.trim()}\nEmail: ${_emailController.text.trim()}\n\nMessage:\n${_messageController.text.trim()}";

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: recipient,
        queryParameters: {'subject': subject, 'body': body},
      );

      _launchURL(emailUri.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeEngine>(context).current;

    return Scaffold(
      backgroundColor: theme.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "GET IN TOUCH",
                style: TextStyle(
                  color: theme.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: theme.font,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 12,
                  fontFamily: theme.font,
                ),
                decoration: InputDecoration(
                  labelText: "Your Name",
                  labelStyle: TextStyle(color: theme.textMuted, fontSize: 11),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.accent),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 12,
                  fontFamily: theme.font,
                ),
                decoration: InputDecoration(
                  labelText: "Your Email",
                  labelStyle: TextStyle(color: theme.textMuted, fontSize: 11),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.accent),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(val.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subjectController,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 12,
                  fontFamily: theme.font,
                ),
                decoration: InputDecoration(
                  labelText: "Subject",
                  labelStyle: TextStyle(color: theme.textMuted, fontSize: 11),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.accent),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter a subject'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 12,
                  fontFamily: theme.font,
                ),
                decoration: InputDecoration(
                  labelText: "Message...",
                  labelStyle: TextStyle(color: theme.textMuted, fontSize: 11),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.accent),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter your message'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(Icons.send, color: theme.bg, size: 16),
                label: Text(
                  "Send Message via Email",
                  style: TextStyle(
                    color: theme.bg,
                    fontFamily: theme.font,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _sendEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeEngine = Provider.of<ThemeEngine>(context);
    final theme = themeEngine.current;

    return Scaffold(
      backgroundColor: theme.bg,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Theme Switcher",
              style: TextStyle(
                color: theme.accent,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: theme.font,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: SKOSTheme.values.map((t) {
                  final data = ThemeEngine.themes[t]!;
                  return ListTile(
                    dense: true,
                    title: Text(
                      data.name,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontFamily: theme.font,
                        fontSize: 12,
                      ),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: data.accent,
                      radius: 8,
                    ),
                    onTap: () => themeEngine.setTheme(t),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

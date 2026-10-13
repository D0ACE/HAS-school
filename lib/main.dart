import 'package:flutter/material.dart';

void main() {
  runApp(const HsbApp());
}

class HsbApp extends StatelessWidget {
  const HsbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hindustan Standards Bureau',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: HsbColors.navy,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: HsbColors.cream,
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class MyApp extends HsbApp {
  const MyApp({super.key});
}

class HsbColors {
  static const navy = Color(0xFF17324D);
  static const blue = Color(0xFF2C6E9E);
  static const sky = Color(0xFFE8F1F5);
  static const cream = Color(0xFFF8F6F0);
  static const gold = Color(0xFFE6B65A);
  static const coral = Color(0xFFE98268);
  static const ink = Color(0xFF263746);
  static const muted = Color(0xFF6D7B85);
}

class _RevealOnMount extends StatefulWidget {
  const _RevealOnMount({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  State<_RevealOnMount> createState() => _RevealOnMountState();
}

class _RevealOnMountState extends State<_RevealOnMount>
    with SingleTickerProviderStateMixin {
  late final int _totalMilliseconds = 650 + widget.delay.inMilliseconds;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _totalMilliseconds),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMilliseconds / _totalMilliseconds,
      1,
      curve: Curves.easeOutCubic,
    ),
  );
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            widget.delay.inMilliseconds / _totalMilliseconds,
            1,
            curve: Curves.easeOutCubic,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class _HoverLift extends StatefulWidget {
  const _HoverLift({required this.child});

  final Widget child;

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -5 : 0, 0),
          child: widget.child,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(
              onLearning: () => _open(context, const LearningPage()),
              onAdmissions: () => _open(context, const AdmissionsPage()),
              onAbout: () => _open(context, const AboutPage()),
              onLogin: () => _open(context, const LoginPage()),
            ),
          ),
          SliverToBoxAdapter(
            child: _RevealOnMount(
              child: _HeroSection(
                onExplore: () => _open(context, const LearningPage()),
                onVisit: () => _open(context, const AdmissionsPage()),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: _RevealOnMount(
              delay: Duration(milliseconds: 120),
              child: _TrustStrip(),
            ),
          ),
          const SliverToBoxAdapter(
            child: _RevealOnMount(
              delay: Duration(milliseconds: 180),
              child: _ProgramsSection(),
            ),
          ),
          const SliverToBoxAdapter(
            child: _RevealOnMount(
              delay: Duration(milliseconds: 240),
              child: _CommunitySection(),
            ),
          ),
          SliverToBoxAdapter(
            child: _RevealOnMount(
              delay: const Duration(milliseconds: 300),
              child: _NewsSection(
                onViewAll: () => _open(context, const AboutPage()),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _Footer(onLogin: () => _open(context, const LoginPage())),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onLearning,
    required this.onAdmissions,
    required this.onAbout,
    required this.onLogin,
  });

  final VoidCallback onLearning;
  final VoidCallback onAdmissions;
  final VoidCallback onAbout;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;
        return Container(
          color: HsbColors.cream,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 20 : 64,
            vertical: 20,
          ),
          child: Row(
            children: [
              const _Brand(),
              const Spacer(),
              if (!compact) ...[
                _NavButton(label: 'Learning', onPressed: onLearning),
                _NavButton(label: 'Admissions', onPressed: onAdmissions),
                _NavButton(label: 'About us', onPressed: onAbout),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.person_outline_rounded, size: 18),
                  label: const Text('Student login'),
                  style: FilledButton.styleFrom(
                    backgroundColor: HsbColors.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ] else
                IconButton(
                  onPressed: onLogin,
                  tooltip: 'Student login',
                  icon: const Icon(
                    Icons.person_outline_rounded,
                    color: HsbColors.navy,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: HsbColors.navy,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: HsbColors.gold,
            size: 24,
          ),
        ),
        const SizedBox(width: 11),
        Flexible(
          child: Text(
            'Hindustan Standards Bureau',
            style: const TextStyle(
              color: HsbColors.navy,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: HsbColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      ),
      child: Text(label),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.onExplore, required this.onVisit});

  final VoidCallback onExplore;
  final VoidCallback onVisit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;
        return Container(
          color: HsbColors.cream,
          padding: EdgeInsets.fromLTRB(
            compact ? 24 : 80,
            46,
            compact ? 24 : 80,
            76,
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RevealOnMount(
                      offset: const Offset(-0.08, 0),
                      child: _HeroCopy(onExplore: onExplore, onVisit: onVisit),
                    ),
                    const SizedBox(height: 42),
                    const _RevealOnMount(
                      delay: Duration(milliseconds: 180),
                      offset: Offset(0.08, 0),
                      child: _HeroIllustration(),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _RevealOnMount(
                        offset: const Offset(-0.08, 0),
                        child: _HeroCopy(
                          onExplore: onExplore,
                          onVisit: onVisit,
                        ),
                      ),
                    ),
                    const SizedBox(width: 70),
                    const Expanded(
                      child: _RevealOnMount(
                        delay: Duration(milliseconds: 180),
                        offset: Offset(0.08, 0),
                        child: _HeroIllustration(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onExplore, required this.onVisit});

  final VoidCallback onExplore;
  final VoidCallback onVisit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WELCOME TO HSB',
          style: TextStyle(
            color: HsbColors.coral,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Curious minds.\nKind hearts.',
          style: TextStyle(
            color: HsbColors.navy,
            fontSize: 56,
            height: 1.03,
            fontWeight: FontWeight.w800,
            letterSpacing: -2.2,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'A joyful, ambitious school where every student is known, challenged and inspired to make a difference.',
          style: TextStyle(color: HsbColors.muted, fontSize: 17, height: 1.55),
        ),
        const SizedBox(height: 31),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Explore learning'),
              style: FilledButton.styleFrom(
                backgroundColor: HsbColors.coral,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: onVisit,
              style: OutlinedButton.styleFrom(
                foregroundColor: HsbColors.navy,
                side: const BorderSide(color: HsbColors.navy),
                padding: const EdgeInsets.symmetric(
                  horizontal: 21,
                  vertical: 16,
                ),
              ),
              child: const Text('Plan a visit'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroIllustration extends StatefulWidget {
  const _HeroIllustration();

  @override
  State<_HeroIllustration> createState() => _HeroIllustrationState();
}

class _HeroIllustrationState extends State<_HeroIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final y = Curves.easeInOut.transform(_controller.value) * 8 - 4;
        return Transform.translate(offset: Offset(0, y), child: child);
      },
      child: AspectRatio(
        aspectRatio: 1.16,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: HsbColors.sky,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            const Positioned(
              top: 34,
              right: 44,
              child: Icon(
                Icons.wb_sunny_rounded,
                color: HsbColors.gold,
                size: 58,
              ),
            ),
            const Positioned(
              bottom: 38,
              left: 35,
              child: Icon(
                Icons.local_florist_rounded,
                color: HsbColors.coral,
                size: 62,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 35,
              right: 35,
              child: Container(
                height: 53,
                decoration: const BoxDecoration(
                  color: HsbColors.navy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
              ),
            ),
            Positioned(
              bottom: 43,
              child: Container(
                width: 245,
                height: 165,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x250E2638),
                      blurRadius: 20,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 43,
                      decoration: const BoxDecoration(
                        color: HsbColors.blue,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(9),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'LEARN • CREATE • CONNECT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MiniIcon(
                            icon: Icons.palette_rounded,
                            color: HsbColors.coral,
                          ),
                          _MiniIcon(
                            icon: Icons.science_rounded,
                            color: HsbColors.gold,
                          ),
                          _MiniIcon(
                            icon: Icons.groups_rounded,
                            color: HsbColors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 101,
              left: 70,
              child: Icon(Icons.cloud_rounded, color: Colors.white, size: 47),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  const _MiniIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color.withValues(alpha: 0.16),
      child: Icon(icon, color: color, size: 25),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HsbColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: const Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 22,
        spacing: 22,
        children: [
          _Stat(value: '35+', label: 'years of learning'),
          _Stat(value: '1:12', label: 'teacher to student ratio'),
          _Stat(value: '98%', label: 'go on to their first choice'),
          _Stat(value: '24', label: 'clubs and societies'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      child: Row(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: HsbColors.gold,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramsSection extends StatelessWidget {
  const _ProgramsSection();

  @override
  Widget build(BuildContext context) {
    return const _PageSection(
      eyebrow: 'THE HSB JOURNEY',
      title: 'Learning that feels\nlike an adventure.',
      description: 'From their first steps into school to their final year, students build the confidence and curiosity to shape their own future.',
      children: [
        _ProgramCard(
          icon: Icons.park_rounded,
          color: HsbColors.coral,
          age: 'AGES 3–6',
          title: 'Early years',
          text:
              'Big imaginations, gentle beginnings and plenty of room to play.',
        ),
        _ProgramCard(
          icon: Icons.auto_stories_rounded,
          color: HsbColors.blue,
          age: 'AGES 7–11',
          title: 'Primary school',
          text:
              'Strong foundations in a classroom full of discovery and wonder.',
        ),
        _ProgramCard(
          icon: Icons.rocket_launch_rounded,
          color: HsbColors.gold,
          age: 'AGES 12–18',
          title: 'Senior school',
          text: 'Confident thinkers ready to make their mark on the world.',
        ),
      ],
    );
  }
}

class _PageSection extends StatelessWidget {
  const _PageSection({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.children,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth < 850 ? 24.0 : 80.0;
        return Padding(
          padding: EdgeInsets.fromLTRB(horizontal, 76, horizontal, 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(
                eyebrow: eyebrow,
                title: title,
                description: description,
              ),
              const SizedBox(height: 38),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  for (var index = 0; index < children.length; index++)
                    _RevealOnMount(
                      delay: Duration(milliseconds: index * 100),
                      child: children[index],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: HsbColors.coral,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(
              color: HsbColors.navy,
              fontSize: 37,
              height: 1.13,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            description,
            style: const TextStyle(
              color: HsbColors.muted,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.icon,
    required this.color,
    required this.age,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String age;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      child: SizedBox(
        width: 300,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE5E9E9)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(height: 24),
                Text(
                  age,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  title,
                  style: const TextStyle(
                    color: HsbColors.navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  text,
                  style: const TextStyle(
                    color: HsbColors.muted,
                    height: 1.45,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunitySection extends StatelessWidget {
  const _CommunitySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HsbColors.sky,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 65),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 700;
              return compact
                  ? const Column(
                      children: [
                        _CommunityArt(),
                        SizedBox(height: 35),
                        _CommunityCopy(),
                      ],
                    )
                  : Row(
                      children: [
                        const Expanded(child: _CommunityArt()),
                        const SizedBox(width: 78),
                        const Expanded(child: _CommunityCopy()),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _CommunityArt extends StatelessWidget {
  const _CommunityArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: HsbColors.gold.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Center(
        child: CircleAvatar(
          radius: 88,
          backgroundColor: Colors.white,
          child: Icon(Icons.groups_rounded, color: HsbColors.navy, size: 84),
        ),
      ),
    );
  }
}

class _CommunityCopy extends StatelessWidget {
  const _CommunityCopy();

  @override
  Widget build(BuildContext context) {
    return const _SectionHeading(
      eyebrow: 'MORE THAN A SCHOOL',
      title: 'A community with\nroom for everyone.',
      description: 'We believe the best learning happens when children feel safe to be themselves. Our teachers notice the little things, celebrate progress and help every student find their spark.',
    );
  }
}

class _NewsSection extends StatelessWidget {
  const _NewsSection({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 74),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'From our community',
                    style: TextStyle(
                      color: HsbColors.navy,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              const Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  _RevealOnMount(
                    delay: Duration.zero,
                    child: _NewsCard(
                      date: 'OCT 14, 2025',
                      title: 'HSB wins regional young artists award',
                      icon: Icons.palette_rounded,
                      color: HsbColors.coral,
                    ),
                  ),
                  _RevealOnMount(
                    delay: Duration(milliseconds: 100),
                    child: _NewsCard(
                      date: 'SEP 29, 2025',
                      title: 'Five ways we make reading a daily habit',
                      icon: Icons.menu_book_rounded,
                      color: HsbColors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.date,
    required this.title,
    required this.icon,
    required this.color,
  });

  final String date;
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 365,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: HsbColors.navy,
                    fontSize: 16,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HsbColors.navy,
      padding: const EdgeInsets.fromLTRB(24, 42, 24, 32),
      child: Column(
        children: [
          const _Brand(),
          const SizedBox(height: 20),
          const Text(
            'Learn with purpose. Grow with confidence.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('Open student portal'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            '© 2025 Hindustan Standards Bureau  •  hello@hsb.edu',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _InnerPage extends StatelessWidget {
  const _InnerPage({
    required this.title,
    required this.eyebrow,
    required this.description,
    required this.icon,
    required this.children,
  });

  final String title;
  final String eyebrow;
  final String description;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _Brand(),
        backgroundColor: HsbColors.cream,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 38, 24, 60),
        children: [
          _RevealOnMount(
            offset: const Offset(0, 0.05),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: HsbColors.sky,
                      child: Icon(icon, color: HsbColors.blue, size: 28),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      eyebrow,
                      style: const TextStyle(
                        color: HsbColors.coral,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: HsbColors.navy,
                        fontSize: 42,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      description,
                      style: const TextStyle(
                        color: HsbColors.muted,
                        fontSize: 17,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 34),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _InnerPage(
      eyebrow: 'LEARNING AT HSB',
      title: 'A place to discover your spark.',
      description: 'Our learning programme balances academic challenge with creativity, collaboration and time to explore what makes each student unique.',
      icon: Icons.auto_stories_rounded,
      children: const [
        _InfoTile(
          icon: Icons.science_rounded,
          title: 'Hands-on classrooms',
          text: 'Students learn by asking questions, testing ideas and making meaningful connections.',
        ),
        _InfoTile(
          icon: Icons.palette_rounded,
          title: 'Creative expression',
          text:
              'Music, art, drama and design are part of everyday school life.',
        ),
        _InfoTile(
          icon: Icons.sports_soccer_rounded,
          title: 'Clubs for every interest',
          text: 'Choose from 24 clubs and societies, from robotics to sport and community service.',
        ),
      ],
    );
  }
}

class AdmissionsPage extends StatelessWidget {
  const AdmissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _InnerPage(
      eyebrow: 'JOIN OUR COMMUNITY',
      title: 'Your HSB journey starts here.',
      description: 'We would love to meet your family. Visit our campus, talk with our team and discover what makes HSB feel like home.',
      icon: Icons.handshake_rounded,
      children: [
        const _InfoTile(
          icon: Icons.event_rounded,
          title: 'Book a campus visit',
          text: 'Tours are available Monday to Friday from 9:00 AM to 3:00 PM.',
        ),
        const _InfoTile(
          icon: Icons.description_rounded,
          title: 'Simple application process',
          text: 'Our admissions team will guide you through every step.',
        ),
        FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thanks! Our admissions team will contact you.'),
              ),
            );
          },
          icon: const Icon(Icons.mail_outline_rounded),
          label: const Text('Request more information'),
          style: FilledButton.styleFrom(
            backgroundColor: HsbColors.coral,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InnerPage(
      eyebrow: 'OUR STORY',
      title: 'Rooted in care. Ready for tomorrow.',
      description: 'Since 1987, Hindustan Standards Bureau has helped students grow into confident, compassionate and capable young people.',
      icon: Icons.favorite_rounded,
      children: [
        _InfoTile(
          icon: Icons.people_alt_rounded,
          title: 'A personal approach',
          text: 'Teachers know every student well and celebrate progress at every stage.',
        ),
        _InfoTile(
          icon: Icons.public_rounded,
          title: 'A wider perspective',
          text: 'We prepare students to contribute thoughtfully to their local and global communities.',
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE5E9E9)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: HsbColors.sky,
                child: Icon(icon, color: HsbColors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: HsbColors.navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      text,
                      style: const TextStyle(
                        color: HsbColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const StudentPortalPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student login'),
        backgroundColor: HsbColors.cream,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Color(0xFFE5E9E9)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: HsbColors.sky,
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: HsbColors.blue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: HsbColors.navy,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to view your timetable, assignments and school updates.',
                        style: TextStyle(color: HsbColors.muted, height: 1.45),
                      ),
                      const SizedBox(height: 26),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'School email',
                          hintText: 'you@hsb.edu',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              !value.contains('@') ||
                              value.trim().length < 5) {
                            return 'Enter a valid school email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password reset instructions are on their way.',
                                ),
                              ),
                            );
                          },
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: HsbColors.navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Sign in'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudentPortalPage extends StatelessWidget {
  const StudentPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student portal'),
        backgroundColor: HsbColors.cream,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Good morning, student!',
            style: TextStyle(
              color: HsbColors.navy,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Here is what is happening at HSB today.',
            style: TextStyle(color: HsbColors.muted, fontSize: 16),
          ),
          const SizedBox(height: 28),
          const _PortalCard(
            icon: Icons.calendar_month_rounded,
            title: 'Today’s timetable',
            detail: 'Mathematics  •  Science  •  Creative studio',
            color: HsbColors.blue,
          ),
          const _PortalCard(
            icon: Icons.assignment_rounded,
            title: 'Assignments',
            detail: '2 tasks are due this week',
            color: HsbColors.coral,
          ),
          const _PortalCard(
            icon: Icons.campaign_rounded,
            title: 'School updates',
            detail: 'Spring clubs sign-up is now open',
            color: HsbColors.gold,
          ),
        ],
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  const _PortalCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE5E9E9)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: HsbColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(detail),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ),
    );
  }
}

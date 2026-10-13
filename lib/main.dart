import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oakridge Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _AppColors.navy,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: _AppColors.cream,
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const SchoolHomePage(),
    );
  }
}

class _AppColors {
  static const navy = Color(0xFF17324D);
  static const blue = Color(0xFF2C6E9E);
  static const sky = Color(0xFFE8F1F5);
  static const cream = Color(0xFFF8F6F0);
  static const gold = Color(0xFFE6B65A);
  static const coral = Color(0xFFE98268);
  static const ink = Color(0xFF263746);
  static const muted = Color(0xFF6D7B85);
}

class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({super.key});

  @override
  State<SchoolHomePage> createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  final _programsKey = GlobalKey();
  int _selectedNav = 0;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _AppColors.navy,
        ),
      );
  }

  void _scrollToPrograms() {
    Scrollable.ensureVisible(
      _programsKey.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 1050;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _TopBar(
                  isCompact: isCompact,
                  selectedIndex: _selectedNav,
                  onSelected: (index) {
                    setState(() => _selectedNav = index);
                    if (index == 1) {
                      _scrollToPrograms();
                    }
                    if (index == 2) {
                      _showMessage('Admissions open for 2025–26.');
                    }
                    if (index == 3) {
                      _showMessage('Our story began in 1987.');
                    }
                  },
                  onApply: () => _showMessage(
                    'Thanks for your interest! Our admissions team will be in touch.',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _HeroSection(
                  isCompact: isCompact,
                  onExplore: _scrollToPrograms,
                  onVisit: () => _showMessage(
                    'Visit requests are welcome Monday–Friday, 9:00 AM–3:00 PM.',
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _TrustStrip(isCompact: isCompact)),
              SliverToBoxAdapter(
                child: Container(
                  key: _programsKey,
                  child: _ProgramsSection(isCompact: isCompact),
                ),
              ),
              SliverToBoxAdapter(child: _StorySection(isCompact: isCompact)),
              SliverToBoxAdapter(
                child: _NewsSection(
                  isCompact: isCompact,
                  onViewAll: () => _showMessage('More stories coming soon.'),
                ),
              ),
              SliverToBoxAdapter(
                child: _Footer(
                  isCompact: isCompact,
                  onContact: () => _showMessage(
                    'Call us at (555) 014-1987 or email hello@oakridge.edu.',
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isCompact,
    required this.selectedIndex,
    required this.onSelected,
    required this.onApply,
  });

  final bool isCompact;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.cream,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 64,
        vertical: 22,
      ),
      child: Row(
        children: [
          const _Brand(),
          const Spacer(),
          if (!isCompact) ...[
            _NavItem(
              label: 'Our school',
              selected: selectedIndex == 0,
              onTap: () => onSelected(0),
            ),
            _NavItem(
              label: 'Learning',
              selected: selectedIndex == 1,
              onTap: () => onSelected(1),
            ),
            _NavItem(
              label: 'Admissions',
              selected: selectedIndex == 2,
              onTap: () => onSelected(2),
            ),
            _NavItem(
              label: 'About us',
              selected: selectedIndex == 3,
              onTap: () => onSelected(3),
            ),
            const SizedBox(width: 18),
            FilledButton(
              onPressed: onApply,
              style: FilledButton.styleFrom(
                backgroundColor: _AppColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
              ),
              child: const Text('Apply now'),
            ),
          ] else
            IconButton(
              onPressed: () => onSelected(1),
              icon: const Icon(Icons.menu_rounded, color: _AppColors.navy),
              tooltip: 'Open menu',
            ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: _AppColors.navy,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: _AppColors.gold,
            size: 24,
          ),
        ),
        const SizedBox(width: 11),
        const Text(
          'oakridge',
          style: TextStyle(
            color: _AppColors.navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: selected ? _AppColors.navy : _AppColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.isCompact,
    required this.onExplore,
    required this.onVisit,
  });

  final bool isCompact;
  final VoidCallback onExplore;
  final VoidCallback onVisit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        isCompact ? 24 : 80,
        42,
        isCompact ? 24 : 80,
        72,
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCopy(onExplore: onExplore, onVisit: onVisit),
                const SizedBox(height: 46),
                const _HeroIllustration(),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 11,
                  child: _HeroCopy(onExplore: onExplore, onVisit: onVisit),
                ),
                const SizedBox(width: 45),
                const Expanded(flex: 9, child: _HeroIllustration()),
              ],
            ),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _AppColors.gold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'A place to grow, discover and belong',
            style: TextStyle(
              color: _AppColors.navy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Curious minds.\nKind hearts.',
          style: TextStyle(
            color: _AppColors.navy,
            fontSize: 58,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -2.2,
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480),
          child: Text(
            'Oakridge Academy is a joyful, ambitious school where every student is known, challenged and inspired to make a difference.',
            style: TextStyle(
              color: _AppColors.muted,
              fontSize: 17,
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: 31),
        Wrap(
          spacing: 13,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Explore learning'),
              style: FilledButton.styleFrom(
                backgroundColor: _AppColors.coral,
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
                foregroundColor: _AppColors.navy,
                side: const BorderSide(color: _AppColors.navy),
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

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _AppColors.sky,
              borderRadius: BorderRadius.circular(36),
            ),
          ),
          Positioned(
            top: 34,
            right: 44,
            child: Icon(
              Icons.wb_sunny_rounded,
              color: _AppColors.gold,
              size: 58,
            ),
          ),
          Positioned(
            bottom: 38,
            left: 35,
            child: Icon(
              Icons.local_florist_rounded,
              color: _AppColors.coral,
              size: 62,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 35,
            right: 35,
            child: Container(
              height: 53,
              decoration: BoxDecoration(
                color: _AppColors.navy,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
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
                      color: _AppColors.blue,
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
                    child: Padding(
                      padding: EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MiniIcon(
                            icon: Icons.palette_rounded,
                            color: _AppColors.coral,
                          ),
                          _MiniIcon(
                            icon: Icons.science_rounded,
                            color: _AppColors.gold,
                          ),
                          _MiniIcon(
                            icon: Icons.groups_rounded,
                            color: _AppColors.blue,
                          ),
                        ],
                      ),
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
  const _TrustStrip({required this.isCompact});
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 24 : 80,
        vertical: 24,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 22,
        children: const [
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
              color: _AppColors.gold,
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
  const _ProgramsSection({required this.isCompact});
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 24 : 80,
        76,
        isCompact ? 24 : 80,
        72,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            eyebrow: 'THE OAKRIDGE JOURNEY',
            title: 'Learning that feels\nlike an adventure.',
            description: 'From their first steps into school to their final year, students build the confidence and curiosity to shape their own future.',
          ),
          const SizedBox(height: 38),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: const [
              _ProgramCard(
                icon: Icons.park_rounded,
                color: _AppColors.coral,
                age: 'AGES 3–6',
                title: 'Early years',
                text: 'Wonder starts here. Playful, purposeful learning builds a strong foundation.',
              ),
              _ProgramCard(
                icon: Icons.explore_rounded,
                color: _AppColors.blue,
                age: 'AGES 7–11',
                title: 'Primary school',
                text: 'Big questions, bright ideas and the courage to try something new every day.',
              ),
              _ProgramCard(
                icon: Icons.rocket_launch_rounded,
                color: _AppColors.gold,
                age: 'AGES 12–18',
                title: 'Senior school',
                text: 'Independent thinkers prepare to make their mark on the wider world.',
              ),
            ],
          ),
        ],
      ),
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
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 18,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: _AppColors.coral,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              title,
              style: const TextStyle(
                color: _AppColors.navy,
                fontSize: 38,
                height: 1.13,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.1,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 330,
          child: Text(
            description,
            style: const TextStyle(
              color: _AppColors.muted,
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ),
      ],
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
    return SizedBox(
      width: 305,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 27),
              ),
              const SizedBox(height: 21),
              Text(
                age,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: _AppColors.navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 11),
              Text(
                text,
                style: const TextStyle(
                  color: _AppColors.muted,
                  height: 1.45,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Discover more',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Icon(Icons.arrow_forward_rounded, color: color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.isCompact});
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.sky,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 24 : 80,
        vertical: 70,
      ),
      child: isCompact
          ? Column(
              children: const [_StoryArt(), SizedBox(height: 35), _StoryCopy()],
            )
          : Row(
              children: const [
                Expanded(child: _StoryArt()),
                SizedBox(width: 78),
                Expanded(child: _StoryCopy()),
              ],
            ),
    );
  }
}

class _StoryArt extends StatelessWidget {
  const _StoryArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      decoration: BoxDecoration(
        color: _AppColors.gold.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 22,
            right: 26,
            child: Icon(Icons.star_rounded, color: _AppColors.coral, size: 30),
          ),
          Positioned(
            bottom: 26,
            left: 30,
            child: Icon(
              Icons.favorite_rounded,
              color: _AppColors.coral,
              size: 29,
            ),
          ),
          Container(
            width: 175,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(90),
              border: Border.all(color: _AppColors.navy, width: 4),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups_rounded, color: _AppColors.navy, size: 74),
                SizedBox(height: 14),
                Text(
                  'TOGETHER',
                  style: TextStyle(
                    color: _AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
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

class _StoryCopy extends StatelessWidget {
  const _StoryCopy();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MORE THAN A SCHOOL',
          style: TextStyle(
            color: _AppColors.coral,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 13),
        Text(
          'A community with\nroom for everyone.',
          style: TextStyle(
            color: _AppColors.navy,
            fontSize: 37,
            height: 1.13,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.1,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'We believe the best learning happens when children feel safe to be themselves. Our teachers notice the little things, celebrate progress and help every student find their spark.',
          style: TextStyle(color: _AppColors.muted, fontSize: 15, height: 1.6),
        ),
        SizedBox(height: 22),
        Row(
          children: [
            Icon(Icons.check_circle_rounded, color: _AppColors.blue, size: 19),
            SizedBox(width: 10),
            Text(
              'A genuinely personal approach',
              style: TextStyle(
                color: _AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.check_circle_rounded, color: _AppColors.blue, size: 19),
            SizedBox(width: 10),
            Text(
              'A welcoming, inclusive community',
              style: TextStyle(
                color: _AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NewsSection extends StatelessWidget {
  const _NewsSection({required this.isCompact, required this.onViewAll});
  final bool isCompact;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 24 : 80,
        70,
        isCompact ? 24 : 80,
        74,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'From our community',
                style: TextStyle(
                  color: _AppColors.navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View all stories'),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: const [
              _NewsCard(
                date: 'OCT 14, 2025',
                title: 'Oakridge wins regional young artists award',
                icon: Icons.palette_rounded,
                color: _AppColors.coral,
              ),
              _NewsCard(
                date: 'SEP 29, 2025',
                title: 'Five ways we make reading a daily habit',
                icon: Icons.menu_book_rounded,
                color: _AppColors.blue,
              ),
            ],
          ),
        ],
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
                    color: _AppColors.navy,
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
  const _Footer({required this.isCompact, required this.onContact});
  final bool isCompact;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.navy,
      padding: EdgeInsets.fromLTRB(
        isCompact ? 24 : 80,
        45,
        isCompact ? 24 : 80,
        28,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'oakridge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Growing good humans since 1987.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (!isCompact)
                TextButton.icon(
                  onPressed: onContact,
                  icon: const Icon(
                    Icons.mail_outline_rounded,
                    color: _AppColors.gold,
                    size: 18,
                  ),
                  label: const Text(
                    'Get in touch',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 37),
          const Divider(color: Colors.white24),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '© 2025 Oakridge Academy  •  14 Willow Lane, Brookfield  •  (555) 014-1987',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

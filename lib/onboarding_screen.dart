import 'package:flutter/material.dart';
import 'product_page.dart';
import 'login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _slides = [
    const Slide(
      icon: Icons.recycling,
      title: 'REUSE MART',
      subtitle: '',
      backgroundColor: Colors.blue,
    ),
    const Slide(
      icon: Icons.lightbulb_outline,
      title: 'Konsep Kami',
      subtitle:
          'Wujudkan gaya hidup ramah lingkungan dengan membeli dan menjual barang bekas berkualitas. ReuseMart memudahkanmu memberi hidup kedua untuk barang yang tak lagi digunakan.',
      backgroundColor: Colors.blue,
    ),
    const Slide(
      icon: Icons.eco,
      title: 'Manfaat',
      subtitle: '',
      customContent: BenefitsContent(),
      backgroundColor: Colors.blue,
    ),
    const Slide(
      icon: Icons.phone_iphone,
      title: 'Fitur Unggulan',
      subtitle: '',
      customContent: FeaturesContent(),
      backgroundColor: Colors.blue,
    ),
    const Slide(
      icon: Icons.handshake,
      title: 'Mulai',
      subtitle: 'Berkontribusi untuk bumi yang lebih baik',
      showButton: true,
      backgroundColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical, // Scroll vertikal ke atas
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _slides,
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                'Lewati',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _slides.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        ),
      );
    }
    return indicators;
  }
}

class Slide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? customContent;
  final bool showButton;
  final MaterialColor backgroundColor;

  const Slide({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.customContent,
    this.showButton = false,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor[_currentShade],
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.white),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (customContent != null) ...[
              const SizedBox(height: 20),
              Expanded(child: customContent!),
            ],
            if (showButton) ...[
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: backgroundColor[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductPage()),
                  );
                },
                child: Text(
                  'LIHAT PRODUK',
                  style: TextStyle(
                    color: backgroundColor[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int get _currentShade {
    switch (title) {
      case 'REUSE MART':
        return 800;
      case 'Konsep Kami':
        return 700;
      case 'Manfaat':
        return 600;
      case 'Fitur Unggulan':
        return 500;
      case 'Mulai':
        return 400;
      default:
        return 500;
    }
  }
}

class BenefitsContent extends StatelessWidget {
  const BenefitsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBenefitItem('♻️ Mengurangi limbah'),
        _buildBenefitItem('💰 Menghemat biaya'),
        _buildBenefitItem('🌱 Ramah lingkungan'),
        _buildBenefitItem('🤝 Membangun relasi'),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FeaturesContent extends StatelessWidget {
  const FeaturesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureItem(Icons.search, 'Pencarian Barang'),
        _buildFeatureItem(Icons.currency_exchange, 'Tukar Barang'),
        _buildFeatureItem(Icons.assessment, 'Laporan Dampak'),
        _buildFeatureItem(Icons.forum, 'Forum Komunitas'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

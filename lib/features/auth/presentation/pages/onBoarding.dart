

import 'package:blockchain_based_national_election_user_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/intro.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<Widget> onboardingPages = [
    const OnboardingPage(
      title: 'Your Vote, Secured by Blockchain',
      description:
          'Every vote is encrypted and recorded on the Ethereum blockchain, ensuring it cannot be altered or deleted.',
      image: 'assets/images/i1.jpg',
    ),
    const OnboardingPage(
      title: 'Real-Time, Trusted Results',
      description:
          'Track votes in real-time with a public ledger—no hidden manipulations, just pure transparency.',
      image: 'assets/images/i2.jpg',
    ),
    const OnboardingPage(
      title: 'No Central Control, No Fraud',
      description:
          'Eliminate election fraud with decentralized voting—power to the people, not intermediaries.',
      image: 'assets/images/i3.jpg',
    ),
    const OnboardingPage(
      title: 'Vote Anywhere, Anytime',
      description:
          'From rural villages to cities, anyone with a smartphone can participate securely.',
      image: 'assets/images/i4.jpg',
    ),
    const OnboardingPage(
      title: 'One Citizen, One Verified Vote',
      description:
          'Biometric and blockchain ID checks ensure no duplicate votes—only fair elections.',
      image: 'assets/images/i5.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            children: onboardingPages,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (currentPage < onboardingPages.length - 1)
                  TextButton(
                    onPressed: () {
                      pageController.animateToPage(
                        onboardingPages.length - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text(
                      'SKIP',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                Expanded(child: Container()),
                Column(
                  children: [
                    SmoothPageIndicator(
                      controller: pageController,
                      count: onboardingPages.length,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Color.fromARGB(255, 119, 26, 185),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (currentPage != 0)
                      TextButton(
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text('BACK'),
                      ),
                    GradientButton(
                      text:
                          Text(currentPage == onboardingPages.length - 1
                              ? 'GET STARTED'
                              : 'NEXT'),
                      onPress: () {
                        if (currentPage < onboardingPages.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Intro()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 0, 0.3),
                Color.fromRGBO(0, 0, 0, 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

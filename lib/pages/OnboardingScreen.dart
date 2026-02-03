import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import 'Welcomepage.dart';


class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontal),
        child: Column(
          children: [
            const Spacer(),

            const Icon(Icons.school, size: 180, color: Colors.blueAccent),

            const SizedBox(height: 32),

            const Text(
              'Find Your\nLearning Match',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Connect with tutors who match your subject needs, academic level, and schedule.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey,
              fontSize: 20),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomePage()),
                    );
                  },
                  child: const Text('Skip'),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Onboarding2()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardPink,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontal),
        child: Column(
          children: [
            const Spacer(),

            const Icon(Icons.laptop_mac, size: 180, color: Colors.deepPurple),

            const SizedBox(height: 32),

            const Text(
              'Choose How You\nLearn',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              'Learn your way: join peer tutoring sessions online or meet offline.',
              textAlign: TextAlign.center,style: TextStyle(color: AppColors.textGrey,
                fontSize: 20),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Onboarding3()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}




class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardPurple,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontal),
        child: Column(
          children: [
            const Spacer(),

            const Icon(Icons.school_outlined,
                size: 180, color: Colors.white),

            const SizedBox(height: 32),

            const Text(
              'Grow, Track &\nAchieve',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Monitor your learning journey, earn badges, and celebrate progress.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                );
              },
              child: const Text('Get Started'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


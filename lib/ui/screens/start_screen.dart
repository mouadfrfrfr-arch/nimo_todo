import 'package:flutter/material.dart';
import 'package:nimo_todo/ui/app_shell.dart';
import 'package:nimo_todo/ui/widgets/premium_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Text('Let\'s start', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Plan your day, keep projects tidy, and finish tasks faster.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Center(
                child: PremiumButton(
                  label: 'Get Started',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AppShell()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Local-first • Encrypted • App lock',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

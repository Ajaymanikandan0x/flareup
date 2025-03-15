import 'package:flutter/material.dart';

class EventCardEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const EventCardEmptyState({
    super.key, 
    required this.message,
    required this.icon,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with a subtle animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    icon,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Message text
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            // Optional retry button
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
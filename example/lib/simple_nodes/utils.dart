import 'dart:math';

mixin SimpleUtils {
  int delay(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  // Generate number of children with 40% chance of 0, and the rest following a normal distribution between 0-8
  int generateNumberOfChildren() {
    final random = Random();

    // 40% chance of returning 0
    if (random.nextDouble() < 0.4) {
      return 0;
    }

    // For the remaining 60%, generate a number using normal distribution
    double mean = 4.0; // Center of the 0-8 range
    double stdDev = 1.5; // Adjust this to control the spread

    // Box-Muller transform for normal distribution
    double u1 = random.nextDouble();
    double u2 = random.nextDouble();
    double z0 = sqrt(-2.0 * log(u1)) * cos(2 * pi * u2);

    int result = (z0 * stdDev + mean).round();

    // Ensure the result is between 0 and 8
    return result.clamp(0, 8);
  }
}

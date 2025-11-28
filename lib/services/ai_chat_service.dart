import 'app_state.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AIChatService {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  int _conversationCount = 0;

  void addUserMessage(String text) {
    _messages.add(
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    );
    _conversationCount++;
  }

  void addBotMessage(String text) {
    _messages.add(
      ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _getRandomEmoji() {
    final emojis = ['😊', '✨', '🌟', '💫', '🎯', '🔥', '💪', '🌈'];
    return emojis[DateTime.now().millisecond % emojis.length];
  }

  String generateResponse(String userMessage, AppState appState) {
    final lowerMessage = userMessage.toLowerCase();

    // Greeting detection
    if (lowerMessage.contains('hey') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hello') ||
        lowerMessage.contains('merhaba') ||
        lowerMessage.contains('selam')) {
      if (_conversationCount == 1) {
        return '${_getGreeting()}! ${_getRandomEmoji()} I\'m your wellness assistant. How are you today? How can I help you?';
      }
      return '${_getGreeting()}! ${_getRandomEmoji()} How can I help you?';
    }

    // How are you
    if (lowerMessage.contains('how are you') ||
        lowerMessage.contains('nasılsın') ||
        lowerMessage.contains('naber')) {
      return 'I\'m doing great, thanks! ${_getRandomEmoji()} I\'m looking at your health data. How are you feeling today?';
    }

    // Thank you
    if (lowerMessage.contains('thanks') ||
        lowerMessage.contains('thank you') ||
        lowerMessage.contains('teşekkür') ||
        lowerMessage.contains('sağol')) {
      return 'You\'re welcome! ${_getRandomEmoji()} Feel free to ask anything else.';
    }

    // Goodbye
    if (lowerMessage.contains('bye') ||
        lowerMessage.contains('goodbye') ||
        lowerMessage.contains('görüşürüz') ||
        lowerMessage.contains('hoşça kal') ||
        lowerMessage.contains('güle güle')) {
      return 'See you! ${_getRandomEmoji()} Have a healthy day!';
    }

    // HRV related queries
    if (lowerMessage.contains('hrv') ||
        lowerMessage.contains('heart rate variability')) {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final hrvToday = appState.hrvData
          .where((d) => d.timestamp.isAfter(todayStart))
          .toList();

      if (hrvToday.isEmpty) {
        return 'I don\'t have HRV data for today yet. ${_getRandomEmoji()} HRV typically ranges from 20-100ms. Higher values generally indicate better recovery and stress resilience.';
      }

      final avgHRV =
          hrvToday.map((d) => d.value!).reduce((a, b) => a + b) /
          hrvToday.length;

      String assessment;
      String emoji;
      if (avgHRV > 60) {
        assessment = 'excellent';
        emoji = '🌟';
      } else if (avgHRV > 40) {
        assessment = 'good';
        emoji = '👍';
      } else {
        assessment = 'could be improved';
        emoji = '💪';
      }

      return 'Your average HRV today is ${avgHRV.toStringAsFixed(1)}ms, which is $assessment! $emoji HRV reflects your body\'s ability to adapt to stress. Regular exercise, good sleep, and stress management can help improve it.';
    }

    // Heart rate queries
    if (lowerMessage.contains('heart rate') || lowerMessage.contains('heart')) {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final hrToday = appState.heartRateData
          .where((d) => d.timestamp.isAfter(todayStart))
          .toList();

      if (hrToday.isEmpty) {
        return 'I don\'t have heart rate data for today. ${_getRandomEmoji()} A normal resting heart rate is typically 60-100 bpm.';
      }

      final avgHR =
          hrToday.map((d) => d.value!).reduce((a, b) => a + b) / hrToday.length;

      String status = (avgHR >= 60 && avgHR <= 100)
          ? 'within normal range'
          : 'slightly outside normal range';

      return 'Your average heart rate today is ${avgHR.toStringAsFixed(0)} bpm. ${_getRandomEmoji()} This is $status (normal range: 60-100 bpm).';
    }

    // Steps queries
    if (lowerMessage.contains('step') || lowerMessage.contains('walk')) {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final stepsToday = appState.stepsData
          .where((d) => d.timestamp.isAfter(todayStart))
          .toList();

      if (stepsToday.isEmpty) {
        return 'I don\'t have step data for today. ${_getRandomEmoji()} Aim for at least 10,000 steps per day for optimal health!';
      }

      final totalSteps = stepsToday
          .map((d) => d.value!)
          .reduce((a, b) => a + b)
          .toInt();

      String assessment;
      String emoji;
      if (totalSteps >= 10000) {
        assessment = 'Great job! You\'ve reached your daily goal!';
        emoji = '🎉';
      } else if (totalSteps >= 5000) {
        assessment = 'You\'re halfway there. Keep moving!';
        emoji = '💪';
      } else {
        assessment = 'Try to be more active today. Every step counts!';
        emoji = '🚶';
      }

      return 'You\'ve taken $totalSteps steps today. $emoji $assessment';
    }

    // Sleep queries
    if (lowerMessage.contains('sleep')) {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final sleepToday = appState.sleepData
          .where((d) => d.timestamp.isAfter(todayStart))
          .toList();

      if (sleepToday.isEmpty) {
        return 'I don\'t have sleep data for today. ${_getRandomEmoji()} Most adults need 7-9 hours of quality sleep per night.';
      }

      final totalSleep = sleepToday
          .map((d) => d.value!)
          .reduce((a, b) => a + b);

      String assessment;
      String emoji;
      if (totalSleep >= 7 && totalSleep <= 9) {
        assessment =
            'Perfect! You\'re getting the recommended amount of sleep.';
        emoji = '😴';
      } else if (totalSleep < 7) {
        assessment =
            'You might want to get more sleep. Aim for 7-9 hours for optimal health.';
        emoji = '😪';
      } else {
        assessment =
            'You\'re getting plenty of rest. Make sure the quality is good too.';
        emoji = '😊';
      }

      return 'You slept ${totalSleep.toStringAsFixed(1)} hours. $emoji $assessment';
    }

    // Mood queries
    if (lowerMessage.contains('mood') || lowerMessage.contains('feeling')) {
      if (appState.mentalHealthEntries.isEmpty) {
        return 'I don\'t have mood data yet. ${_getRandomEmoji()} Try tracking your mood to see patterns over time.';
      }

      final recentEntries = appState.mentalHealthEntries.take(7).toList();
      final avgMood =
          recentEntries.map((e) => e.mood).reduce((a, b) => a + b) /
          recentEntries.length;

      String assessment;
      String emoji;
      if (avgMood >= 4) {
        assessment =
            'You\'ve been feeling good lately. Keep up the positive energy!';
        emoji = '😊';
      } else if (avgMood >= 3) {
        assessment =
            'Your mood has been neutral. Consider activities that bring you joy.';
        emoji = '😐';
      } else {
        assessment =
            'I notice you\'ve been feeling down. Remember, it\'s okay to seek support when needed.';
        emoji = '🤗';
      }

      return 'Based on your recent mood entries, $assessment $emoji';
    }

    // Skin health queries
    if (lowerMessage.contains('skin')) {
      if (appState.skinHealthEntries.isEmpty) {
        return 'I don\'t have skin health data yet. ${_getRandomEmoji()} Start tracking to get personalized insights.';
      }

      final latest = appState.skinHealthEntries.first;
      String condition;
      String emoji;
      switch (latest.condition) {
        case 5:
          condition = 'excellent';
          emoji = '✨';
          break;
        case 4:
          condition = 'good';
          emoji = '👍';
          break;
        case 3:
          condition = 'fair';
          emoji = '😊';
          break;
        default:
          condition = 'needs attention';
          emoji = '💧';
      }

      return 'Your latest skin condition is $condition. $emoji Remember to stay hydrated and maintain a consistent skincare routine.';
    }

    // General wellbeing
    if (lowerMessage.contains('wellbeing') ||
        lowerMessage.contains('health') ||
        lowerMessage.contains('how am i') ||
        lowerMessage.contains('sağlık') ||
        lowerMessage.contains('nasılım')) {
      return 'Based on your data, I can help you understand your HRV, heart rate, steps, sleep, mood, and skin health. ${_getRandomEmoji()} What metric would you like to know about?';
    }

    // Trend analysis
    if (lowerMessage.contains('trend') ||
        lowerMessage.contains('pattern') ||
        lowerMessage.contains('kalıp') ||
        lowerMessage.contains('değişim')) {
      return 'I can analyze trends in your data. ${_getRandomEmoji()} Try asking about specific metrics like "How is my HRV trending?" or "Show my mood patterns".';
    }

    // Tips
    if (lowerMessage.contains('tip') ||
        lowerMessage.contains('advice') ||
        lowerMessage.contains('help') ||
        lowerMessage.contains('ipucu') ||
        lowerMessage.contains('tavsiye') ||
        lowerMessage.contains('öneri') ||
        lowerMessage.contains('ne yapmalı')) {
      return 'Here are some wellbeing tips: ${_getRandomEmoji()}\n\n'
          '• Aim for 7-9 hours of quality sleep\n'
          '• Get at least 10,000 steps daily\n'
          '• Practice stress management techniques\n'
          '• Stay hydrated and maintain a balanced diet\n'
          '• Track your mood to identify patterns\n'
          '• Regular exercise improves HRV over time';
    }

    // Casual conversation
    if (lowerMessage.contains('what are you doing') ||
        lowerMessage.contains('ne yapıyorsun') ||
        lowerMessage.contains('ne var ne yok')) {
      return 'I\'m analyzing your health data and ready to help! ${_getRandomEmoji()} How can I assist you?';
    }

    // Default response
    final responses = [
      'I can help you understand your wellbeing data. ${_getRandomEmoji()} Try asking about:\n\n• Your HRV or heart rate\n• Steps and activity levels\n• Sleep patterns\n• Mood trends\n• Skin health\n• General wellbeing tips',
      'How can I help you? ${_getRandomEmoji()} You can ask questions about your health data, sleep, mood, or skin health.',
      'Is there something you\'re curious about? ${_getRandomEmoji()} We can talk about your health metrics or get general wellness advice.',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }
}

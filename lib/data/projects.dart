import '../models/project.dart';

/// All projects shown on the portfolio (GitHub account: OmarAdel10).
///
/// Categories mirror tamalsen.dev's filter buckets (Web / Data Visualization /
/// All) broadened for this portfolio's actual repos: Mobile, Web, AI / Data,
/// and Tools.
final List<Project> mainProjects = [
  Project(
    name: 'CashierSystem',
    description:
        'A comprehensive C++ cashier management system with inventory tracking, sales reporting, and multi-user support.',
    language: 'C++',
    category: 'Tools',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/cashier_system',
    topics: ['cashier', 'management', 'inventory', 'sales', 'c++'],
    isFeatured: false,
  ),
  Project(
    name: 'BudgetWise',
    description:
        'Personal finance tracker with budget planning, expense categorization, and a visual analytics dashboard.',
    language: 'HTML/CSS/JS',
    category: 'Web',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/budget_wise',
    topics: ['finance', 'budget', 'tracker', 'dashboard', 'visualization'],
    isFeatured: false,
  ),
  Project(
    name: 'Voice Assistant',
    description:
        'Comprehensive voice assistant with cloud STT, LLM intent parsing, offline TTS, Arabic/English support, and a plugin architecture.',
    language: 'Python',
    category: 'AI / Data',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/voice-assistant',
    homepage: 'https://github.com/OmarAdel10/voice-assistant',
    topics: ['voice-assistant', 'stt', 'tts', 'llm', 'arabic', 'english', 'plugin-architecture'],
    isFeatured: true,
  ),
  Project(
    name: 'Voice Assistant App',
    description:
        'Flutter/Dart GUI client for the Voice Assistant with real-time audio visualization and settings management.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/voice_assistant_app',
    topics: ['flutter', 'dart', 'voice-assistant', 'gui', 'audio-visualization'],
    isFeatured: false,
  ),
  Project(
    name: 'Cashier Admin Key Gen',
    description:
        'Dart utility for generating admin keys for CashierSystem with secure encryption and validation.',
    language: 'Dart',
    category: 'Tools',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/cashier_admin_keygen',
    topics: ['security', 'encryption', 'key-generation', 'admin-tools'],
    isFeatured: false,
  ),
  Project(
    name: 'Obsidian Nexus',
    description:
        'Intelligence Bridge for Obsidian vault with AI agent development features, MIT licensed.',
    language: 'TypeScript',
    category: 'AI / Data',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/obsidian-nexus',
    topics: ['obsidian', 'ai', 'agents', 'vault', 'intelligence-bridge'],
    isFeatured: false,
  ),
];

final List<Project> additionalProjects = [
  Project(
    name: 'Islami',
    description: 'Islamic app with Quran, Hadith, prayer times, and azkar built with Dart/Flutter.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/islami',
    topics: ['islamic', 'quran', 'hadith', 'prayer-times', 'flutter'],
  ),
  Project(
    name: 'Evently',
    description: 'Event management iOS app built with Swift and SwiftUI.',
    language: 'Swift',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/evently',
    topics: ['ios', 'swift', 'swiftui', 'events', 'management'],
  ),
  Project(
    name: 'News App',
    description: 'News aggregator Flutter app with category filtering and offline reading.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/news',
    topics: ['news', 'flutter', 'aggregator', 'offline', 'categories'],
  ),
  Project(
    name: 'Explainable Digit Recognizer',
    description:
        'MNIST digit classifier with SHAP explainability and interactive visualization.',
    language: 'Python',
    category: 'AI / Data',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/Explainable-Digit-Recognizer',
    topics: ['machine-learning', 'mnist', 'explainable-ai', 'shap', 'visualization'],
  ),
  Project(
    name: 'Smoke Counter',
    description: 'Habit tracking app for smoking cessation with statistics and achievements.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/smoke_counter',
    topics: ['habit-tracking', 'health', 'flutter', 'statistics', 'achievements'],
  ),
];

/// Ordering for the project filter pills.
const List<String> projectCategories = ['All', 'Mobile', 'Web', 'AI / Data', 'Tools'];

/// The combined list used by the "All Projects" grid.
List<Project> get allProjects => [...mainProjects, ...additionalProjects];

/// The featured project shown as the single hero card (null-safe fallback).
Project? get featuredProject {
  for (final p in allProjects) {
    if (p.isFeatured) return p;
  }
  return allProjects.isEmpty ? null : allProjects.first;
}
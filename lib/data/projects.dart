import '../models/project.dart';

/// Projects shown on the portfolio (GitHub: OmarAdel10).
///
/// Categories mirror the filter pills: Mobile, Web, AI / Data, Tools. A
/// `logoUrl` points at a product logo shipped under `web/images/logos`;
/// projects without one fall back to the language monogram in the card.
final List<Project> mainProjects = [
  Project(
    name: 'Daftari · Cashier System',
    description:
        'Offline-first POS for Windows (Linux for development). Flutter UI paired with C# .NET background services, a Turso edge database behind Cloudflare Workers, and integrated payment gateways with automated invoice reconciliation and instant receipt printing.',
    language: 'Flutter · C#',
    category: 'Tools',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/cashier_system',
    topics: ['pos', 'flutter', 'dotnet', 'turso', 'cloudflare-workers', 'payments'],
    logoUrl: '/images/logos/cashier.png',
    isFeatured: true,
  ),
  Project(
    name: 'BudgetWise',
    description:
        'Multi-asset finance tracking app — custom accounts (credit, debit, Meeza, gold, cash), an inter-account InstaPay ledger, expense analytics, subscriptions, savings goals, SMS transaction scraping and offline speech-to-text expense logging.',
    language: 'Flutter',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/budget_wise',
    topics: ['finance', 'bloc', 'sqlite', 'offline-stt', 'analytics'],
    logoUrl: '/images/logos/budgetwise.png',
  ),
  Project(
    name: 'Voice Assistant',
    description:
        'Full-stack voice platform pairing a Flutter client with a Python speech backend — streaming STT transcription, intent/command parsing, TTS synthesis and offline fallback routines over WebSockets.',
    language: 'Python',
    category: 'AI / Data',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/voice-assistant',
    homepage: 'https://github.com/OmarAdel10/voice-assistant',
    topics: ['stt', 'tts', 'llm', 'websockets', 'python'],
  ),
  Project(
    name: 'Voice Assistant App',
    description:
        'Flutter/Dart GUI client for the Voice Assistant with real-time audio visualization, session history, and settings management.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/voice_assistant_app',
    topics: ['flutter', 'dart', 'audio-visualization', 'voice-assistant'],
  ),
  Project(
    name: 'Cashier Admin Key Gen',
    description:
        'Dart utility for generating and validating admin keys for the Cashier System with secure encryption.',
    language: 'Dart',
    category: 'Tools',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/cashier_admin_keygen',
    topics: ['security', 'encryption', 'key-generation', 'admin-tools'],
  ),
  Project(
    name: 'Obsidian Nexus',
    description:
        'Open-source Gemini CLI extension that bridges AI agents and Obsidian vaults — graph-aware markdown parsing, bidirectional wikilink resolution, and smart frontmatter generation.',
    language: 'TypeScript',
    category: 'AI / Data',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/obsidian-nexus',
    topics: ['obsidian', 'ai', 'agents', 'cli', 'markdown'],
  ),
];

final List<Project> additionalProjects = [
  Project(
    name: 'Islami',
    description: 'Islamic app with Quran, Hadith, prayer times, and azkar built with Flutter.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/islami',
    topics: ['quran', 'hadith', 'prayer-times', 'flutter'],
    logoUrl: '/images/logos/islami.png',
  ),
  Project(
    name: 'Evently',
    description: 'Event management app with SwiftUI — discover, RSVP, and manage events.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/evently',
    topics: ['ios', 'swiftui', 'events', 'management'],
    logoUrl: '/images/logos/evently.png',
  ),
  Project(
    name: 'News App',
    description: 'News aggregator Flutter app with category filtering and offline reading.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/news',
    topics: ['news', 'flutter', 'aggregator', 'offline-reading'],
    logoUrl: '/images/logos/news.png',
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
    topics: ['machine-learning', 'mnist', 'explainable-ai', 'shap'],
  ),
  Project(
    name: 'Smoke Counter',
    description: 'Habit tracking app for smoking cessation with statistics and achievements.',
    language: 'Dart',
    category: 'Mobile',
    stars: 0,
    forks: 0,
    url: 'https://github.com/OmarAdel10/smoke_counter',
    topics: ['habit-tracking', 'health', 'flutter', 'statistics'],
    logoUrl: '/images/logos/smoke.png',
  ),
];

/// Ordering for the project filter pills. `Web` is intentionally omitted: all
/// current projects are app-backend, mobile, or tooling, and an empty tab would
/// read as unfinished. Add a Web project back here when one exists.
const List<String> projectCategories = ['All', 'Mobile', 'AI / Data', 'Tools'];

/// The combined list used by the "All Projects" grid.
List<Project> get allProjects => [...mainProjects, ...additionalProjects];

/// The featured project shown as the single hero card (null-safe fallback).
Project? get featuredProject {
  for (final p in allProjects) {
    if (p.isFeatured) return p;
  }
  return allProjects.isEmpty ? null : allProjects.first;
}
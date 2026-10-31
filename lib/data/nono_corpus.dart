/* Knowledge corpus for the "Ask Nono" assistant.
 *
 * Single source of truth for Nono's retrieval-augmented answers. Every
 * document is a chunk-sized unit of Omar's published portfolio content,
 * tagged with its source section so answers can cite where they came from.
 *
 * Keep this in sync with the UI components by hand (manual sync model — see
 * the implementation plan). Do not parse components at runtime: Jaspr
 * component trees mix markup, styling, and logic, which makes extraction
 * fragile and source attribution unreliable.
 */

import '../constants/site.dart';

class NonoDocument {
  /// Stable identifier for the document (debugging / logging).
  final String id;

  /// Human-readable section title, shown in citations.
  final String title;

  /// The actual knowledge text — the chunk the retrieval layer searches.
  final String body;

  /// Section this content originated from (about, expertise, projects, …).
  final String sourceSection;

  /// HTML anchor for deep-linking to the source section.
  final String? sourceAnchor;

  /// Tags used to boost retrieval when query terms match.
  final List<String> topics;

  /// External link for further reading (GitHub repo, etc.).
  final String? url;

  /// When true, this document is sent with *every* request, regardless of
  /// what the visitor asked.
  ///
  /// The core documents carry Omar's identity and his contact channels. They
  /// ride along so Nono can still answer "hi", "who is he?" or "how do I get
  /// in touch?" — queries whose wording matches no specific document, and
  /// which would otherwise leave the model with an empty context.
  final bool core;

  NonoDocument({
    required this.id,
    required this.title,
    required this.body,
    required this.sourceSection,
    this.sourceAnchor,
    this.topics = const [],
    this.url,
    this.core = false,
  });
}

/// All documents in the corpus.
///
/// When Omar updates a section, update the matching document(s) here by hand.
final List<NonoDocument> nonoCorpus = <NonoDocument>[
  // ─── About ──────────────────────────────────────────────────────────────
  NonoDocument(
    id: 'about-bio',
    title: 'About — bio',
    sourceSection: 'about',
    sourceAnchor: '#about',
    topics: [
      'about',
      'bio',
      'workflow',
      'ai',
      'flutter',
      'dotnet',
      'python',
    ],
    body:
        "Most of my projects cross the seam between the app and the system behind it — an offline-first Flutter front end, .NET or Python services, a database at the edge, and payments that have to reconcile. The interesting problems live where those pieces disagree. "
        "I use AI daily in my workflow — Claude Code, Codex, Gemini CLI — as a force multiplier for the parts I've already thought through. Obsessed with the details that make an app feel right: micro-interactions, consistent spacing, animations that don't get in the way. The kind of polish you only notice when it's missing. "
        "Night person. Mornings are for other people. I procrastinate like it's a discipline, then learn an entire semester's worth of material in one night when the deadline hits — works every time. "
        "Mostly at my desk, studying, shipping, breaking things on purpose to understand them. But the friends I do have? We make it count when we hang out.",
  ),
  NonoDocument(
    id: 'about-facts',
    title: 'About — facts',
    sourceSection: 'about',
    sourceAnchor: '#about',
    topics: ['about', 'role', 'stack', 'currently'],
    core: true,
    body:
        "Role: Software Engineer. "
        "Stack: Flutter, .NET, Python, TypeScript. "
        "Currently: Sharpening the craft, one side project at a time.",
  ),

  // ─── Expertise ──────────────────────────────────────────────────────────
  NonoDocument(
    id: 'expertise-crossplatform',
    title: 'Expertise — Cross-Platform App Development',
    sourceSection: 'expertise',
    sourceAnchor: '#expertise',
    topics: ['expertise', 'flutter', 'mobile', 'offline-first', 'firebase', 'sqlite', 'stt'],
    body:
        "Offline-first Flutter apps for Android, iOS, Windows, and Linux — BLoC/HydratedBLOC state, Firebase, Shorebird updates, SQLite, and local speech recognition built into the flow.",
  ),
  NonoDocument(
    id: 'expertise-backend',
    title: 'Expertise — Backend, Cloud & Payments',
    sourceSection: 'expertise',
    sourceAnchor: '#expertise',
    topics: ['expertise', 'backend', 'cloud', 'payments', 'dotnet', 'turso', 'cloudflare-workers'],
    body:
        ".NET Core and Python services, Turso and Cloud Firestore databases, Cloudflare Workers gateways, and payment-terminal SDK integrations that reconcile invoices automatically.",
  ),
  NonoDocument(
    id: 'expertise-ai',
    title: 'Expertise — AI & Agentic Tooling',
    sourceSection: 'expertise',
    sourceAnchor: '#expertise',
    topics: ['expertise', 'ai', 'agents', 'deep-learning', 'stt', 'claude-code', 'codex', 'gemini'],
    body:
        "Deep learning and offline speech-to-text models, plus agent-driven development with Claude Code, Codex, and Gemini CLI workflows that ship faster without cutting corners.",
  ),

  // ─── Experience ─────────────────────────────────────────────────────────
  NonoDocument(
    id: 'experience-bsc',
    title: 'Education — BSc in Computer Science',
    sourceSection: 'experience',
    sourceAnchor: '#experience',
    topics: ['experience', 'education', 'computer-science', 'degree'],
    body:
        "BSc in Computer Science at New Mansoura University, Egypt (2023 – 2027). A computer science degree with a practical bend — from digital logic and data warehousing up to neural networks and cloud. Technologies: Computer Networks, Machine Learning, Deep Learning, Artificial Neural Networks, Cloud Computing, Data Warehousing, Digital Logic Design, Databases.",
  ),
  NonoDocument(
    id: 'experience-flutter-cert',
    title: 'Certification — Flutter & Dart Development',
    sourceSection: 'experience',
    sourceAnchor: '#experience',
    topics: ['experience', 'certification', 'flutter', 'dart'],
    body:
        "Flutter & Dart Development — Route IT Academy, Professional Training (Certification). Intensive training on building production-ready Flutter applications — Dart fundamentals, state management, API integration, and cross-platform deployment. Technologies: Flutter, Dart, State Management, REST.",
  ),
  NonoDocument(
    id: 'experience-clean-arch-cert',
    title: 'Certification — Clean Architecture & SOLID Principles',
    sourceSection: 'experience',
    sourceAnchor: '#experience',
    topics: ['experience', 'certification', 'clean-architecture', 'solid'],
    body:
        "Clean Architecture & SOLID Principles — Usama Elgendy, Instructor (Certification). Deep-dive into layered, testable application architecture — SOLID principles, dependency injection, and Clean Architecture patterns applied to real mobile codebases. Technologies: Clean Architecture, SOLID, DI, Testing.",
  ),

  // ─── Projects ───────────────────────────────────────────────────────────
  NonoDocument(
    id: 'project-daftari',
    title: 'Project — Daftari · Cashier System (featured)',
    sourceSection: 'projects',
    sourceAnchor: '#projects',
    topics: ['projects', 'pos', 'flutter', 'dotnet', 'turso', 'cloudflare-workers', 'payments', 'featured'],
    url: 'https://github.com/OmarAdel10/cashier_system',
    body:
        "Offline-first POS for Windows (Linux for development). Flutter UI paired with C# .NET background services, a Turso edge database behind Cloudflare Workers, and integrated payment gateways with automated invoice reconciliation and instant receipt printing.",
  ),
  NonoDocument(
    id: 'project-budgetwise',
    title: 'Project — BudgetWise',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'finance', 'flutter', 'bloc', 'sqlite', 'offline-stt', 'analytics', 'mobile'],
    url: 'https://github.com/OmarAdel10/budget_wise',
    body:
        "Multi-asset finance tracking app — custom accounts (credit, debit, Meeza, gold, cash), an inter-account InstaPay ledger, expense analytics, subscriptions, savings goals, SMS transaction scraping and offline speech-to-text expense logging.",
  ),
  NonoDocument(
    id: 'project-voice-assistant',
    title: 'Project — Voice Assistant',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'voice', 'stt', 'tts', 'llm', 'websockets', 'python', 'ai-data'],
    url: 'https://github.com/OmarAdel10/voice-assistant',
    body:
        "Full-stack voice platform pairing a Flutter client with a Python speech backend — streaming STT transcription, intent/command parsing, TTS synthesis and offline fallback routines over WebSockets.",
  ),
  NonoDocument(
    id: 'project-voice-assistant-app',
    title: 'Project — Voice Assistant App',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'flutter', 'dart', 'audio-visualization', 'voice-assistant', 'mobile'],
    url: 'https://github.com/OmarAdel10/voice_assistant_app',
    body:
        "Flutter/Dart GUI client for the Voice Assistant with real-time audio visualization, session history, and settings management.",
  ),
  NonoDocument(
    id: 'project-cashier-admin-keygen',
    title: 'Project — Cashier Admin Key Gen',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'security', 'encryption', 'key-generation', 'admin-tools', 'dart', 'tools'],
    url: 'https://github.com/OmarAdel10/cashier_admin_keygen',
    body:
        "Dart utility for generating and validating admin keys for the Cashier System with secure encryption.",
  ),
  NonoDocument(
    id: 'project-obsidian-nexus',
    title: 'Project — Obsidian Nexus',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'obsidian', 'ai', 'agents', 'cli', 'markdown', 'typescript', 'ai-data'],
    url: 'https://github.com/OmarAdel10/obsidian-nexus',
    body:
        "Open-source Gemini CLI extension that bridges AI agents and Obsidian vaults — graph-aware markdown parsing, bidirectional wikilink resolution, and smart frontmatter generation.",
  ),
  NonoDocument(
    id: 'project-islami',
    title: 'Project — Islami',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'quran', 'hadith', 'prayer-times', 'flutter', 'mobile'],
    url: 'https://github.com/OmarAdel10/islami',
    body:
        "Islamic app with Quran, Hadith, prayer times, and azkar built with Flutter.",
  ),
  NonoDocument(
    id: 'project-evently',
    title: 'Project — Evently',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'ios', 'swiftui', 'events', 'management', 'mobile'],
    url: 'https://github.com/OmarAdel10/evently',
    body:
        "Event management app with SwiftUI — discover, RSVP, and manage events.",
  ),
  NonoDocument(
    id: 'project-news-app',
    title: 'Project — News App',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'news', 'flutter', 'aggregator', 'offline-reading', 'mobile'],
    url: 'https://github.com/OmarAdel10/news',
    body:
        "News aggregator Flutter app with category filtering and offline reading.",
  ),
  NonoDocument(
    id: 'project-explainable-digit-recognizer',
    title: 'Project — Explainable Digit Recognizer',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'machine-learning', 'mnist', 'explainable-ai', 'shap', 'python', 'ai-data'],
    url: 'https://github.com/OmarAdel10/Explainable-Digit-Recognizer',
    body:
        "MNIST digit classifier with SHAP explainability and interactive visualization.",
  ),
  NonoDocument(
    id: 'project-smoke-counter',
    title: 'Project — Smoke Counter',
    sourceSection: 'projects',
    sourceAnchor: '#projects-work',
    topics: ['projects', 'habit-tracking', 'health', 'flutter', 'statistics', 'mobile'],
    url: 'https://github.com/OmarAdel10/smoke_counter',
    body:
        "Habit tracking app for smoking cessation with statistics and achievements.",
  ),

  // ─── Contact ────────────────────────────────────────────────────────────
  NonoDocument(
    id: 'contact-channels',
    title: 'Contact — channels',
    sourceSection: 'contact',
    sourceAnchor: '#contact',
    topics: ['contact', 'email', 'github', 'linkedin', 'whatsapp', 'phone', 'available-for-work'],
    core: true,
    body:
        "Available for work. Send an email, or reach out on whichever channel suits you — I read every message. "
        "GitHub: github.com/OmarAdel10. "
        "LinkedIn: linkedin.com/in/omaradel10. "
        "WhatsApp: wa.me/201552210048. "
        "Phone: +20 155 221 0048. "
        "Email: omaradel1.dev@gmail.com.",
  ),

  // ─── Testimonials ───────────────────────────────────────────────────────
  NonoDocument(
    id: 'testimonials-principles',
    title: 'How I work — principles',
    sourceSection: 'testimonials',
    sourceAnchor: '#testimonials',
    topics: ['testimonials', 'principles', 'work-style', 'communication'],
    body:
        "Own the outcome: I treat every project like my own product — from architecture trade-offs down to the last pixel and the final deployment. "
        "Simple over clever: I reach for boring, reliable technology and clean boundaries over cleverness. Simple systems are the ones that actually ship and scale. "
        "A teammate, not a vendor: Clear updates, early risk calls, and decisions you can follow. I believe honest communication is half the craft.",
  ),

  // ─── Hero ───────────────────────────────────────────────────────────────
  NonoDocument(
    id: 'hero-stack',
    title: 'Hero — role & stack',
    sourceSection: 'hero',
    sourceAnchor: '#top',
    topics: ['hero', 'role', 'stack', 'software-engineer', 'flutter', 'dotnet', 'ai'],
    core: true,
    body:
        "Omar Adel — Software Engineer. Cross-platform apps, the backend and cloud behind them, and the AI tooling that speeds it up. Stack: Flutter, .NET, AI, mobile, web, desktop.",
  ),

  // ─── SEO / Person ───────────────────────────────────────────────────────
  NonoDocument(
    id: 'seo-person',
    title: 'Omar Adel — Software Engineer (profile)',
    sourceSection: 'profile',
    sourceAnchor: '#top',
    topics: ['profile', 'software-engineer', 'omar-adel', 'about'],
    url: productionUrl,
    body:
        "Omar Adel is a Software Engineer building cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling. Available for work via email, GitHub, LinkedIn, WhatsApp, and phone.",
  ),
];

/// Retrieval-friendly view: every document flattened into searchable text
/// keyed by its id, so the retrieval layer can score without touching the UI.
final Map<String, String> nonoCorpusById = {
  for (final doc in nonoCorpus) doc.id: doc.body,
};

/// The documents that are always included in the context sent to the model.
///
/// Order is the corpus order: identity first, then contact channels, then the
/// hero line. Together they cover "who is Omar", "what does he build" and
/// "how do I reach him" without any keyword match.
final List<NonoDocument> nonoCoreDocuments = <NonoDocument>[
  for (final doc in nonoCorpus)
    if (doc.core) doc,
];

# Anchor iOS - Implementation Guide

## Table of Contents
1. [Project Overview](#project-overview)
2. [Current Implementation Status](#current-implementation-status)
3. [Missing Core Components](#missing-core-components)
4. [Implementation Priorities](#implementation-priorities)
5. [Detailed Implementation Tasks](#detailed-implementation-tasks)
6. [Technical Architecture](#technical-architecture)
7. [API & Backend Requirements](#api--backend-requirements)
8. [Testing Strategy](#testing-strategy)

---

## Project Overview

**Anchor** is a recovery support iOS app designed to help users maintain streaks, manage urges, and access AI coaching during vulnerable moments. The app features emergency support via a panic button, app blocking capabilities, and pattern analysis.

### Key Features
- 7-screen onboarding flow with permissions
- Daily streak tracking with urge logging
- AI coach with message limits (3/day free, unlimited in panic mode)
- App blocking via iOS ScreenTime APIs
- Emergency panic button with breathing exercises
- Pattern detection and analytics
- Privacy-first design with discreet UI

---

## Current Implementation Status

### ✅ Fully Implemented (Production Ready)

#### UI & Navigation
- [x] Complete 7-screen onboarding flow
- [x] Home dashboard with streak display
- [x] Urge logging with trigger selection
- [x] Settings screen with basic options
- [x] Panic button floating UI
- [x] Deep linking support (`anchor://` scheme)
- [x] Navigation architecture with NavigationStack

#### Design System
- [x] Color system (emerald primary, coral alert)
- [x] Typography scale (SF Pro, SF Mono)
- [x] Spacing system (4pt grid)
- [x] Reusable components (GlassCard, QuickActionCard)
- [x] Design tokens and extensions

#### Architecture
- [x] Feature-based folder structure
- [x] MVVM pattern with ViewModels
- [x] Protocol-oriented service layer
- [x] Dependency injection via ServiceContainer
- [x] Repository pattern for data access

#### Data Models
- [x] Streak tracking model
- [x] UrgeLog model with triggers
- [x] Pattern detection models
- [x] AIMessage conversation models

#### State Management
- [x] OnboardingState with @AppStorage persistence
- [x] ServiceContainer as EnvironmentObject
- [x] DeeplinkHandler for URL schemes

### 🚧 Partially Implemented (Needs Work)

#### AI Coach
- [x] UI complete (chat interface, message bubbles)
- [x] Service protocol defined
- [x] Rate limiting logic (3/day, unlimited in panic)
- [ ] **Missing**: DeepSeek API integration (currently stubbed)
- [ ] **Missing**: Real message persistence
- [ ] **Missing**: Conversation history sync

#### App Blocking
- [x] UI complete (app selection, duration picker)
- [x] Service protocol defined
- [ ] **Missing**: FamilyControls framework integration
- [ ] **Missing**: DeviceActivity monitoring extension
- [ ] **Missing**: Shield configuration extension
- [ ] **Missing**: Actual app blocking logic

#### Notifications
- [x] Service implemented with UNUserNotificationCenter
- [x] Permission request flow
- [ ] **Missing**: Backend scheduling (risk-time alerts)
- [ ] **Missing**: Milestone celebration triggers
- [ ] **Missing**: Daily check-in reminders

#### Analytics & Patterns
- [x] View models ready
- [x] Calendar UI structure
- [ ] **Missing**: Pattern detection algorithms
- [ ] **Missing**: Data visualization components
- [ ] **Missing**: Time-based analysis (high-risk hours)

#### Panic Button
- [x] Basic panic flow UI
- [x] Breathing exercise screen
- [x] Action selection grid
- [ ] **Missing**: Emergency blocking integration
- [ ] **Missing**: Physical challenge implementations
- [ ] **Missing**: Automatic urge logging in background

### ❌ Not Yet Implemented (Critical Gaps)

#### Backend & Data
- [ ] Supabase integration (authentication, data sync)
- [ ] Real data persistence (currently in-memory stubs)
- [ ] Cloud sync for conversations and logs
- [ ] End-to-end encryption for sensitive data
- [ ] Account creation and authentication

#### Premium Features
- [ ] StoreKit 2 integration
- [ ] Subscription management (free/premium/trial)
- [ ] Trial period handling (7-day free)
- [ ] Payment processing
- [ ] Subscription status sync

#### iOS Platform Extensions
- [ ] DeviceActivity monitoring extension
- [ ] Shield configuration extension
- [ ] Shortcuts app integration (triple back-tap)
- [ ] Background refresh capabilities
- [ ] WidgetKit extension (optional)

#### Missing Functionality
- [ ] Export data feature
- [ ] Delete account functionality
- [ ] Push notification backend
- [ ] Pattern detection ML/algorithms
- [ ] Calendar date navigation
- [ ] Daily insight generation (AI-powered)
- [ ] Physical challenges UI & logic

---

## Missing Core Components

### 1. **Backend Integration** (CRITICAL)

#### Supabase Client Implementation
**Location**: `/App/Core/Networking/SupabaseClient.swift`

**Current State**: Protocol defined, stub implementation

**Required**:
```swift
class SupabaseClient: SupabaseClientProtocol {
    // TODO: Implement actual Supabase SDK integration
    // - User authentication (email/password, OAuth)
    // - Session management with refresh tokens
    // - Encrypted conversation storage
    // - Urge log and streak sync
    // - Pattern data persistence
    // - Account deletion endpoint
}
```

**Dependencies**:
- Supabase Swift SDK: `https://github.com/supabase/supabase-swift`
- Database schema (Postgres tables)
- Row-level security policies
- API endpoints for sync

**Priority**: **P0 (Blocker)**

---

### 2. **AI Coach API Integration** (CRITICAL)

#### DeepSeek API Client
**Location**: `/App/Core/Networking/DeepSeekClient.swift`

**Current State**: Protocol defined, returns mock responses

**Required**:
```swift
class DeepSeekClient: DeepSeekClientProtocol {
    // TODO: Implement DeepSeek API v3 integration
    // - API authentication with key
    // - Chat completion requests
    // - Streaming response support
    // - Rate limit handling (429 errors)
    // - Token usage tracking
    // - Context window management (4K tokens)
}
```

**API Details**:
- Endpoint: `https://api.deepseek.com/v1/chat/completions`
- Model: `deepseek-chat`
- System prompt: Recovery-focused, non-judgmental coaching
- Max tokens: 4096 per request

**Configuration Needed**:
- API key storage (Keychain)
- Environment variables for dev/prod
- Error handling for network failures
- Retry logic with exponential backoff

**Priority**: **P0 (Blocker)**

---

### 3. **iOS App Blocking Extensions** (CRITICAL)

#### DeviceActivity Monitoring Extension
**Location**: `/Extensions/DeviceActivity/`

**Current State**: **Does not exist**

**Required**:
1. **Create Target**:
   - Xcode → File → New → Target → Device Activity Monitor Extension
   - Bundle ID: `com.anchor.ios.DeviceActivityMonitor`

2. **Implement Callbacks**:
```swift
class DeviceActivityMonitor: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        // Called when block starts
        // Show shield on blocked apps
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        // Called when block ends
        // Remove shield, restore access
    }
}
```

3. **Configure Schedules**:
   - Create `DeviceActivitySchedule` for block durations
   - Monitor app usage during blocks
   - Trigger shield when apps launched

**Priority**: **P0 (Blocker)**

---

#### Shield Configuration Extension
**Location**: `/Extensions/ShieldConfiguration/`

**Current State**: **Does not exist**

**Required**:
1. **Create Target**:
   - Xcode → File → New → Target → Shield Configuration Extension
   - Bundle ID: `com.anchor.ios.ShieldConfiguration`

2. **Implement Custom Shield**:
```swift
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterialDark,
            backgroundColor: Color(hex: "#0A0E14"),
            icon: .init(systemName: "lock.shield"),
            title: .init(text: "Blocked by Anchor", color: .white),
            subtitle: .init(text: "This app is currently blocked. Open Anchor to manage.", color: .gray),
            primaryButtonLabel: .init(text: "Open Anchor", color: .emerald),
            primaryButtonBackgroundColor: Color(hex: "#10B981")
        )
    }
}
```

3. **Deep Link Integration**:
   - Primary button opens `anchor://manage-blocks`
   - Display remaining time until block expires
   - Emergency unlock flow (journal prompt + cooldown)

**Priority**: **P0 (Blocker)**

---

#### FamilyControls Integration
**Location**: `/App/Core/Services/BlockingService.swift`

**Current State**: Stub implementation

**Required**:
```swift
class BlockingService: BlockingServiceProtocol {
    private let center = AuthorizationCenter.shared

    func blockApps(appIdentifiers: [String], duration: TimeInterval) -> Result<Void, BlockingError> {
        // 1. Check authorization status
        guard center.authorizationStatus == .approved else {
            return .failure(.permissionDenied)
        }

        // 2. Create ApplicationTokens from identifiers
        let tokens = convertToTokens(appIdentifiers)

        // 3. Create DeviceActivitySchedule
        let schedule = createSchedule(duration: duration)

        // 4. Create ManagedSettingsStore
        let store = ManagedSettingsStore()
        store.shield.applications = tokens

        // 5. Start monitoring
        let center = DeviceActivityCenter()
        try? center.startMonitoring(.blockSession, during: schedule)

        return .success(())
    }
}
```

**Entitlements Required**:
- `com.apple.developer.family-controls`
- Family Controls capability in Xcode

**Priority**: **P0 (Blocker)**

---

### 4. **Data Persistence Layer** (HIGH)

#### Current Issue
All repositories use in-memory storage. Data is lost on app restart.

**Affected Files**:
- `/App/Core/Persistence/Repositories.swift`

**Required Implementation Options**:

**Option A: SwiftData** (Recommended)
```swift
import SwiftData

@Model
class StreakEntity {
    var id: String
    var currentStreak: Int
    var totalCleanDays: Int
    var lastUpdated: Date

    init(id: String, currentStreak: Int, totalCleanDays: Int, lastUpdated: Date) {
        self.id = id
        self.currentStreak = currentStreak
        self.totalCleanDays = totalCleanDays
        self.lastUpdated = lastUpdated
    }
}

class StreakRepository: StreakRepositoryProtocol {
    private let modelContext: ModelContext

    func saveStreak(_ streak: Streak) -> Result<Void, Error> {
        let entity = StreakEntity(...)
        modelContext.insert(entity)
        try? modelContext.save()
        return .success(())
    }
}
```

**Option B: Core Data**
- Create `.xcdatamodeld` schema
- Entities: StreakEntity, UrgeLogEntity, PatternEntity, ConversationEntity
- Migrations for schema changes

**Option C: Realm**
- Third-party dependency
- Good sync capabilities with Realm Cloud
- Consider if Supabase sync is complex

**Recommendation**: **SwiftData** (native, modern, easy CloudKit sync)

**Priority**: **P0 (Blocker)**

---

### 5. **Subscription & Payments** (HIGH)

#### StoreKit 2 Integration
**Location**: `/App/Core/Services/SubscriptionManager.swift`

**Current State**: Stub returning `.free` status

**Required**:
```swift
import StoreKit

class SubscriptionManager: ObservableObject {
    @Published var status: SubscriptionStatus = .free

    private let productIDs = [
        "com.anchor.premium.monthly",
        "com.anchor.premium.yearly"
    ]

    func loadProducts() async throws -> [Product] {
        return try await Product.products(for: productIDs)
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return transaction

        case .userCancelled, .pending:
            return nil

        @unknown default:
            return nil
        }
    }

    func startTrial() async -> Result<Void, Error> {
        // Implement 7-day free trial logic
        // Trial product: "com.anchor.trial.7day"
    }

    func checkSubscriptionStatus() async {
        // Check for active entitlements
        for await result in Transaction.currentEntitlements {
            let transaction = try? checkVerified(result)
            // Update status based on active transactions
        }
    }
}
```

**App Store Configuration**:
1. Create in-app purchase products:
   - Monthly: `$9.99/month` (after trial)
   - Yearly: `$79.99/year` (save 33%)
   - Trial: `7 days free`

2. Configure subscription groups
3. Add promotional offers
4. Set up StoreKit configuration file for testing

**Priority**: **P0 (Blocker for revenue)**

---

### 6. **Pattern Detection & Analytics** (MEDIUM)

#### Pattern Detection Algorithms
**Location**: `/App/Features/Analytics/AnalyticsViewModel.swift`

**Current State**: UI ready, no detection logic

**Required Algorithms**:

1. **Time-of-Day Pattern Detection**:
```swift
func detectTimePatterns(logs: [UrgeLog]) -> [Pattern] {
    // Group urges by hour of day
    // Calculate frequency distribution
    // Identify hours with >2 standard deviations above mean
    // Return high-risk time windows
}
```

2. **Day-of-Week Patterns**:
```swift
func detectDayPatterns(logs: [UrgeLog]) -> [Pattern] {
    // Group by day of week (Monday = 1, Sunday = 7)
    // Calculate relapse rates per day
    // Identify statistically significant days
}
```

3. **Trigger Correlation**:
```swift
func detectTriggerCorrelations(logs: [UrgeLog]) -> [Pattern] {
    // Find frequently co-occurring triggers
    // Example: "Stress" + "Late Night" = higher relapse rate
    // Use Apriori algorithm or similar
}
```

4. **Streak Risk Prediction**:
```swift
func predictStreakRisk(currentStreak: Int, patterns: [Pattern]) -> Double {
    // ML model (Core ML) or heuristic
    // Input: current streak day, time, recent patterns
    // Output: 0-1 risk score for relapse today
}
```

**Data Visualization**:
- Heatmap for time-of-day (24-hour grid)
- Bar chart for day-of-week frequencies
- Chord diagram for trigger correlations
- Line chart for streak history

**Priority**: **P1 (Nice to have for v1.0)**

---

### 7. **Shortcuts Integration** (MEDIUM)

#### Triple Back-Tap Panic Activation
**Location**: System Settings + Deep Link Handler

**Current State**: UI mentions it, not implemented

**Required**:
1. **Create Shortcut**:
   - User manually creates in Shortcuts app
   - Action: Open URL → `anchor://panic`
   - Trigger: Triple back-tap (Accessibility → Touch)

2. **Deep Link Handling** (already implemented):
```swift
// In Anchor_iOSApp.swift
.onOpenURL { url in
    deeplinkHandler.handle(url)
}
```

3. **Setup Guide Screen** (exists):
   - Show step-by-step tutorial
   - Screenshots of Shortcuts app
   - Link directly to Shortcuts app if possible

**App Intents** (iOS 16+):
```swift
import AppIntents

struct TriggerPanicIntent: AppIntent {
    static var title: LocalizedStringResource = "Trigger Panic Button"

    func perform() async throws -> some IntentResult {
        // Directly trigger panic flow without deep link
        NotificationCenter.default.post(name: .triggerPanic, object: nil)
        return .result()
    }
}
```

**Priority**: **P1 (User-requested feature)**

---

### 8. **Push Notifications Backend** (MEDIUM)

#### Server-Side Notification Scheduling
**Location**: Supabase Edge Functions + iOS

**Current State**: Local notifications only

**Required**:
1. **Register Device Token**:
```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    // Send to Supabase backend
    await supabaseClient.registerDevice(token: token)
}
```

2. **Backend Scheduling** (Supabase Edge Function):
```typescript
// Schedule daily risk-time alerts
Deno.serve(async (req) => {
  const { userId, riskTimes } = await req.json()

  // For each risk time, schedule push notification
  for (const time of riskTimes) {
    await schedulePushNotification({
      userId,
      scheduledTime: time,
      title: "Check-in time",
      body: "How are you feeling?",
      data: { type: "risk_check_in" }
    })
  }
})
```

3. **Handle Notification Taps**:
```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) {
    let userInfo = response.notification.request.content.userInfo

    if userInfo["type"] as? String == "risk_check_in" {
        // Navigate to urge logging screen
        deeplinkHandler.navigate(to: .logUrge)
    }
}
```

**Priority**: **P2 (Enhancement)**

---

### 9. **Account Management** (MEDIUM)

#### Export Data Functionality
**Location**: `/App/Features/Settings/SettingsViewModel.swift`

**Current State**: Button exists, no implementation

**Required**:
```swift
func exportUserData() async -> Result<URL, Error> {
    // 1. Gather all user data
    let streaks = streakRepository.getAllStreaks()
    let logs = urgeLogRepository.getAllLogs()
    let patterns = patternRepository.getAllPatterns()
    let conversations = // fetch from Supabase

    // 2. Create JSON export
    let exportData = UserDataExport(
        streaks: streaks,
        urgeLogs: logs,
        patterns: patterns,
        conversations: conversations,
        exportedAt: Date()
    )

    // 3. Write to temp file
    let json = try JSONEncoder().encode(exportData)
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("anchor_data_export.json")
    try json.write(to: fileURL)

    // 4. Present share sheet
    return .success(fileURL)
}
```

**GDPR Compliance**: Must include all user data, encrypted if sensitive

**Priority**: **P1 (Privacy requirement)**

---

#### Delete Account Functionality
**Location**: `/App/Features/Settings/SettingsViewModel.swift`

**Current State**: Button exists, TODO comment

**Required**:
```swift
func deleteAccount() async -> Result<Void, Error> {
    // 1. Show confirmation dialog (destructive action)

    // 2. Delete local data
    streakRepository.deleteAll()
    urgeLogRepository.deleteAll()
    patternRepository.deleteAll()

    // 3. Call backend deletion
    let result = await supabaseClient.deleteAccount()

    // 4. Sign out and clear credentials

    // 5. Reset to onboarding
    OnboardingState.shared.reset()

    return result
}
```

**Backend Requirements**:
- Hard delete user row from database
- Delete all associated data (conversations, logs, patterns)
- Revoke auth tokens
- Cancel subscriptions (StoreKit)

**Priority**: **P1 (Privacy requirement)**

---

### 10. **Daily Insights Generation** (LOW)

#### AI-Powered Daily Insights
**Location**: `/App/Features/Home/HomeViewModel.swift`

**Current State**: Card appears after 7+ days, but content is static

**Required**:
```swift
func generateDailyInsight() async -> String? {
    guard streakManager.currentStreak >= 7 else { return nil }

    // Gather context
    let recentLogs = urgeLogRepository.getLogs(from: Date().addingTimeInterval(-7 * 86400), to: Date())
    let patterns = patternRepository.getAllPatterns()

    // Create AI prompt
    let prompt = """
    Based on the user's last 7 days of data:
    - Current streak: \(streakManager.currentStreak) days
    - Urges logged: \(recentLogs.count)
    - Common triggers: \(recentLogs.commonTriggers())
    - Detected patterns: \(patterns.map { $0.description })

    Generate a brief (1-2 sentences), encouraging daily insight for the user.
    Focus on progress, patterns, or actionable tips.
    """

    // Call DeepSeek API
    let result = await aiCoachService.sendMessage(content: prompt, isPanicMode: false)

    switch result {
    case .success(let message):
        return message.content
    case .failure:
        return nil
    }
}
```

**Priority**: **P2 (Nice to have)**

---

## Implementation Priorities

### Phase 1: Core Functionality (P0 - Weeks 1-4)
**Goal**: Functional MVP with data persistence and basic features

1. **Week 1-2: Backend & Data**
   - [ ] Implement Supabase client (authentication, basic sync)
   - [ ] Replace in-memory repositories with SwiftData
   - [ ] Set up database schema in Supabase
   - [ ] Implement user registration/login

2. **Week 3-4: App Blocking**
   - [ ] Create DeviceActivity monitoring extension
   - [ ] Create Shield configuration extension
   - [ ] Implement FamilyControls in BlockingService
   - [ ] Test blocking flow end-to-end

### Phase 2: Premium Features (P0 - Weeks 5-6)
**Goal**: Enable revenue through subscriptions

3. **Week 5: StoreKit Integration**
   - [ ] Configure App Store Connect products
   - [ ] Implement StoreKit 2 purchase flow
   - [ ] Add trial period logic (7 days)
   - [ ] Test subscription status checks

4. **Week 6: AI Coach**
   - [ ] Integrate DeepSeek API
   - [ ] Implement message persistence
   - [ ] Add rate limiting enforcement
   - [ ] Test conversation history

### Phase 3: Enhanced Features (P1 - Weeks 7-8)
**Goal**: Improve user experience and retention

5. **Week 7: Analytics**
   - [ ] Implement pattern detection algorithms
   - [ ] Build data visualization components
   - [ ] Add calendar navigation
   - [ ] Test with real data

6. **Week 8: Polish**
   - [ ] Add export data functionality
   - [ ] Implement delete account
   - [ ] Set up push notifications backend
   - [ ] Shortcuts integration guide

### Phase 4: Optional Enhancements (P2 - Future)
**Goal**: Differentiation and advanced features

7. **Post-Launch**
   - [ ] Daily AI insights
   - [ ] Physical challenge implementations
   - [ ] Widget extension
   - [ ] Apple Watch companion app
   - [ ] Advanced ML pattern prediction

---

## Technical Architecture

### Current Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Anchor iOS App                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │  Onboarding    │  │     Home       │  │   Settings   │  │
│  │    Feature     │  │   Dashboard    │  │   Feature    │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │   AI Coach     │  │    Blocking    │  │  Analytics   │  │
│  │    Feature     │  │    Feature     │  │   Feature    │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
│                                                              │
│  ┌────────────────┐                                         │
│  │ Panic Button   │                                         │
│  │    Feature     │                                         │
│  └────────────────┘                                         │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                     Service Container                        │
│                   (Dependency Injection)                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │ StreakManager  │  │ AICoachService │  │Subscription  │  │
│  │                │  │                │  │   Manager    │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
│                                                              │
│  ┌────────────────┐  ┌────────────────┐                    │
│  │BlockingService │  │Notification    │                    │
│  │                │  │   Service      │                    │
│  └────────────────┘  └────────────────┘                    │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                     Networking Layer                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────┐  ┌────────────────┐                    │
│  │ DeepSeekClient │  │SupabaseClient  │                    │
│  │   (Stub)       │  │    (Stub)      │                    │
│  └────────────────┘  └────────────────┘                    │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                    Persistence Layer                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │    Streak      │  │    UrgeLog     │  │   Pattern    │  │
│  │  Repository    │  │  Repository    │  │ Repository   │  │
│  │ (In-Memory)    │  │  (In-Memory)   │  │(In-Memory)   │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘

           ▲                      ▲                    ▲
           │                      │                    │
           │ (Missing)            │ (Missing)          │ (Missing)
           │                      │                    │
           ▼                      ▼                    ▼

┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│  SwiftData   │     │  DeepSeek API    │     │  Supabase    │
│   Storage    │     │   (AI Coach)     │     │   Backend    │
└──────────────┘     └──────────────────┘     └──────────────┘


┌─────────────────────────────────────────────────────────────┐
│                    iOS Platform Extensions                   │
│                        (Missing)                             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────┐  ┌─────────────────────────┐       │
│  │  DeviceActivity    │  │  ShieldConfiguration    │       │
│  │  Monitor Extension │  │       Extension         │       │
│  │                    │  │                         │       │
│  │ • Monitoring       │  │ • Custom shield UI      │       │
│  │ • Start/end blocks │  │ • Deep link to app      │       │
│  └────────────────────┘  └─────────────────────────┘       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

#### Streak Tracking Flow
```
User opens app
    → HomeViewModel.onAppear()
    → StreakManager.checkDailyProgress()
    → If new day: StreakManager.incrementStreak()
    → StreakRepository.saveStreak()
    → [MISSING] SwiftData persists to disk
    → [MISSING] Supabase syncs to cloud
    → UI updates with new streak count
```

#### AI Chat Flow
```
User sends message
    → AICoachViewModel.sendMessage()
    → AICoachService.checkRateLimit()
    → DeepSeekClient.sendChatCompletion()
    → [MISSING] Real API call to DeepSeek
    → Response returned
    → [MISSING] Supabase saves conversation
    → Message added to history
    → UI displays response
```

#### App Blocking Flow
```
User selects apps + duration
    → BlockingViewModel.blockApps()
    → BlockingService.blockApps()
    → [MISSING] FamilyControls.requestAuthorization()
    → [MISSING] Create ManagedSettingsStore
    → [MISSING] Shield selected apps
    → [MISSING] DeviceActivity starts monitoring
    → [MISSING] Schedule expires → Remove shield
    → User sees blocked shield when opening apps
```

---

## API & Backend Requirements

### Supabase Database Schema

**Tables Required**:

#### `users`
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    subscription_status TEXT DEFAULT 'free', -- 'free', 'trial', 'premium'
    trial_end_date TIMESTAMP,
    deleted_at TIMESTAMP -- Soft delete
);
```

#### `streaks`
```sql
CREATE TABLE streaks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    current_streak INTEGER DEFAULT 0,
    total_clean_days INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id)
);
```

#### `urge_logs`
```sql
CREATE TABLE urge_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    timestamp TIMESTAMP DEFAULT NOW(),
    triggers JSONB, -- Array of trigger strings
    notes TEXT,
    was_relapse BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);
```

#### `patterns`
```sql
CREATE TABLE patterns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type TEXT, -- 'timeOfDay', 'dayOfWeek', 'triggerCorrelation'
    value TEXT,
    confidence FLOAT,
    detected_at TIMESTAMP DEFAULT NOW()
);
```

#### `conversations`
```sql
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    messages JSONB, -- Encrypted array of messages
    is_encrypted BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

#### `device_tokens`
```sql
CREATE TABLE device_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    platform TEXT DEFAULT 'ios',
    registered_at TIMESTAMP DEFAULT NOW()
);
```

**Row-Level Security (RLS)**:
```sql
-- Users can only access their own data
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can only access their own streaks"
    ON streaks FOR ALL
    USING (auth.uid() = user_id);

-- Repeat for all tables
```

---

### DeepSeek API Integration

**Endpoint**: `https://api.deepseek.com/v1/chat/completions`

**Authentication**: Bearer token in `Authorization` header

**Request Format**:
```json
{
  "model": "deepseek-chat",
  "messages": [
    {
      "role": "system",
      "content": "You are a compassionate recovery coach helping someone overcome addiction..."
    },
    {
      "role": "user",
      "content": "I'm feeling an urge right now, what should I do?"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 500,
  "stream": false
}
```

**Response Format**:
```json
{
  "id": "chatcmpl-123",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "I'm here with you. Take three deep breaths..."
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 120,
    "completion_tokens": 85,
    "total_tokens": 205
  }
}
```

**Rate Limits**:
- Free tier: 60 requests/minute
- Implement retry with exponential backoff
- Cache common responses locally

**System Prompt Template**:
```
You are a compassionate, non-judgmental recovery coach for someone working to overcome pornography addiction.

Guidelines:
- Use warm, supportive language without being patronizing
- Focus on forward-looking solutions, not dwelling on setbacks
- Suggest concrete coping strategies (breathing, physical activity, reaching out to support)
- Never shame or judge the user for urges or relapses
- Keep responses concise (2-3 sentences in crisis mode, longer for reflection)
- Acknowledge difficulty while emphasizing their strength and progress

Current context:
- User's current streak: {currentStreak} days
- Panic mode: {isPanicMode}
- Recent patterns: {recentPatterns}
```

---

## Testing Strategy

### Unit Tests

**Test Targets**:
1. **Service Layer**:
   ```swift
   // Example: AICoachServiceTests
   func testRateLimitEnforcement() {
       let service = AICoachService(client: MockDeepSeekClient())

       // Send 3 messages (free limit)
       for _ in 1...3 {
           let result = service.sendMessage(content: "Test", isPanicMode: false)
           XCTAssertSuccess(result)
       }

       // 4th message should fail
       let result = service.sendMessage(content: "Test", isPanicMode: false)
       XCTAssertFailure(result, .rateLimitExceeded)
   }
   ```

2. **Repository Layer**:
   - Test CRUD operations
   - Test persistence with SwiftData
   - Test data migrations

3. **ViewModels**:
   - Test state changes
   - Test error handling
   - Test navigation flows

### Integration Tests

**Test Scenarios**:
1. **End-to-End Blocking**:
   - User selects apps
   - Service creates block
   - Extension shows shield
   - Block expires correctly

2. **Streak Persistence**:
   - User completes day
   - App closes
   - App reopens
   - Streak increments correctly

3. **Subscription Flow**:
   - User starts trial
   - Trial expires after 7 days
   - User purchases subscription
   - Premium features unlocked

### UI Tests

**Critical Flows**:
1. Onboarding (all 7 screens)
2. Panic button activation
3. AI chat interaction
4. App blocking setup
5. Urge logging

### Manual Testing Checklist

**Before Launch**:
- [ ] Test on iPhone SE (small screen)
- [ ] Test on iPhone Pro Max (large screen)
- [ ] Test on iPad (if supported)
- [ ] Test with VoiceOver enabled
- [ ] Test with Reduce Motion enabled
- [ ] Test with Low Power Mode
- [ ] Test with airplane mode (offline)
- [ ] Test with poor network (3G speed)
- [ ] Test background refresh
- [ ] Test notifications (local & push)
- [ ] Test Face ID / Touch ID
- [ ] Test data export
- [ ] Test account deletion
- [ ] Test subscription purchase & cancellation

---

## Getting Started

### Prerequisites
- Xcode 15+
- iOS 17.0+ deployment target
- macOS Sonoma or later
- Active Apple Developer account ($99/year)
- Supabase account (free tier available)
- DeepSeek API key

### Setup Steps

1. **Clone Repository**:
   ```bash
   git clone https://github.com/ReedRawlings/Anchor_iOS.git
   cd Anchor_iOS
   ```

2. **Install Dependencies** (if using SPM):
   - Open `Anchor_iOS.xcodeproj`
   - Xcode will auto-resolve Swift Package dependencies

3. **Configure API Keys**:
   - Create `Config.xcconfig` (add to `.gitignore`)
   ```
   DEEPSEEK_API_KEY = sk_your_key_here
   SUPABASE_URL = https://your-project.supabase.co
   SUPABASE_ANON_KEY = your_anon_key_here
   ```

4. **Enable Capabilities**:
   - Signing & Capabilities → Add:
     - Family Controls
     - Push Notifications
     - Background Modes (Remote notifications, Background fetch)

5. **Create Extensions**:
   - File → New → Target → Device Activity Monitor Extension
   - File → New → Target → Shield Configuration Extension

6. **Run Tests**:
   ```bash
   xcodebuild test -scheme Anchor_iOS -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

7. **Build & Run**:
   - Select simulator or device
   - Cmd+R to build and run

---

## Next Steps

### Immediate Actions (This Week)
1. **Decision**: Choose persistence solution (SwiftData vs Core Data)
2. **Setup**: Create Supabase project and database schema
3. **Acquire**: Get DeepSeek API key
4. **Implement**: Start with data persistence (Phase 1, Week 1)

### Resources
- [Family Controls Documentation](https://developer.apple.com/documentation/familycontrols)
- [StoreKit 2 Guide](https://developer.apple.com/documentation/storekit)
- [SwiftData Tutorial](https://developer.apple.com/documentation/swiftdata)
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift)
- [DeepSeek API Docs](https://platform.deepseek.com/docs)

---

## Contributing

See `CONTRIBUTING.md` for development guidelines and pull request process.

## License

This project is proprietary. All rights reserved.

---

**Last Updated**: 2025-11-23
**Version**: 1.0.0 (Pre-launch)
**Maintainer**: Reed Rawlings

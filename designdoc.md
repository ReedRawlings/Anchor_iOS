# NoGoon Design System v1.0

## Design Philosophy

### Core Principles

1. **Recovery-First Design** - Every decision prioritizes the user's recovery journey over engagement metrics
2. **Spaciousness Over Density** - Breathing room reduces anxiety; users should spend minimal time in-app
3. **Calm by Default, Focused in Crisis** - UI adapts to emotional state without feeling clinical
4. **Privacy as a Feature** - Sensitive data is discreet, easily obscured, never accidentally visible
5. **One-Handed Crisis Access** - Critical features (panic button) must work when hands are shaking
6. **Trust Through Consistency** - Predictable interactions build confidence during vulnerable moments

### Design Intent

NoGoon is not a productivity app or achievement tracker. It's a support system for recovery. The design should feel:
- **Calm** - Not energetic or gamified
- **Clear** - Obvious next actions without cognitive load
- **Compassionate** - Non-judgmental, forward-looking after setbacks
- **Capable** - Serious and effective, not patronizing
- **Private** - Visually discreet, safe to use in public

---

## 🎨 Color System

### Base Palette

```swift
// Background System
struct BackgroundColors {
    // Screen backgrounds (solid)
    static let primary = UIColor(hex: "#0A0E14")      // Main screen backgrounds
    static let secondary = UIColor(hex: "#0F1419")    // Nested backgrounds, modals
    
    // Material backgrounds (glassmorphism) - PRIMARY PATTERN FOR CARDS
    static let ultraThin = UIBlurEffect.Style.systemUltraThinMaterialDark
    static let regular = UIBlurEffect.Style.systemMaterialDark
    
    // Solid backgrounds (specific cases)
    static let tertiary = UIColor(hex: "#1C2128")     // Text input fields only
    static let elevated = UIColor(hex: "#161B22")     // Chat messages, solid cards
}

// Accent Colors - Emotional State System
struct AccentColors {
    // Primary (Calm/Default State)
    static let primary = UIColor(hex: "#10B981")      // Emerald green - growth, calm, progress
    static let primaryLight = UIColor(hex: "#34D399") // Lighter emerald for highlights
    static let primaryDark = UIColor(hex: "#059669")  // Darker emerald for depth
    
    // Alert (Crisis State)
    static let alert = UIColor(hex: "#FF6B35")        // Coral orange - urgent but not alarming
    static let alertLight = UIColor(hex: "#FF8C61")   // Lighter coral
    
    // Semantic Colors
    static let success = UIColor(hex: "#10B981")      // Same as primary (progress = success)
    static let warning = UIColor(hex: "#F59E0B")      // Amber - caution, risk times
    static let error = UIColor(hex: "#EF4444")        // Red - destructive actions only
    static let neutral = UIColor(hex: "#6B7280")      // Gray - neutral info, disabled states
}

// Text Colors
struct TextColors {
    static let primary = UIColor(hex: "#FFFFFF")      // Main content, headings
    static let secondary = UIColor(hex: "#9CA3AF")    // Supporting text, metadata
    static let tertiary = UIColor(hex: "#6B7280")     // Labels, placeholders, deemphasized
    static let inverse = UIColor(hex: "#0A0E14")      // Text on bright backgrounds
    static let success = UIColor(hex: "#10B981")      // Success states, progress
    static let warning = UIColor(hex: "#F59E0B")      // Warnings, risk indicators
    static let error = UIColor(hex: "#EF4444")        // Errors, critical info
}

// Interactive States
struct InteractiveColors {
    static let hover = UIColor(white: 1.0, alpha: 0.06)
    static let active = UIColor(white: 1.0, alpha: 0.10)
    static let disabled = UIColor(hex: "#6B7280", alpha: 0.3)
    static let border = UIColor(white: 1.0, alpha: 0.1)
    static let borderFocused = UIColor(hex: "#10B981", alpha: 0.4)
}
```

### Emotional State Color Modes

NoGoon adapts its color usage based on the user's current state:

#### Default/Calm State
```swift
// Regular app usage, daily check-ins, viewing analytics
primaryCTA: AccentColors.primary (emerald)
secondaryActions: .ultraThinMaterial with emerald border
destructiveActions: AccentColors.error
dataVisualization: Emerald for progress, gray for neutral
```

#### Panic/Crisis State
```swift
// Active panic button flow, emergency blocking
primaryCTA: AccentColors.alert (coral orange)
secondaryActions: Reduced (minimize choice paralysis)
background: Slightly warmer tint (subtle, imperceptible shift)
animations: Slower, more deliberate (breathing exercise pace)
```

#### Recovery State
```swift
// Post-relapse, rebuilding
primaryCTA: AccentColors.primary (emerald - forward motion)
dataTreatment: Non-judgmental (neutral grays with emerald accents)
messaging: Compassionate tone, no red/error states for relapses
```

### Color Usage Rules

**Emerald Green (Primary):**
- Default CTAs (Save, Continue, Add, Start)
- Progress indicators and success states
- Clean day markers in calendar
- Active states in navigation
- Positive data trends

**Coral Orange (Alert):**
- Panic button ONLY
- Crisis flow CTAs
- Emergency block actions
- Time-sensitive warnings
- **Never** use for errors or negative states

**Red (Error):**
- Destructive actions only (Delete Account, Remove Block, End Session)
- System errors (network failure, save failed)
- **Never** use for relapse data or struggle indicators

**Amber (Warning):**
- Risk time indicators
- Block about to expire
- Approaching message limit
- Pattern insights showing high-risk periods

**Gray (Neutral):**
- Relapse markers in calendar (non-judgmental)
- Inactive/disabled states
- Metadata and supporting info
- Skipped days or no data

**Usage Priorities:**
1. Use emerald for 80% of positive actions and progress
2. Reserve orange exclusively for crisis/urgent contexts
3. Use gray for relapses and neutral data (never red)
4. Use amber sparingly for genuine cautions
5. Red only for irreversible destructive actions

---

## 🔍 Depth & Elevation System

### Material Strategy

NoGoon uses native iOS materials for depth, with **zero custom shadows** except on the panic button.

```swift
struct Elevation {
    // Primary pattern: Glass materials
    static let card = UIBlurEffect.Style.systemUltraThinMaterialDark
    static let modal = UIBlurEffect.Style.systemMaterialDark
    static let sheet = UIBlurEffect.Style.systemMaterialDark
    
    // Secondary pattern: Solid elevated surfaces
    static let chatBubble = BackgroundColors.elevated
    static let inputField = BackgroundColors.tertiary
    
    // Special case: Panic button shadow ONLY
    static let panicShadow = {
        color: AccentColors.alert.opacity(0.4)
        radius: 12pt
        y: 6pt
    }
}
```

### Depth Hierarchy

**Level 0: Screen Background**
- Solid color: `BackgroundColors.primary`
- Always dark, consistent

**Level 1: Content Cards**
- `.ultraThinMaterial` glass
- Most common pattern
- Use for: stats, sections, groupings

**Level 2: Modals & Sheets**
- `.regularMaterial` glass
- More opaque than cards
- Use for: pickers, forms, overlays

**Level 3: Special Elements**
- Solid backgrounds for: chat bubbles, text inputs
- Glass creates cognitive load when typing/reading conversations

### Shadow Rules

**Use shadow on:**
- Panic button ONLY (coral glow, always visible)

**Never use shadow on:**
- Cards (glass provides depth)
- Regular buttons
- List items
- Input fields
- Modals
- Navigation elements

---

## 📝 Typography System

### Font Families

```swift
struct AppFonts {
    // Primary fonts
    static let display = "SF Pro Display"     // Large titles (28pt+)
    static let text = "SF Pro Text"          // Body, UI elements
    static let rounded = "SF Pro Rounded"    // Buttons, friendly elements
    
    // Data font
    static let mono = "SF Mono"              // All numeric data, metrics, counts
}
```

### Type Scale

```swift
// Display Sizes (Titles, Headers)
struct DisplayType {
    static let hero = UIFont.systemFont(ofSize: 28, weight: .bold)       // Screen titles
    static let title = UIFont.systemFont(ofSize: 22, weight: .semibold)  // Section titles
    static let subtitle = UIFont.systemFont(ofSize: 18, weight: .semibold) // Card headers
}

// Body Sizes (Content, Labels)
struct BodyType {
    static let large = UIFont.systemFont(ofSize: 17, weight: .regular)   // Primary content
    static let regular = UIFont.systemFont(ofSize: 15, weight: .regular) // Body text
    static let small = UIFont.systemFont(ofSize: 13, weight: .regular)   // Metadata
    static let caption = UIFont.systemFont(ofSize: 11, weight: .regular) // Fine print
}

// Data Sizes (Numbers, Metrics, Counts)
struct DataType {
    static let hero = UIFont.monospacedSystemFont(ofSize: 48, weight: .semibold)   // Dashboard streak
    static let large = UIFont.monospacedSystemFont(ofSize: 32, weight: .medium)    // Primary stats
    static let medium = UIFont.monospacedSystemFont(ofSize: 20, weight: .medium)   // Secondary data
    static let small = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)    // Calendar, lists
}

// Label Sizes
struct LabelType {
    static let standard = UIFont.systemFont(ofSize: 11, weight: .semibold)  // Field labels
    static let tag = UIFont.systemFont(ofSize: 10, weight: .semibold)       // Tags, badges
}

// Button Text
struct ButtonType {
    static let primary = UIFont.systemFont(ofSize: 17, weight: .semibold, design: .rounded)
    static let secondary = UIFont.systemFont(ofSize: 15, weight: .semibold)
}

// AI Chat
struct ChatType {
    static let message = UIFont.systemFont(ofSize: 16, weight: .regular)    // Chat bubbles
    static let timestamp = UIFont.systemFont(ofSize: 12, weight: .regular)  // Time stamps
    static let systemPrompt = UIFont.systemFont(ofSize: 13, weight: .medium) // Context indicators
}
```

### Typography Usage Guidelines

**When to use each font:**

**SF Pro Display (28pt+, bold only):**
- Screen titles
- Hero stats (with mono for numbers)
- Major section headers

**SF Pro Text (<28pt):**
- All body copy
- Labels and UI text
- Supporting content
- AI chat messages (warmth needed)

**SF Pro Rounded:**
- All button text
- Action-oriented UI elements
- Friendly, approachable contexts

**SF Mono (all numeric content):**
- Streak counts (e.g., "14 days")
- Time remaining on blocks
- Analytics data (hours, percentages)
- Calendar dates
- Message limits (e.g., "2/3 messages")
- Pattern insights (e.g., "3:00 PM")

**Sensitive Content Considerations:**

- **Triggers:** Use regular SF Pro Text, not mono (avoid clinical feel)
- **Relapse logs:** Body text, not emphasized
- **AI responses:** SF Pro Text for warmth and humanity
- **Data visualizations:** Mono for axes/numbers, regular for labels

**Letter Spacing:**
- Display text (28pt+): -0.5pt (tighter)
- Labels (uppercase): +0.5pt (tracking)
- Body text: 0pt (default)
- Monospace: 0pt (never adjust)

**Line Height:**
- Display: 1.15x (tight but readable)
- Body: 1.5x (comfortable, spacious)
- Chat messages: 1.5x (conversational)
- Data: 1.2x (compact)

---

## 📏 Spacing System

### Base Unit: 4pt Grid

All spacing uses 4pt multiples for consistency and rhythm.

```swift
struct Spacing {
    static let xxxs: CGFloat = 2   // Rare, tight groupings
    static let xxs: CGFloat = 4    // Label to input
    static let xs: CGFloat = 8     // Related elements
    static let sm: CGFloat = 12    // Card internal spacing
    static let md: CGFloat = 16    // Section spacing
    static let lg: CGFloat = 20    // Screen margins
    static let xl: CGFloat = 24    // Major sections
    static let xxl: CGFloat = 32   // Screen-level separation
    static let xxxl: CGFloat = 48  // Hero spacing, crisis screens
}
```

### Layout Guidelines

**Screen Margins (Spacious Approach):**
- Horizontal: 20pt (left/right)
- Top: 20pt from nav bar / safe area (more breathing room)
- Bottom: 24pt from safe area
- Crisis screens: 24pt all sides (extra calm)

**Card Spacing:**
- Internal padding: 16-20pt (generous)
- Margin between cards: 16pt (breathe)
- Border radius: 16pt (standard), 12pt (nested)

**Content Spacing:**
- Paragraph spacing: 16pt (readable)
- List item padding: 16pt vertical (comfortable tap targets)
- Section breaks: 32pt (clear visual separation)

**Input Fields:**
- Padding: 12pt vertical, 16pt horizontal
- Margin below label: 6pt
- Margin between fields: 16pt

**Button Spacing:**
- Primary height: 56pt
- Secondary height: 48pt
- Padding horizontal: 20pt minimum
- Margin above CTA: 24pt minimum

### Spaciousness Philosophy

**Key principle: Breathing room reduces anxiety**

Users should not feel overwhelmed by information density:
- Single focus per screen when possible
- Generous whitespace around interactive elements
- Clear visual hierarchy through spacing
- Crisis screens especially spacious

**Exception:** Calendar/analytics views can be denser since they're reference tools, not frequent interactions

---

## 🖼️ Component Library

### Cards

#### Glass Card (Primary Pattern)
```swift
// Use for: Most content cards, sections, groupings
background: .ultraThinMaterial
cornerRadius: 16pt
padding: 16-20pt (generous)
border: None (material provides definition)
shadow: None

// States
default: opacity 1.0
pressed: scale(0.98), duration 0.15s
disabled: opacity 0.5
```

#### Solid Card (Chat, Reading)
```swift
// Use for: AI chat bubbles, text-heavy content
background: BackgroundColors.elevated
cornerRadius: 16pt
padding: 12-16pt
border: None
shadow: None
```

#### Input Card (Text Fields)
```swift
// Use for: Text input fields only
background: BackgroundColors.tertiary (solid)
cornerRadius: 10pt
padding: 12pt vertical, 16pt horizontal
border: 2pt solid transparent
shadow: None

// States
default: border transparent
focused: border AccentColors.primary (emerald)
error: border AccentColors.error
```

---

### Buttons

#### Primary CTA (Main Actions)
```swift
height: 56pt
background: AccentColors.primary (solid emerald, not gradient)
cornerRadius: 16pt
textColor: TextColors.inverse
font: ButtonType.primary (SF Pro Rounded)
shadow: None (unless panic button)

// States
default: background emerald
pressed: scale(0.97) + brightness(0.9), duration 0.15s
disabled: background gray, opacity 0.5
loading: show spinner, disabled state

// Animation
spring: damping 0.7, duration 0.2s
```

#### Panic Button (Special Case)
```swift
height: 60pt (slightly larger)
background: AccentColors.alert (coral orange)
cornerRadius: 30pt (fully rounded)
textColor: TextColors.inverse
font: ButtonType.primary
shadow: color AccentColors.alert.opacity(0.4), radius 12pt, y 6pt

// ONLY button with shadow in entire app
// Always prominent, always accessible
// States
default: shadow visible, pulsing glow animation (subtle)
pressed: scale(0.95) + shadow radius 6pt
disabled: Never disabled (always accessible)
```

#### Secondary Action
```swift
height: 48pt
background: .ultraThinMaterial (glass)
cornerRadius: 12pt
textColor: AccentColors.primary
font: ButtonType.secondary
border: 2pt solid rgba(16, 185, 129, 0.3) // emerald
shadow: None

// States
pressed: background .regularMaterial + scale(0.98)
```

#### Destructive Action
```swift
// Same as secondary but:
textColor: AccentColors.error
border: 2pt solid rgba(239, 68, 68, 0.3) // red
```

#### Text Button (Tertiary)
```swift
background: None
textColor: AccentColors.primary
font: ButtonType.secondary
underline: None
minHeight: 44pt (tap target)
padding: 12pt horizontal

// States
pressed: opacity 0.6
```

---

### Navigation & Tabs

#### Custom Tab Bar
```swift
// Don't use UISegmentedControl - custom design required

container:
  background: .ultraThinMaterial
  cornerRadius: 12pt
  padding: 4pt
  height: 44pt
  
tabs:
  height: 36pt
  padding: 8pt horizontal
  
  unselected:
    background: transparent
    textColor: TextColors.secondary
    
  selected:
    background: BackgroundColors.elevated (solid)
    textColor: TextColors.primary
    
  animation: 0.3s spring slide
  indicator: None (background slide is indicator)
```

---

### Input Fields

#### Text Input
```swift
background: BackgroundColors.tertiary (solid)
cornerRadius: 10pt
padding: 12pt vertical, 16pt horizontal
minHeight: 44pt
fontSize: BodyType.regular
textColor: TextColors.primary
placeholderColor: TextColors.tertiary
border: 2pt solid transparent

// States
default: border transparent
focused: border AccentColors.primary (emerald)
error: border AccentColors.error + shake animation
disabled: opacity 0.5

// For sensitive input (journal, triggers):
autocorrect: off
spellcheck: off (user may misspell triggers intentionally)
```

#### Number Input (Durations, Counts)
```swift
display:
  background: rgba(255, 255, 255, 0.04)
  cornerRadius: 10pt
  padding: 16pt vertical
  fontSize: DataType.medium (20pt monospace)
  textAlign: center
  textColor: TextColors.primary
  
interaction: 
  picker or stepper depending on context
  haptic feedback on value change (light impact)
```

#### Duration Picker (Block Time)
```swift
// Custom wheel picker
background: .regularMaterial
cornerRadius: 16pt (top corners)
height: 260pt
values: [15min, 30min, 1hr, 2hr, 4hr, 8hr, 24hr, Until Tomorrow]
font: DataType.medium
selectedColor: AccentColors.primary
```

---

### Lists & Rows

#### List Item (History, Data Logs)
```swift
// Dense, scannable rows without card backgrounds

height: 64pt (comfortable tap target)
background: None (or subtle separator only)
padding: 12pt horizontal, 16pt vertical
separator: 1pt solid rgba(255, 255, 255, 0.06)

layout: Horizontal
  - Left: Icon or badge (32pt)
  - Center: Primary info + metadata
  - Right: Data or chevron

// States
default: background transparent
pressed: background InteractiveColors.active
```

#### Trigger Selection Item
```swift
// Clinical, non-suggestive design
height: 52pt
background: .ultraThinMaterial
cornerRadius: 12pt
padding: 12pt horizontal
margin: 8pt between items

layout:
  - Left: Text label (clinical language)
  - Right: Checkmark or selection indicator
  
selected: border 2pt AccentColors.primary
```

---

### AI Chat Interface

#### Chat Bubble (User)
```swift
background: AccentColors.primary (emerald)
textColor: TextColors.inverse
cornerRadius: 18pt
  topRight: 4pt (tail effect)
padding: 12pt horizontal, 10pt vertical
maxWidth: 75% of screen
alignment: right
font: ChatType.message
```

#### Chat Bubble (AI/Assistant)
```swift
background: BackgroundColors.elevated (solid)
textColor: TextColors.primary
cornerRadius: 18pt
  topLeft: 4pt (tail effect)
padding: 12pt horizontal, 10pt vertical
maxWidth: 80% of screen
alignment: left
font: ChatType.message
lineHeight: 1.5x
```

#### Chat Input Field
```swift
background: BackgroundColors.tertiary (solid)
cornerRadius: 20pt
padding: 10pt horizontal, 8pt vertical
minHeight: 40pt
maxHeight: 120pt (grows with content)
font: ChatType.message
placeholderColor: TextColors.tertiary

// Attached to bottom with safe area inset
// Send button embedded in field (right side)
```

#### Context Indicator (Panic Mode, etc.)
```swift
// Shows when AI has special context
background: rgba(255, 107, 53, 0.1) // subtle coral tint
textColor: AccentColors.alert
cornerRadius: 8pt
padding: 6pt horizontal, 4pt vertical
font: ChatType.systemPrompt
position: Top of chat, dismissible

text: "Panic Mode Active - Unlimited messages"
```

---

### Blocking UI Components

#### Block Duration Selector
```swift
// Grid of duration options
layout: 2 columns, 4 rows
gap: 12pt

option:
  background: .ultraThinMaterial
  cornerRadius: 12pt
  padding: 16pt vertical
  textAlign: center
  
  unselected:
    border: 1pt solid rgba(255, 255, 255, 0.1)
    textColor: TextColors.primary
    
  selected:
    border: 2pt solid AccentColors.primary
    background: rgba(16, 185, 129, 0.1)
    textColor: AccentColors.primary
```

#### Active Block Indicator
```swift
// Shows on home screen when blocks active
background: .ultraThinMaterial
cornerRadius: 12pt
padding: 16pt
border: 2pt solid AccentColors.primary

layout:
  - Icon: Shield (16pt)
  - Text: "X apps blocked"
  - Timer: "2:34:15 remaining" (monospace)
  - Action: "Manage" (text button)
```

#### Shield Configuration Preview
```swift
// Shows what user will see when blocked
background: BackgroundColors.primary
cornerRadius: 16pt
padding: 24pt
border: 2pt dashed rgba(255, 255, 255, 0.2)

content:
  - Icon: Lock (48pt)
  - Title: "Blocked by Anchor"
  - Time: "1:23:45 remaining"
  - Buttons: "Open Anchor" + "I Understand"
```

---

### Calendar & Pattern Views

#### Calendar Day Cell
```swift
size: Fills available width / 7, square
cornerRadius: 8pt
padding: 4pt

states:
  - Clean day: background AccentColors.primary.opacity(0.2)
  - Relapse: background TextColors.tertiary.opacity(0.3) // gray, non-judgmental
  - No data: background transparent
  - Today: border 2pt AccentColors.primary
  
content:
  - Day number: DataType.small
  - Optional badge for notes/patterns
```

#### Pattern Graph (High-Risk Times)
```swift
// Heatmap or bar chart showing struggle times
background: .ultraThinMaterial
cornerRadius: 16pt
padding: 16pt

axis:
  textColor: TextColors.tertiary
  font: BodyType.small
  
data:
  highRisk: AccentColors.warning (amber)
  mediumRisk: AccentColors.warning.opacity(0.5)
  lowRisk: TextColors.tertiary.opacity(0.3)
  
// Non-judgmental, analytical presentation
// Focus on patterns, not shame
```

---

### Modals & Sheets

#### Bottom Sheet (Pickers, Forms)
```swift
background: .regularMaterial
cornerRadius: 20pt (top corners only)
animation: slide up 0.35s spring
backdrop: rgba(0, 0, 0, 0.6)

header:
  height: 60pt
  padding: 16pt horizontal
  border bottom: 1pt solid rgba(255, 255, 255, 0.06)
  
  content:
    - Title: centered, DisplayType.subtitle
    - Dismiss: "Done" button (top right)
    
content:
  maxHeight: 70vh
  padding: 16pt
  scrollable: if needed
  
footer (optional):
  padding: 16pt
  border top: 1pt solid rgba(255, 255, 255, 0.06)
  CTA button: full width
```

#### Full Screen Modal (Complex Flows)
```swift
background: BackgroundColors.primary (solid)
animation: slide up 0.35s spring
nav bar: Standard iOS with custom styling
  - title: DisplayType.title
  - back: "< Back" or "Cancel"
  - CTA: "Save" or "Done" (emerald)
```

#### Alert Dialog (Confirmations)
```swift
// Rare - only for destructive actions
background: .regularMaterial
cornerRadius: 20pt
padding: 20pt
maxWidth: 320pt

title: DisplayType.subtitle
message: BodyType.regular, TextColors.secondary
buttons: Stacked vertical
  - Primary: Full width
  - Secondary: Full width, 8pt gap
```

---

### Special Components

#### Breathing Exercise Animation
```swift
// Circular animation for breathing guidance
size: 200pt diameter
position: center screen
background: gradient (emerald to lighter emerald)
animation: 
  - Inhale: scale(1.0 → 1.3) over 4s
  - Hold: scale(1.3) for 2s
  - Exhale: scale(1.3 → 1.0) over 6s
  - Repeat
  
overlay text:
  - "Breathe In" / "Hold" / "Breathe Out"
  - font: DisplayType.title
  - color: white
  - fade in/out with states
```

#### Cooldown Timer (Emergency Unlock)
```swift
// 5-minute countdown before unlock allowed
size: 120pt diameter
background: .ultraThinMaterial
border: 4pt solid AccentColors.primary
cornerRadius: 60pt (circle)

content:
  - Time remaining: DataType.large (monospace)
  - Subtitle: "Required wait"
  - Progress ring: animated stroke

// Can't be dismissed or skipped
// Non-punishing feel (protective, not restrictive)
```

#### Milestone Celebration (Streak Achievement)
```swift
// Subtle, not gamified
animation:
  1. Icon scale in (0.3s spring overshoot)
  2. Confetti burst (subtle, brief)
  3. Text fade in
  
content:
  - Icon: Check or badge (48pt, emerald)
  - Number: "7 Days" (DataType.hero)
  - Message: "One week clean" (BodyType.large)
  - CTA: "Continue" button
  
haptic: Notification.success
duration: 3s auto-dismiss (or tap to dismiss)
```

#### Journal Prompt (Emergency Unlock)
```swift
// Required before emergency block disable
background: .regularMaterial
cornerRadius: 16pt
padding: 20pt

prompt:
  - "What's making you want to disable this block?"
  - TextColors.primary
  - BodyType.regular
  
input:
  - multiline text field
  - minHeight: 100pt
  - characterCount: "12/20" (live update)
  - disabled state until 20 chars
  
CTA:
  - "Continue" (disabled until min chars)
  - Emerald when enabled
```

---

## 🎯 Interaction Patterns

### Crisis Interaction Patterns

#### Panic Button Flow
```swift
1. Triple back-tap / in-app button
   → Immediate response (no loading)
   
2. Breathing screen (10s unskippable)
   → Full screen, no dismiss
   → Breathing animation (auto-progresses)
   
3. Action grid (2x2)
   → Large tap targets (120pt each)
   → Icons + labels
   → Options:
     - Talk to AI (unlimited)
     - Block Everything
     - Breathing Exercise (2min)
     - Physical Challenge
     
4. Automatic urge log
   → Logged in background
   → No interruption to flow
```

**Design Principles:**
- Zero friction to activate
- Immediate feedback (no loading states)
- Large tap targets (crisis = reduced motor control)
- No decision paralysis (max 4 options)
- Forward motion only (no back button on breathing screen)

---

#### Emergency Block Unlock Flow
```swift
// When user wants to disable emergency block

1. Tap "Disable Block" on shield screen
   → Opens app to journal prompt
   
2. Journal Entry (20 char minimum)
   → "What's making you want to disable this block?"
   → Character counter visible
   → Continue button disabled until 20 chars
   
3. Cooldown Timer (5 minutes, unskippable)
   → Full screen circular countdown
   → "Taking a moment to reflect..."
   → Can minimize app but timer continues
   
4. Confirmation Dialog
   → "Are you sure you want to disable this block?"
   → "You'll be able to re-enable it anytime"
   → Destructive-styled button
   
5. Block Disabled
   → Apps unlocked
   → Entry saved for pattern analysis
   → No judgment, just data
```

**Design Principles:**
- Intentional friction (protective, not punishing)
- Non-judgmental language
- Preserves user agency (always possible to unlock)
- Data collection for patterns (why unlock?)

---

#### Relapse Logging Flow
```swift
// When user breaks streak

Modal appears:
  1. "What triggered this?" (trigger selector)
     → Clinical language
     → Multi-select allowed
     → "Other" with text field
     
  2. Optional: "Anything else to note?"
     → Text field (not required)
     → Placeholder: "This is just for you..."
     
  3. CTA: "Continue"
     → Emerald button (forward-looking)
     → Never say "Submit" or "Log Relapse"

Result:
  - Streak resets to 0
  - Total clean days preserved and visible
  - AI follow-up focuses on trigger analysis
  - Data point added to patterns (non-judgmental)
```

**Design Principles:**
- Non-shaming language ("What triggered" not "Why did you fail")
- Forward-looking (Continue, not Submit)
- Preserve total clean days metric (progress isn't erased)
- Optional detail (no forced analysis during vulnerable moment)

---

### Privacy Patterns

#### Quick Obscure (Shoulder Surfing Protection)
```swift
// Gesture: Three-finger tap on screen
// Result: Sensitive data blurred/hidden

Screens affected:
  - Analytics (patterns, struggle times)
  - Calendar (relapse markers)
  - AI chat (conversation content)
  - Urge logs (trigger details)

Visual:
  - Gaussian blur (radius 20pt)
  - Overlay: "Tap to reveal"
  - No animation (instant)
  
Restore:
  - Tap anywhere to remove blur
  - Auto-restore after 10s if app backgrounded
```

#### Discreet Navigation
```swift
// App name in navigation never says "NoGoon"
// Use: "Anchor" everywhere

// Notification content:
  - Generic: "Time for your check-in"
  - Never: "Log your urge" or triggering language
  
// App icon:
  - Abstract, not suggestive
  - Could be any wellness app
  
// Face ID prompt:
  - "Authenticate to continue"
  - Never reveals what's being protected
```

---

### One-Handed Optimization

**Thumb Reach Zones:**
```
Bottom third:   Primary CTAs, frequent actions
Middle third:   Content, inputs, selections
Top third:      Headers, read-only info, settings
```

**Critical Patterns:**

**Panic Button:**
- Position: Floating bottom right (fixed)
- Size: 60pt (easily tappable with thumb)
- Distance from edge: 20pt (within comfortable reach)

**Chat Input:**
- Position: Bottom of screen (keyboard attached)
- Send button: Right side (right-handed default)
- Voice input option: Left side (one-handed alternative)

**Primary CTAs:**
- Position: Bottom 20% of scrollable content
- Full width or centered (no precise taps required)
- Height: 56pt minimum

**Scrollable Lists:**
- Tap targets: 44pt minimum height
- Important actions: Swipe gestures (easier than precise taps)

**Navigation:**
- Bottom tab bar (if used)
- Back button: Top left (iOS standard, acceptable trade-off)

---

### Haptic Feedback Strategy

```swift
struct HapticFeedback {
    // Light Impact (subtle confirmation)
    static let lightActions = [
        "picker value change",
        "tab switch",
        "toggle on/off"
    ]
    
    // Medium Impact (standard feedback)
    static let mediumActions = [
        "button tap",
        "selection",
        "add/remove item"
    ]
    
    // Heavy Impact (rare, significant)
    static let heavyActions = [
        "panic button tap",
        "block enable/disable",
        "streak milestone"
    ]
    
    // Notification Success
    static let successActions = [
        "save successful",
        "milestone reached",
        "block activated"
    ]
    
    // Notification Warning
    static let warningActions = [
        "approaching limit",
        "risk time alert"
    ]
    
    // Notification Error
    static let errorActions = [
        "save failed",
        "network error"
    ]
}
```

**Guidelines:**
- Always respect system haptics setting
- Don't overuse (notification fatigue)
- Match haptic intensity to action importance
- Crisis actions get stronger haptics (attention-grabbing)

---

## 🎬 Animation Standards

### Timing Functions

```swift
struct AnimationTiming {
    // Durations
    static let instant: TimeInterval = 0.1      // Immediate feedback
    static let quick: TimeInterval = 0.2        // Button presses
    static let standard: TimeInterval = 0.3     // Most transitions
    static let deliberate: TimeInterval = 0.5   // Celebrations, modals
    static let slow: TimeInterval = 1.0         // Breathing exercises
    
    // Easing (avoid linear)
    static let easeOut = CAMediaTimingFunction(name: .easeOut)
    static let easeInOut = CAMediaTimingFunction(name: .easeInOut)
    static let spring = UISpringTimingParameters(
        dampingRatio: 0.75,
        initialVelocity: 0.2
    )
}
```

### Common Animations

**Button Press (All CTAs)**
```swift
onTouchDown:
  scale: 1.0 → 0.97
  duration: 0.15s easeOut
  
onTouchUp:
  scale: 0.97 → 1.0
  duration: 0.15s spring
```

**Card Tap (Interactive Cards)**
```swift
onTouchDown:
  scale: 1.0 → 0.98
  opacity: 1.0 → 0.9
  duration: 0.15s easeOut
  
onTouchUp:
  scale: 0.98 → 1.0
  opacity: 0.9 → 1.0
  duration: 0.15s spring
```

**Modal Present (Bottom Sheet)**
```swift
sheet:
  translate: screenHeight → 0
  duration: 0.35s spring
  
backdrop:
  opacity: 0 → 1
  duration: 0.25s easeOut
```

**Tab Switch**
```swift
indicator:
  translate: oldPosition → newPosition
  duration: 0.3s spring
  
content:
  opacity: 1 → 0 → 1 (crossfade)
  duration: 0.25s easeInOut
```

**Item Delete (List Removal)**
```swift
1. Scale + fade out
   scale: 1.0 → 0.9
   opacity: 1.0 → 0
   duration: 0.25s easeOut
   
2. Collapse height
   height: current → 0
   duration: 0.3s spring
   
3. Other items slide up
   translate: adjust for removed space
   duration: 0.3s spring
```

**Success Celebration (Milestone)**
```swift
1. Icon entrance
   scale: 0 → 1.1 → 1.0 (overshoot)
   duration: 0.4s spring
   
2. Text fade in
   opacity: 0 → 1
   translate: y +10 → 0
   duration: 0.3s easeOut
   delay: 0.2s
   
3. Haptic
   trigger: Notification.success
   timing: with icon overshoot
```

**Breathing Animation (Crisis)**
```swift
// Slow, deliberate pacing
circle:
  inhale:
    scale: 1.0 → 1.3
    duration: 4.0s easeInOut
    
  hold:
    scale: 1.3 (no change)
    duration: 2.0s
    
  exhale:
    scale: 1.3 → 1.0
    duration: 6.0s easeInOut
    
  repeat: infinite loop
  
text overlay:
  fade in: 0.5s
  fade out: 0.5s
  timing: synchronized with breath phases
```

**Panic Button Pulse (Idle State)**
```swift
// Subtle, continuous attention-grabber
shadow:
  opacity: 0.4 → 0.6 → 0.4
  radius: 12pt → 16pt → 12pt
  duration: 2.0s easeInOut
  repeat: infinite
  
// Very subtle, not distracting
```

### Animation Principles

- **Always animate state changes** - No instant jumps (except hover)
- **Use spring physics for natural feel** - Especially scales and slides
- **Slower in crisis contexts** - Breathing exercises, cooldowns
- **Respect Reduce Motion** - Provide simplified alternatives
- **Coordinate related animations** - Stagger slightly for rhythm (0.1-0.2s)
- **No gratuitous animation** - Every animation serves a purpose

---

## 📱 Screen Templates

### Home Dashboard

**Layout:**
```
Navigation Bar (60pt)
  - Title: "Anchor" (left)
  - Settings icon (right)
  
Hero Stat (200pt)
  - Current streak
    - Number: DataType.hero (48pt mono)
    - Label: "Days Clean"
  - Total clean days
    - Number: DataType.large (32pt mono)
    - Label: "Total Clean Days"
    
Quick Actions Grid (2x2, 160pt)
  - AI Coach
  - Log Urge
  - Quick Block
  - View Patterns
  
Daily Insight Card (optional, 120pt)
  - AI-generated (if 7+ days data)
  - Dismissible
  
Active Blocks Card (conditional)
  - Shows when blocks active
  - Time remaining + manage
  
Panic Button (floating, 60pt)
  - Bottom right, 20pt from edges
  - Always visible, never scrolls away
```

**Spacing:**
- Screen margins: 20pt
- Sections: 24pt apart
- Cards in grid: 12pt gap

---

### Panic Flow Screens

#### Screen 1: Breathing Exercise (Unskippable)
```
Full Screen (no chrome)
  - Background: solid dark
  - Breathing animation: 200pt circle, centered
  - Text overlay: "Breathe In" / "Hold" / "Breathe Out"
  - Timer: 10 seconds (hidden, auto-progress)
  - No dismiss or back button
```

#### Screen 2: Action Selection
```
Navigation Bar
  - Title: "What would help right now?"
  - No back button (forward only)
  
Action Grid (2x2, 240pt)
  - Talk to AI
    - Icon: chat bubble
    - Label: "Talk to Coach"
    - Sublabel: "Unlimited in panic mode"
    
  - Block Everything
    - Icon: shield
    - Label: "Block Apps"
    - Sublabel: "Choose duration"
    
  - Breathing Exercise
    - Icon: wind/breath
    - Label: "Breathe"
    - Sublabel: "2 minute session"
    
  - Physical Challenge
    - Icon: person.running
    - Label: "Get Moving"
    - Sublabel: "Quick activity"
    
Margin: 24pt all sides (extra spacious)
Gap: 16pt between cards
```

---

### AI Coach Interface

**Layout:**
```
Navigation Bar
  - Title: "Coach"
  - Back button (< Home)
  - Context indicator (if panic mode)
  
Message List (scrollable)
  - Inverted scroll (latest at bottom)
  - Padding: 16pt horizontal
  - Gap: 12pt between messages
  
Message Limit Indicator (conditional)
  - Position: Below nav bar
  - Shows: "2/3 messages today"
  - Color: warning if at limit
  - Only for free tier, not in panic mode
  
Chat Input (fixed bottom)
  - Background: tertiary
  - Height: 44pt (grows to 120pt)
  - Send button: embedded right
  - Margin: 16pt horizontal, 8pt bottom
```

---

### Blocking Management

#### Quick Block Screen
```
Navigation Bar
  - Title: "Quick Block"
  - Cancel (left)
  - Apply (right, emerald)
  
App Selection (scrollable)
  - Section: "Risky Apps" (pre-selected)
  - Section: "All Apps"
  - Row height: 52pt
  - Checkmark for selected
  
Duration Picker (bottom sheet trigger)
  - Current selection displayed
  - Tap to open picker
  
CTA: "Block Now"
  - Full width
  - Bottom 24pt
```

#### Scheduled Block Screen
```
Navigation Bar
  - Title: "Scheduled Blocks"
  - Back (left)
  - Add (right)
  
Block List
  - Card per schedule
  - Shows: days, time, apps, toggle
  - Swipe to delete
  
Empty State
  - Icon + message
  - CTA: "Create Schedule"
```

---

### Analytics & Patterns

#### Calendar View
```
Navigation Bar
  - Title: "Calendar"
  - Date range selector (7/30/90 days)
  
Calendar Grid
  - 7 columns (days of week)
  - Rows for weeks
  - Cell states: clean, relapse, no data
  - Tap cell for detail modal
  
Summary Stats (below calendar)
  - Clean days this period
  - Longest streak
  - Success rate
  
Pattern Insights (conditional, premium)
  - High-risk times graph
  - Trigger frequency chart
  - AI weekly insight
```

---

### Settings Screen

**Layout:**
```
Navigation Bar
  - Title: "Settings"
  - Done (right)
  
Sections (grouped list)
  1. Account
     - Subscription status
     - Manage subscription
     
  2. Notifications
     - Risk time alerts
     - Check-in reminders
     - Quiet hours
     
  3. Blocking
     - Risky apps
     - Shield message
     - Unlock requirements
     
  4. Data & Privacy
     - Export data
     - Delete account
     - Privacy policy
     
  5. Support
     - Help & feedback
     - About
```

---

## 🚫 Anti-Patterns (What NOT to Do)

### Visual Design

❌ **Don't:**
- Use bright or saturated colors for regular UI (overwhelming)
- Use red for relapse data or struggle indicators (judgmental)
- Add decorative gradients (CTAs only)
- Use light backgrounds for main screens (dark-first principle)
- Add shadows to anything except panic button
- Use solid backgrounds for cards (glass material preferred)
- Use decorative illustrations or mascots (serious app)

✅ **Do:**
- Keep UI calm with emerald primary accent
- Use gray for neutral/relapse data (non-judgmental)
- Reserve orange for crisis contexts only
- Maintain dark theme throughout
- Let glass materials provide depth
- Use solid backgrounds only for chat/text input
- Use simple, abstract iconography

---

### Typography

❌ **Don't:**
- Use more than 3 font sizes on one screen
- Mix SF Pro and SF Mono on same text element
- Use font weights below Regular (no Thin/Light)
- Adjust letter spacing on monospace fonts
- Use all caps for body text or long labels
- Use tiny font sizes (<11pt for body text)

✅ **Do:**
- Establish clear hierarchy with 2-3 sizes
- Use SF Mono exclusively for numeric data
- Stick to Regular, Medium, Semibold, Bold weights
- Apply +0.5pt tracking only to uppercase labels
- Use sentence case for most UI text
- Maintain 15pt minimum for readability

---

### Layout & Spacing

❌ **Don't:**
- Pack too much information on crisis screens
- Make tap targets smaller than 44pt
- Put primary CTAs at top of screen (thumb reach)
- Use inconsistent spacing (stick to 4pt grid)
- Create visual clutter with unnecessary containers
- Hide critical actions behind menus or tabs

✅ **Do:**
- Give breathing room, especially in crisis contexts
- Maintain 44pt minimum for all interactive elements
- Place frequent actions in bottom third
- Use 4pt multiples for all spacing
- Remove unnecessary visual containers
- Keep critical actions immediately accessible

---

### Interaction & Animation

❌ **Don't:**
- Use multiple stacked modals (confusing)
- Animate every single state change (overwhelming)
- Use confirmation dialogs for reversible actions
- Ignore Reduce Motion setting
- Use generic error messages ("Something went wrong")
- Add friction to non-destructive actions

✅ **Do:**
- Limit to one modal/sheet at a time
- Animate meaningfully (state changes, feedback)
- Save confirmations for destructive actions only
- Provide non-animated alternatives
- Use specific, helpful error messages
- Make common actions frictionless

---

### Content & Messaging

❌ **Don't:**
- Use judgmental language ("failed", "gave in", "weak")
- Display relapse data in red/error styling
- Gamify recovery (streaks are data, not competition)
- Use triggering imagery or suggestive language
- Write lengthy explanations in frequent views
- Hide behind medical/clinical jargon

✅ **Do:**
- Use neutral, forward-looking language
- Display all data non-judgmentally (grays)
- Treat streaks as progress tracking, not game scores
- Use clinical but clear language for triggers
- Keep UI text minimal and scannable
- Write like a direct, supportive friend

---

### Privacy & Safety

❌ **Don't:**
- Display sensitive data in notifications
- Use obvious app name in public-facing UI
- Make obscure feature hard to access
- Store unencrypted sensitive data
- Make deletion require customer support

✅ **Do:**
- Keep notifications generic ("Time for check-in")
- Use "Anchor" consistently
- Provide quick gesture to obscure (three-finger tap)
- Encrypt all AI conversations and sensitive logs
- Allow full account deletion in-app

---

## 📋 Screen Audit Checklist

Use this to review existing or new screens for consistency:

### Visual Design
- [ ] Dark background (#0A0E14) for screen base
- [ ] Glass material (`.ultraThinMaterial`) for cards
- [ ] Emerald (#10B981) for primary actions
- [ ] Orange (#FF6B35) only for panic button/crisis
- [ ] No blue accents anywhere
- [ ] SF Mono for all numeric data
- [ ] Proper text hierarchy (primary/secondary/tertiary)
- [ ] Corner radius: 16pt cards, 10pt inputs
- [ ] No shadows except panic button

### Typography
- [ ] Font sizes from approved scale
- [ ] Display text 28pt max
- [ ] Body text 15pt minimum
- [ ] Labels 11pt with +0.5pt tracking
- [ ] No more than 3 font sizes visible
- [ ] Line height: 1.5x for body, 1.2x for data

### Spacing
- [ ] Screen margins: 20pt horizontal
- [ ] All spacing uses 4pt grid
- [ ] Generous breathing room (not cramped)
- [ ] Card padding: 16-20pt
- [ ] Section gaps: 24pt minimum
- [ ] Input padding: 12pt vertical minimum

### Interaction
- [ ] All tap targets 44pt minimum
- [ ] Primary CTAs in bottom third
- [ ] Animations on state changes (0.2-0.3s)
- [ ] Haptic feedback on key actions
- [ ] One-handed friendly layout
- [ ] Respects Reduce Motion

### Content
- [ ] Non-judgmental language
- [ ] Clear visual hierarchy
- [ ] Minimal text (scannable in <3 seconds)
- [ ] Numbers prominent (monospace)
- [ ] Empty states handled
- [ ] Loading states clear
- [ ] Error messages specific

### Privacy
- [ ] Sensitive data not in nav titles
- [ ] Generic notification content
- [ ] Quick obscure available (if needed)
- [ ] No triggering imagery
- [ ] Discreet labeling

### Crisis Contexts
- [ ] Extra spaciousness (24pt margins)
- [ ] Large tap targets (crisis = reduced motor control)
- [ ] Clear forward action (no ambiguity)
- [ ] Minimal decision points
- [ ] Orange accent if panic mode active

---

## 📝 Implementation Notes

### SwiftUI Integration

```swift
// Example: Glass card component
struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}

// Usage
GlassCard {
    VStack(alignment: .leading, spacing: 12) {
        Text("Current Streak")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
        
        Text("14")
            .font(.system(size: 48, weight: .semibold, design: .monospaced))
            .foregroundColor(Color(hex: "#10B981"))
    }
}
```

### Color Extensions

```swift
extension Color {
    // Backgrounds
    static let primaryBg = Color(hex: "#0A0E14")
    static let secondaryBg = Color(hex: "#0F1419")
    static let tertiaryBg = Color(hex: "#1C2128")
    static let elevatedBg = Color(hex: "#161B22")
    
    // Accents
    static let emerald = Color(hex: "#10B981")
    static let emeraldLight = Color(hex: "#34D399")
    static let emeraldDark = Color(hex: "#059669")
    static let coralAlert = Color(hex: "#FF6B35")
    
    // Semantic
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#9CA3AF")
    static let textTertiary = Color(hex: "#6B7280")
}
```

### Spacing Constants

```swift
extension CGFloat {
    static let spacingXXS: CGFloat = 4
    static let spacingXS: CGFloat = 8
    static let spacingSM: CGFloat = 12
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 20
    static let spacingXL: CGFloat = 24
    static let spacingXXL: CGFloat = 32
    static let spacingXXXL: CGFloat = 48
}
```

---

## Summary

**Core Characteristics:**
- Dark-first with emerald green primary accent
- Orange reserved exclusively for crisis contexts
- Native iOS glass materials for depth
- SF Mono for all numeric data
- Spacious, calm layouts (not dense)
- One-handed optimization
- Privacy-conscious design
- Non-judgmental data presentation

**Key Differentiators from Fitness Apps:**
- Spaciousness over density (calm, not energetic)
- Emotional state adaptation (crisis mode)
- Privacy-first patterns (quick obscure, discreet UI)
- Non-judgmental relapse handling (gray, not red)
- Intentional friction for protective actions
- Shadow used once (panic button only)

**Technical Approach:**
- 95% native iOS components
- GPU-accelerated glassmorphism
- Automatic dark mode support
- Minimal custom animation code
- Consistent 4pt spacing grid
- Accessibility built-in (VoiceOver, Reduce Motion)

---

## Version History

**v1.0** - Initial NoGoon design system
- Forked from Fitnotes core principles
- Established emerald/orange dual accent system
- Defined crisis interaction patterns
- Created privacy-first components
- Documented spacious layout approach
# UI Design, Particle Systems & Accessibility

This document details the visual attributes, layout measurements, canvas-based particle equations, and accessibility standards implemented in the **Weather Wizard** application.

---

## 1. Liquid Glass Design System

The application implements a premium "Apple Liquid Glass" look, using frosted glass backings that adapt dynamically to background light.

```swift
struct GlassCard<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        content()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(.white.opacity(0.22), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}
```

### Key Elements:
- **Frosted Glass (.ultraThinMaterial)**: Leverages native iOS system blurs to transmit colors from the animated background canvas beneath it.
- **Fine Borders**: A `0.5` pt overlay border with a high transparency white color (`.white.opacity(0.22)`) gives card structures clear boundaries without adding solid outlines.
- **Shadows**: Soft, offset shadow values (`radius: 12, y: 6`) provide depth layers, isolating card content visually from the active background textures.
- **Concentric Gauges**: Rounded gauge outlines match the circular curves of the card bounds, creating a balanced, symmetrical dashboard at the bottom.

---

## 2. Animated Particle System Specifications

Each weather condition maps to a customized rendering sequence inside the Canvas.

| Condition | Base Gradient Colors | Primary Particles / Effects | Animation Mechanics |
| :--- | :--- | :--- | :--- |
| **Sunny** | Deep Sky Blue to Pale Gold | 10 Rotating Sun Rays + 30 Floating Warm Bubbles | Sun rays rotate via `elapsed * speed` offsets. Warm bubbles float upwards with horizontal sine sways. |
| **Cloudy** | Dark Slate Grey to Soft Silver | 3 Parallax Layers of Puffy Clouds | Parallax clouds drift horizontally at layered speeds wrapping around screen bounds. |
| **Rain** | Midnight Navy to Stormy Blue | 120 Angled Rain Streaks + Bottom Fog Mist | Diagonal streaks sweep down steep angles wrapping around bounds. Bottom fog breathes via sine opacity. |
| **Thunder** | Deep Charcoal to Violet Storm | 200 Dense Rain Streaks + Periodic Lightning | Double-bounce full-screen lightning sheet flashes mapped to modulo time intervals. |
| **Snow** | Pale Ice Blue to Frost Grey | 80 Drift Snowflakes in 3 Depth Buckets | Snowflakes sway via horizontal sines. Larger flakes fall faster with higher visual opacity. |
| **Night** | Midnight Black to Deep Violet | 80 Twinkling Star Points + Crescent Moon with Glow | Star clusters pulse opacity using phase frequencies. Moon crescent is offset-masked to show shadows. |

---

## 3. Accessibility & System Optimizations

The application fully integrates iOS Accessibility features:

- **Reduce Motion (`accessibilityReduceMotion`)**: If activated, all timeline animation updates, spring transitions, and canvas particle draws are bypassed, rendering static gradients and instant layouts to save CPU cycles and reduce visual stress.
- **Dynamic Type**: Text sizes scale dynamically using system rounded font designs.
- **High Contrast Contrast (`colorSchemeContrast`)**: When contrast settings are increased, progress card gauges increase stroke boundaries from `4.5` pt to `5.5` pt automatically for high readability.
- **Screen Reader (VoiceOver)**: Card values are read as localized descriptions rather than raw numbers (e.g., "Air Quality Index: 42, Good").

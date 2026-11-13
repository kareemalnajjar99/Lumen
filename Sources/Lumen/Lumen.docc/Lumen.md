# ``Lumen``

Metal-powered effects for SwiftUI, each one a single line to add.

## Overview

Lumen draws its effects with GPU shaders, so they stay smooth on content of any size. Add one to any view:

```swift
import Lumen
import SwiftUI

struct MembershipCard: View {
    var body: some View {
        CardArtwork()
            .holographic()
    }
}
```

### Holographic foil

`holographic(style:follows:)` lays an iridescent foil over a view. The foil follows the user's drag and the tilt of the device, and dragging also leans the view in 3D. Pass a ``HolographicStyle`` to change how strong the foil is, and a ``TiltSource`` to choose what it follows.

To light the foil yourself, pass a ``Tilt`` to `holographic(tilt:style:)`. A tilt is animatable, so the foil follows any animation you apply to it:

```swift
struct MembershipCard: View {
    @State private var tilt = Tilt.neutral

    var body: some View {
        CardArtwork()
            .holographic(tilt: tilt, style: .prismatic)
            .tiltable($tilt)
    }
}
```

### Ripples

`ripple(style:)` sends a wave across a view from wherever the user taps it. Waves overlap, so quick taps build on each other. To start a wave from code, use `ripple(at:trigger:style:)`, which fires whenever its trigger value changes. A ``RippleStyle`` sets the size and speed of the wave.

```swift
PhotoView()
    .ripple(at: heartCenter, trigger: likeCount, style: .shockwave)
```

### Liquid transition

``LiquidTransition`` pours a view in from one edge behind a wavy surface and drains it back out. Use it like any other transition:

```swift
if isUnlocked {
    RewardCard()
        .transition(.liquid)
}
```

### Accessibility

Every effect follows the system's Reduce Motion setting. The holographic foil stops leaning the view and ignores device motion, ripples leave the view still, and the liquid transition becomes a cross-fade.

## Topics

### Holographic foil

- ``HolographicStyle``
- ``Tilt``
- ``TiltSource``

### Ripples

- ``RippleStyle``

### Liquid transition

- ``LiquidTransition``

import SwiftUI

struct ParticleSeed {
    let xMultiplier: Double
    let yMultiplier: Double
    let speed: Double
    let scale: Double
    let opacity: Double
    let phase: Double
    let frequency: Double
}

struct AnimatedBackgroundView: View {
    let condition: WeatherCondition
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    // Seed arrays generated once at class load time to avoid allocation in draw loop
    private static let sunnyParticles: [ParticleSeed] = (0..<30).map { _ in
        ParticleSeed(
            xMultiplier: Double.random(in: 0...1),
            yMultiplier: Double.random(in: 0...1),
            speed: Double.random(in: 15...35),
            scale: Double.random(in: 2...5),
            opacity: Double.random(in: 0.05...0.12),
            phase: Double.random(in: 0...(.pi * 2)),
            frequency: Double.random(in: 0.2...0.5)
        )
    }
    
    private static let cloudLayers: [[ParticleSeed]] = (0..<3).map { layer in
        let count = 5
        return (0..<count).map { index in
            ParticleSeed(
                xMultiplier: Double(index) / Double(count),
                yMultiplier: 0.15 + Double(layer) * 0.15 + Double.random(in: -0.05...0.05),
                speed: Double.random(in: 4...10) * (Double(layer) + 0.5),
                scale: Double.random(in: 120...240),
                opacity: layer == 0 ? 0.35 : (layer == 1 ? 0.20 : 0.12),
                phase: Double.random(in: 0...(.pi * 2)),
                frequency: Double.random(in: 0.05...0.15)
            )
        }
    }
    
    private static let rainParticles: [ParticleSeed] = (0..<120).map { _ in
        ParticleSeed(
            xMultiplier: Double.random(in: 0...1),
            yMultiplier: Double.random(in: -0.1...1),
            speed: Double.random(in: 600...900),
            scale: Double.random(in: 15...30),
            opacity: Double.random(in: 0.2...0.4),
            phase: 0,
            frequency: 0
        )
    }
    
    private static let thunderParticles: [ParticleSeed] = (0..<200).map { _ in
        ParticleSeed(
            xMultiplier: Double.random(in: 0...1),
            yMultiplier: Double.random(in: -0.1...1),
            speed: Double.random(in: 700...1100),
            scale: Double.random(in: 18...35),
            opacity: Double.random(in: 0.25...0.45),
            phase: 0,
            frequency: 0
        )
    }
    
    private static let snowParticles: [ParticleSeed] = (0..<80).map { _ in
        let bucket = Int.random(in: 0...2)
        let speed = bucket == 0 ? Double.random(in: 25...45) : (bucket == 1 ? Double.random(in: 45...75) : Double.random(in: 75...110))
        let scale = bucket == 0 ? Double.random(in: 1.5...3.0) : (bucket == 1 ? Double.random(in: 3.0...5.0) : Double.random(in: 5.0...7.0))
        let opacity = bucket == 0 ? Double.random(in: 0.3...0.5) : (bucket == 1 ? Double.random(in: 0.5...0.7) : Double.random(in: 0.7...0.9))
        return ParticleSeed(
            xMultiplier: Double.random(in: 0...1),
            yMultiplier: Double.random(in: -0.1...1),
            speed: speed,
            scale: scale,
            opacity: opacity,
            phase: Double.random(in: 0...(.pi * 2)),
            frequency: Double.random(in: 0.4...1.2)
        )
    }
    
    private static let nightStars: [ParticleSeed] = (0..<80).map { _ in
        ParticleSeed(
            xMultiplier: Double.random(in: 0...1),
            yMultiplier: Double.random(in: 0...0.7),
            speed: 0,
            scale: Double.random(in: 1.0...2.2),
            opacity: Double.random(in: 0.3...0.75),
            phase: Double.random(in: 0...(.pi * 2)),
            frequency: Double.random(in: 0.5...1.8)
        )
    }
    
    private static let nightClouds: [ParticleSeed] = (0..<3).map { index in
        ParticleSeed(
            xMultiplier: Double(index) / 3.0,
            yMultiplier: Double.random(in: 0.1...0.35),
            speed: Double.random(in: 2...5),
            scale: Double.random(in: 140...250),
            opacity: 0.08,
            phase: Double.random(in: 0...(.pi * 2)),
            frequency: Double.random(in: 0.02...0.06)
        )
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            if !reduceMotion {
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        drawParticles(in: &context, size: size, date: timeline.date)
                    }
                }
                .accessibilityHidden(true)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Gradient Selection
    private var backgroundGradient: some View {
        let colors: [Color]
        switch condition {
        case .sunny:
            colors = [
                Color(red: 0.0, green: 0.45, blue: 0.85),  // Rich Sky Blue
                Color(red: 1.0, green: 0.80, blue: 0.50)   // Warm Gold
            ]
        case .cloudy:
            colors = [
                Color(red: 0.40, green: 0.46, blue: 0.55),  // Dark Slate
                Color(red: 0.65, green: 0.67, blue: 0.70)   // Soft Grey
            ]
        case .rain:
            colors = [
                Color(red: 0.06, green: 0.08, blue: 0.16),  // Deep Navy Black
                Color(red: 0.10, green: 0.16, blue: 0.28)   // Stormy Slate Blue
            ]
        case .thunderstorm:
            colors = [
                Color(red: 0.03, green: 0.04, blue: 0.08),  // Near Black
                Color(red: 0.08, green: 0.08, blue: 0.18)   // Deep Purple Storm
            ]
        case .snow:
            colors = [
                Color(red: 0.82, green: 0.88, blue: 0.93),  // Pale Ice Blue
                Color(red: 0.60, green: 0.72, blue: 0.82)   // Soft Frost
            ]
        case .night:
            colors = [
                Color(red: 0.02, green: 0.02, blue: 0.08),  // Midnight Black
                Color(red: 0.08, green: 0.05, blue: 0.16)   // Deep Violet Glow
            ]
        }
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Particle Engine Dispatch
    private func drawParticles(in context: inout GraphicsContext, size: CGSize, date: Date) {
        let elapsed = date.timeIntervalSinceReferenceDate
        
        switch condition {
        case .sunny:
            drawSunnyEffects(in: &context, size: size, elapsed: elapsed)
        case .cloudy:
            drawCloudyEffects(in: &context, size: size, elapsed: elapsed)
        case .rain:
            drawRainEffects(in: &context, size: size, elapsed: elapsed, denser: false)
        case .thunderstorm:
            drawRainEffects(in: &context, size: size, elapsed: elapsed, denser: true)
            drawLightningFlash(in: &context, size: size, elapsed: elapsed)
        case .snow:
            drawSnowEffects(in: &context, size: size, elapsed: elapsed)
        case .night:
            drawNightEffects(in: &context, size: size, elapsed: elapsed)
        }
    }
    
    // MARK: - Sunny Render
    private func drawSunnyEffects(in context: inout GraphicsContext, size: CGSize, elapsed: Double) {
        // 1. Draw central warm sun glow
        let glowCenter = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        let glowRadius = size.width * 0.45
        context.drawLayer { layerContext in
            let path = Path(circleWithCenter: glowCenter, radius: glowRadius)
            layerContext.fill(
                path,
                with: .radialGradient(
                    Gradient(colors: [Color.yellow.opacity(0.12), Color.clear]),
                    center: glowCenter,
                    startRadius: 0,
                    endRadius: glowRadius
                )
            )
        }
        
        // 2. Draw rotating sun rays
        let rayCount = 10
        let rayRotationSpeed = 0.06 // radians per second
        let angleOffset = elapsed * rayRotationSpeed
        
        context.drawLayer { layerContext in
            for i in 0..<rayCount {
                let rayAngle = (Double(i) * (.pi * 2.0 / Double(rayCount))) + angleOffset
                var rayPath = Path()
                
                // Draw a thin triangle ray
                rayPath.move(to: glowCenter)
                let length = size.height * 0.65
                let widthOffset = 0.06 // width of ray in radians
                
                let p1 = CGPoint(
                    x: glowCenter.x + cos(rayAngle - widthOffset) * length,
                    y: glowCenter.y + sin(rayAngle - widthOffset) * length
                )
                let p2 = CGPoint(
                    x: glowCenter.x + cos(rayAngle + widthOffset) * length,
                    y: glowCenter.y + sin(rayAngle + widthOffset) * length
                )
                
                rayPath.addLine(to: p1)
                rayPath.addLine(to: p2)
                rayPath.closeSubpath()
                
                let breathingOpacity = 0.07 + 0.04 * sin(elapsed * 0.4 + Double(i))
                layerContext.fill(rayPath, with: .color(Color.white.opacity(breathingOpacity)))
            }
        }
        
        // 3. Draw warm floating particles
        for p in Self.sunnyParticles {
            let startX = p.xMultiplier * size.width
            let startY = p.yMultiplier * size.height
            
            // Float upward and wrap
            let yOffset = (elapsed * p.speed).truncatingRemainder(dividingBy: size.height + 50)
            let currentY = startY - yOffset
            let resolvedY = currentY < -20 ? currentY + size.height + 50 : currentY
            
            // Sway horizontally
            let currentX = startX + sin(elapsed * p.frequency + p.phase) * 15.0
            
            let circlePath = Path(ellipseIn: CGRect(
                x: currentX,
                y: resolvedY,
                width: p.scale,
                height: p.scale
            ))
            context.fill(circlePath, with: .color(Color.white.opacity(p.opacity)))
        }
    }
    
    // MARK: - Cloudy Render
    private func drawCloudyEffects(in context: inout GraphicsContext, size: CGSize, elapsed: Double) {
        for (layerIndex, layer) in Self.cloudLayers.enumerated() {
            context.drawLayer { layerContext in
                for cloud in layer {
                    // Parallax slow movement
                    let rawX = cloud.xMultiplier * size.width + (elapsed * cloud.speed)
                    let cloudX = rawX.truncatingRemainder(dividingBy: size.width + cloud.scale * 2) - cloud.scale
                    
                    let swayY = sin(elapsed * cloud.frequency + cloud.phase) * 10.0
                    let cloudY = cloud.yMultiplier * size.height + swayY
                    
                    // Draw a puffy cloud shape (overlapping ellipses)
                    let cloudRect = CGRect(
                        x: cloudX,
                        y: cloudY,
                        width: cloud.scale,
                        height: cloud.scale * 0.55
                    )
                    
                    let p = Path(ellipseIn: cloudRect)
                    let shadowShift = Double(layerIndex + 1) * 2.5
                    
                    // Subtle cloud self-shadow for glass depth
                    layerContext.fill(
                        p.offsetBy(dx: 0, dy: shadowShift),
                        with: .color(Color.black.opacity(0.04))
                    )
                    layerContext.fill(
                        p,
                        with: .color(Color.white.opacity(cloud.opacity))
                    )
                }
            }
        }
    }
    
    // MARK: - Rain Render (Rain & Thunder)
    private func drawRainEffects(in context: inout GraphicsContext, size: CGSize, elapsed: Double, denser: Bool) {
        let particles = denser ? Self.thunderParticles : Self.rainParticles
        let rainAngle = 76.0 * (.pi / 180.0) // 76 degree steep fall angle
        
        context.drawLayer { layerContext in
            for r in particles {
                let startX = r.xMultiplier * size.width
                let startY = r.yMultiplier * size.height
                
                // Fall downwards along the angle
                let distance = (elapsed * r.speed).truncatingRemainder(dividingBy: size.height + 100)
                let currentY = startY + distance
                let resolvedY = currentY > size.height + 20 ? currentY - (size.height + 120) : currentY
                
                // Angle calculation: deltaX = deltaY / tan(angle)
                let currentX = (startX + distance / tan(rainAngle)).truncatingRemainder(dividingBy: size.width + 50) - 25
                
                var path = Path()
                path.move(to: CGPoint(x: currentX, y: resolvedY))
                let endPoint = CGPoint(
                    x: currentX + cos(rainAngle) * r.scale,
                    y: resolvedY + sin(rainAngle) * r.scale
                )
                path.addLine(to: endPoint)
                
                layerContext.stroke(
                    path,
                    with: .color(Color.white.opacity(r.opacity)),
                    style: StrokeStyle(lineWidth: 0.65, lineCap: .round)
                )
            }
        }
        
        // Mist breathing effect at the bottom
        let breath = 0.05 + 0.015 * sin(elapsed * 0.8)
        let bottomRect = CGRect(x: 0, y: size.height * 0.75, width: size.width, height: size.height * 0.25)
        context.fill(
            Path(bottomRect),
            with: .linearGradient(
                Gradient(colors: [Color.clear, Color.white.opacity(breath)]),
                startPoint: CGPoint(x: 0, y: size.height * 0.75),
                endPoint: CGPoint(x: 0, y: size.height)
            )
        )
        
        // Subtle horizontal glass reflection line
        let reflectionY = size.height * 0.6
        let shimmerX = (size.width * 0.25) + sin(elapsed * 0.15) * (size.width * 0.2)
        var reflectionPath = Path()
        reflectionPath.move(to: CGPoint(x: shimmerX - 60, y: reflectionY))
        reflectionPath.addLine(to: CGPoint(x: shimmerX + 60, y: reflectionY))
        context.stroke(
            reflectionPath,
            with: .linearGradient(
                Gradient(colors: [Color.clear, Color.white.opacity(0.04), Color.clear]),
                startPoint: CGPoint(x: shimmerX - 60, y: reflectionY),
                endPoint: CGPoint(x: shimmerX + 60, y: reflectionY)
            ),
            style: StrokeStyle(lineWidth: 1.0)
        )
    }
    
    // MARK: - Thunderstorm Lightning Flash
    private func drawLightningFlash(in context: inout GraphicsContext, size: CGSize, elapsed: Double) {
        let cycle = elapsed.truncatingRemainder(dividingBy: 9.5)
        var lightningOpacity: Double = 0
        
        if cycle < 0.12 {
            // Main lightning bolt strike flash
            lightningOpacity = (1.0 - (cycle / 0.12)) * 0.36
        } else if cycle > 0.16 && cycle < 0.25 {
            // Secondary bounce flash
            lightningOpacity = (1.0 - ((cycle - 0.16) / 0.09)) * 0.24
        } else if cycle > 4.5 && cycle < 4.6 {
            // Light background sheet flash
            lightningOpacity = 0.08
        }
        
        if lightningOpacity > 0.01 {
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(Color.white.opacity(lightningOpacity))
            )
        }
    }
    
    // MARK: - Snow Render
    private func drawSnowEffects(in context: inout GraphicsContext, size: CGSize, elapsed: Double) {
        for s in Self.snowParticles {
            let startX = s.xMultiplier * size.width
            let startY = s.yMultiplier * size.height
            
            // Fall downwards
            let distance = (elapsed * s.speed).truncatingRemainder(dividingBy: size.height + 40)
            let currentY = startY + distance
            let resolvedY = currentY > size.height + 10 ? currentY - (size.height + 50) : currentY
            
            // Sway back and forth using sine
            let sway = sin(elapsed * s.frequency + s.phase) * 16.0
            let currentX = (startX + sway).truncatingRemainder(dividingBy: size.width + 40) - 20
            
            let snowPath = Path(ellipseIn: CGRect(
                x: currentX,
                y: resolvedY,
                width: s.scale,
                height: s.scale
            ))
            context.fill(snowPath, with: .color(Color.white.opacity(s.opacity)))
        }
    }
    
    // MARK: - Night Render
    private func drawNightEffects(in context: inout GraphicsContext, size: CGSize, elapsed: Double) {
        // 1. Twinkling stars
        for star in Self.nightStars {
            let x = star.xMultiplier * size.width
            let y = star.yMultiplier * size.height
            
            let pulse = 0.35 + 0.35 * sin(elapsed * star.frequency + star.phase)
            let currentOpacity = star.opacity * pulse
            
            let path = Path(ellipseIn: CGRect(x: x, y: y, width: star.scale, height: star.scale))
            context.fill(path, with: .color(Color.white.opacity(currentOpacity)))
        }
        
        // 2. Glowing Moon
        let moonCenter = CGPoint(x: size.width * 0.8, y: size.height * 0.18)
        let moonRadius = 24.0
        
        // Outer crescent moon glow
        context.drawLayer { layerContext in
            let glowPath = Path(circleWithCenter: moonCenter, radius: moonRadius + 14)
            layerContext.fill(
                glowPath,
                with: .radialGradient(
                    Gradient(colors: [Color(red: 0.99, green: 0.98, blue: 0.88).opacity(0.15), Color.clear]),
                    center: moonCenter,
                    startRadius: 0,
                    endRadius: moonRadius + 14
                )
            )
        }
        
        // Solid moon circle
        context.fill(
            Path(circleWithCenter: moonCenter, radius: moonRadius),
            with: .color(Color(red: 0.98, green: 0.96, blue: 0.85))
        )
        
        // Subtly cut moon crescent (draw dark circle offset)
        let shadowCenter = CGPoint(x: moonCenter.x - 8, y: moonCenter.y - 4)
        context.fill(
            Path(circleWithCenter: shadowCenter, radius: moonRadius),
            with: .color(Color(red: 0.02, green: 0.02, blue: 0.08)) // Match deep midnight gradient top color
        )
        
        // 3. Slow-moving dark night clouds
        context.drawLayer { layerContext in
            for cloud in Self.nightClouds {
                let rawX = cloud.xMultiplier * size.width + (elapsed * cloud.speed)
                let cloudX = rawX.truncatingRemainder(dividingBy: size.width + cloud.scale * 2) - cloud.scale
                let cloudY = cloud.yMultiplier * size.height
                
                let cloudRect = CGRect(x: cloudX, y: cloudY, width: cloud.scale, height: cloud.scale * 0.5)
                layerContext.fill(
                    Path(ellipseIn: cloudRect),
                    with: .color(Color.white.opacity(cloud.opacity))
                )
            }
        }
    }
}

// Helper path extensions
extension Path {
    init(circleWithCenter center: CGPoint, radius: CGFloat) {
        self.init(ellipseIn: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}

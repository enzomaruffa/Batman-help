//
//  HapticManager.swift
//  BatmanHelp
//
//  Created by Enzo Maruffa Moreira on 15/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import CoreHaptics

class HapticManager {
    
    static let shared = HapticManager()
    
    var engine: CHHapticEngine?
    
    private func checkAvailability() -> Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    private init() {
        guard checkAvailability() else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }

        engine?.stoppedHandler = { reason in
            print("The engine stopped: \(reason)")
        }

        // If something goes wrong, attempt to restart the engine immediately
        engine?.resetHandler = { [weak self] in
            print("The engine reset")
            do {
                try self?.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
        
    }
    
    func sampleTap() {
        guard checkAvailability() else { return }
        
        var events = [CHHapticEvent]()

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func playMenuToggle(withDuration duration: Double, opening: Bool) {
        var intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        var sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let openEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
        
        let closeEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: duration)
        
        var events = [openEvent, closeEvent]
        
        if !opening {
            events.reverse()
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func playSelection() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        let events = [event]
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func playAlert(count: Int) {
        
        var events = [CHHapticEvent]()
        
        for i in 0..<count {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.15 * Double(i), duration: 0.2)
            
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

import Foundation
import Testing
@testable import MorseTap

@MainActor
struct MorseInputEngineTests {
    
    // MARK: - Signal Classification
    
    @Test func shortPressBecomesDot() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.1))
        
        #expect(engine.currentSignals == [.dot])
    }
    
    @Test func longPressBecomesDash() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.3))
        
        #expect(engine.currentSignals == [.dash])
    }
    
    @Test func exactThresholdBecomesDash() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.2))
        
        #expect(engine.currentSignals == [.dash])
    }
    
    @Test func justUnderThresholdBecomesDot() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.19))
        
        #expect(engine.currentSignals == [.dot])
    }
    
    // MARK: - Multiple Signals
    
    @Test func multipleSignalsAccumulate() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        // First signal: dot
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.1))
        
        // Second signal: dash
        engine.pressDown(at: now.addingTimeInterval(0.15))
        engine.pressUp(at: now.addingTimeInterval(0.45))
        
        // Third signal: dot
        engine.pressDown(at: now.addingTimeInterval(0.5))
        engine.pressUp(at: now.addingTimeInterval(0.6))
        
        #expect(engine.currentSignals == [.dot, .dash, .dot])
    }
    
    // MARK: - Symbol Completion
    
    @Test func symbolCompletesAfterPause() async {
        let engine = MorseInputEngine()
        engine.config.symbolPauseDuration = 0.1
        
        var completedSignals: [MorseSignal]?
        engine.onSymbolCompleted = { signals in
            completedSignals = signals
        }
        
        let now = Date()
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.05))
        
        #expect(engine.currentSignals == [.dot])
        
        try? await Task.sleep(for: .milliseconds(150))
        
        #expect(completedSignals == [.dot])
        #expect(engine.currentSignals.isEmpty)
    }
    
    @Test func newPressCancelsPendingCompletion() async {
        let engine = MorseInputEngine()
        engine.config.symbolPauseDuration = 0.15
        
        var completionCalled = false
        engine.onSymbolCompleted = { _ in
            completionCalled = true
        }
        
        let now = Date()
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.05))
        
        try? await Task.sleep(for: .milliseconds(50))
        
        engine.pressDown(at: now.addingTimeInterval(0.1))
        engine.pressUp(at: now.addingTimeInterval(0.15))
        
        try? await Task.sleep(for: .milliseconds(200))
        
        #expect(completionCalled == true)
        #expect(engine.currentSignals.isEmpty)
    }
    
    // MARK: - Reset
    
    @Test func resetClearsSignals() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.1))
        
        #expect(engine.currentSignals == [.dot])
        
        engine.reset()
        
        #expect(engine.currentSignals.isEmpty)
    }
    
    @Test func resetCancelsPendingCompletion() async {
        let engine = MorseInputEngine()
        engine.config.symbolPauseDuration = 0.1
        
        var completionCalled = false
        engine.onSymbolCompleted = { _ in
            completionCalled = true
        }
        
        let now = Date()
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.05))
        
        engine.reset()
        
        try? await Task.sleep(for: .milliseconds(150))
        
        #expect(completionCalled == false)
    }
    
    // MARK: - Delete Last Signal
    
    @Test func deleteLastSignalRemovesLast() async {
        let engine = MorseInputEngine()
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.1))
        
        engine.pressDown(at: now.addingTimeInterval(0.15))
        engine.pressUp(at: now.addingTimeInterval(0.45))
        
        #expect(engine.currentSignals == [.dot, .dash])
        
        engine.deleteLastSignal()
        
        #expect(engine.currentSignals == [.dot])
    }
    
    @Test func deleteLastSignalOnEmptyDoesNothing() async {
        let engine = MorseInputEngine()
        
        engine.deleteLastSignal()
        
        #expect(engine.currentSignals.isEmpty)
    }
    
    @Test func deleteAllSignalsCancelsPendingCompletion() async {
        let engine = MorseInputEngine()
        engine.config.symbolPauseDuration = 0.1
        
        var completionCalled = false
        engine.onSymbolCompleted = { _ in
            completionCalled = true
        }
        
        let now = Date()
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.05))
        
        engine.deleteLastSignal()
        
        try? await Task.sleep(for: .milliseconds(150))
        
        #expect(completionCalled == false)
    }
    
    // MARK: - Configuration
    
    @Test func customConfigurationAffectsClassification() async {
        let engine = MorseInputEngine()
        engine.config = MorseTimingConfig(
            dotMaxDuration: 0.5,
            dashMinDuration: 0.5,
            symbolPauseDuration: 1.0
        )
        
        let now = Date()
        
        engine.pressDown(at: now)
        engine.pressUp(at: now.addingTimeInterval(0.4))
        
        #expect(engine.currentSignals == [.dot])
        
        engine.pressDown(at: now.addingTimeInterval(0.5))
        engine.pressUp(at: now.addingTimeInterval(1.1))
        
        #expect(engine.currentSignals == [.dot, .dash])
    }
    
    // MARK: - Press Without Release
    
    @Test func pressUpWithoutPressDownIsIgnored() async {
        let engine = MorseInputEngine()
        
        engine.pressUp(at: Date())
        
        #expect(engine.currentSignals.isEmpty)
    }
}

//
//  PhotoEditorChallengeTests.swift
//  PhotoEditorChallengeTests
//
//  Created by Ramar Parham on 10/14/24.
//

import Testing
@testable import PhotoEditorChallenge

struct PhotoEditorChallengeTests {


        @Test func testAdjustmentValuesAreValid() async throws {
            let adjustments = AdjustmentValues()

            // Check that all adjustment values are within expected range
            #expect(adjustments.exposure >= -100 && adjustments.exposure <= 100)
            #expect(adjustments.brilliance >= -100 && adjustments.brilliance <= 100)
            #expect(adjustments.highlights >= -100 && adjustments.highlights <= 100)
            #expect(adjustments.shadows >= -100 && adjustments.shadows <= 100)
            #expect(adjustments.contrast >= -100 && adjustments.contrast <= 100)
            #expect(adjustments.brightness >= -100 && adjustments.brightness <= 100)
            #expect(adjustments.blackPoint >= -100 && adjustments.blackPoint <= 100)
            #expect(adjustments.saturation >= -100 && adjustments.saturation <= 100)
            #expect(adjustments.vibrance >= -100 && adjustments.vibrance <= 100)
            #expect(adjustments.warmth >= -100 && adjustments.warmth <= 100)
            #expect(adjustments.tint >= -100 && adjustments.tint <= 100)
        }
}

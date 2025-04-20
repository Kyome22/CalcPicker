//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Takuto Nakamura on 2025/04/20.
//

import XCTest

final class ExampleUITests: XCTestCase {
    @MainActor
    func testHappyPass() async throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["openCalcPickerButton"].wait(for: \.isHittable, toEqual: true).tap()

        let calcPicker = app.otherElements["calcPicker"].wait(for: \.exists, toEqual: true)

        // 12.3 % 4 * 5 ± / 6 + 7 = close
        calcPicker.buttons["number1Button"].tap()
        calcPicker.buttons["number2Button"].tap()
        calcPicker.buttons["periodButton"].tap()
        calcPicker.buttons["number3Button"].tap()
        calcPicker.buttons["modulusButton"].tap()
        calcPicker.buttons["number4Button"].tap()
        calcPicker.buttons["multiplicationButton"].tap()
        calcPicker.buttons["number5Button"].tap()
        calcPicker.buttons["plusMinusButton"].tap()
        calcPicker.buttons["divisionButton"].tap()
        calcPicker.buttons["number6Button"].tap()
        calcPicker.buttons["additionButton"].tap()
        calcPicker.buttons["number7Button"].tap()
        calcPicker.buttons["calculateButton"].tap()

        try await Task.sleep(for: .seconds(1.5))

        calcPicker.buttons["completeButton"].tap()
    }
}

extension XCUIElement {
    @MainActor
    func wait<V>(
        for keyPath: KeyPath<XCUIElement, V>,
        toEqual expectedValue: V,
        timeout: TimeInterval = 5.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self where V: Equatable {
        XCTAssertTrue(wait(for: keyPath, toEqual: expectedValue, timeout: timeout), file: file, line: line)
        return self
    }
}

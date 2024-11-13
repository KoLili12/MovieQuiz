//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Николай Жирнов on 04.11.2024.
//

import XCTest

import XCTest // не забывайте импортировать фреймворк для тестирования
@testable import MovieQuiz // импортируем наше приложение для тестирования

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}
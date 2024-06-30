//
//  Constant.swift
//  Daily
//
//  Created by 최승용 on 2022/12/21.
//

import Foundation

// MARK: - about Calendar
let marginRange = 3
let listSize = marginRange * 2 + 1

// MARK: - about Record
func contentOfGoalHintText(type: String) -> String {
    switch type {
    case "check":
        return "아침 7시에 일어나기 ☀️"
    case "count":
        return "물 2잔 이상 마시기 🚰"
    default:
        return "자기 전 30분 책 읽기 📖"
    }
}
let contentLengthAlertTitleText: String = "목표의 길이가 너무 짧아요 😵"
let contentLengthAlertMessageText: String = "최소 2글자 이상의 목표를 설정해주세요"
let countRangeAlertTitleText: String = "목표 횟수 범위를 벗어났어요 😵‍💫"
let countRangeAlertMessageText: String = "1 ~ 10회의 목표를 설정해주세요"
func wrongDateAlertTitleText(type: String) -> String {
    switch type {
    case "wrongDateRange":
        return "날짜 범위가 잘못 되었어요 🤯"
    case "emptySelectedWOD":
        return "아직 반복 요일을 설정하지 않았어요 🧐"
    default:
        return "선택한 요일이 날짜 범위 안에 없어요 🫠"
    }
}
func wrongDateAlertMessageText(type: String) -> String {
    switch type {
    case "wrongDateRange":
        return "종료일은 시작일 이후로 설정해주세요"
    case "emptySelectedWOD":
        return "반복 요일을 먼저 설정해주세요"
    default:
        return "날짜 범위를 늘리거나 요일을 다시 설정해주세요"
    }
}
let noRecordText: String = "아직 목표가 없어요 😓"
let goRecordViewText: String = "목표 세우러 가기"

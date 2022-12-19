//
//  MenuOnList.swift
//  Daily
//
//  Created by 최승용 on 2022/11/25.
//

import SwiftUI

struct MenuOnList: View {
    @StateObject var userInfo: UserInfo
    let menu: String
    var body: some View {
        HStack {
            Text(menu)
            Spacer()
            if menu == "언어" {
                let options = ["한국어", "영어"]
                Picker("", selection: $userInfo.language) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(2)
                .frame(width: 150)
            }
            if menu == "일주일 시작 요일" {
                let options = userInfo.language == "한국어" ? ["일", "월"] : ["Sun", "Mon"]
                Picker("", selection: $userInfo.startDay) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(2)
                .frame(width: 150)
            }
            if menu == "목표 수행일 선택 방식" {
                let options = ["날짜", "반복"]
                Picker("", selection: $userInfo.dateOrRepeat) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(2)
                .frame(width: 150)
            }
            if menu == "기본 달력" {
                let options = ["년", "월", "주"]
                Picker("", selection: $userInfo.calendarState) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(2)
                .frame(width: 150)
            }
        }
    }
}

//
//  NoticeSheet.swift
//  Daily
//
//  Created by 최승용 on 7/20/24.
//

import SwiftUI

struct NoticeSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: CGFloat.fontSize * 3) {
            Text("🚨 24.07.19. 서버 다운 및 데이터 유실 공지")
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .hCenter()
                Text("[Daily - 매일 매일 일정 관리] 사용자 여러분들.. 😥\n2024년 7월 19일경 서버가 다운되었습니다.\n최대한 빠른 시일 내로 서버를 복구하고자 하였으나 이용에 불편을 드려 정말 죄송합니다.. 😭\n더불어 복구 중에 여러분들의 소중한 반복 설정 목표와 날짜 변경 히스토리, 그리고 목표 달성 횟수 등 일부 데이터과 로그들이 유실되었습니다.\n정확한 원인을 파악하고 예방 조치를 추가하여 다시는 이런 일이 없도록 하겠습니다. 🙇🙇\n혹시 복구가 꼭 필요한 데이터가 있다면 아래 메일로 연락 부탁드립니다.\n다시 한 번 진심으로 죄송합니다. 감사합니다.\n\n 📪: chadange@naver.com")
                    .font(.system(size: CGFloat.fontSize * 2))
                    .hLeading()
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("확인")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .tint(Colors.daily)
        .accentColor(Colors.daily)
    }
}

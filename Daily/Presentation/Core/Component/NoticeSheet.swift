//
//  NoticeSheet.swift
//  Daily
//
//  Created by 최승용 on 7/20/24.
//

import SwiftUI

struct NoticeSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var height: CGFloat
    
    var body: some View {
        // TODO: 추후 디자인 수정
        VStack(spacing: 30) {
            Text("🚨 [Daily - 매일 매일 일정 관리]\n-> [Daily Scheduler] 업데이트 안내")
                .font(Fonts.headingLgBold)
                .foregroundStyle(Colors.Text.primary)
                .hCenter()
            Text("안녕하세요 [Daily - 매일 매일 일정 관리] 사용자분들 ☺️\n2025년을 맞아 Daily가 2.0.0으로 거대 업데이트를 진행하였습니다.\n많은 변화가 있었지만 가장 큰 변화는 더 이상 외부 서버에 데이터를 저장하지 않게되었습니다! 😎\n여러분의 일상이 더 안전해졌다는 의미이며, 앱 사용성이 훨씬 개선되었다는 의미인데요!! 🎉🎉\n다만 구조상 이전 서버의 데이터들은 옮겨 넣을 수가 없습니다.\n데이터 확인을 원하시면 아래 메일로 연락 부탁드립니다.\n앞으로는 더 많은 업데이트를 통해 자주 찾아뵙겠습니다. 감사합니다.🙏🙏\n\n 📪: chadange@naver.com")
                .font(Fonts.bodyMdSemiBold)
                .foregroundStyle(Colors.Text.primary)
                .lineSpacing(5)
                .hLeading()
        }
        .overlay {
            Button { dismiss() } label: { Text("확인") }
                .buttonStyle(.borderedProminent).hTrailing().vBottom()
        }
        .padding()
        .tint(Colors.Brand.primary)
        .accentColor(Colors.Brand.primary)
        .background(
            GeometryReader { sheet in
                Color.clear
                    .onAppear { height = sheet.size.height }
                    .onChange(of: sheet.size.height) { height = $1 }
            }
        )
    }
}

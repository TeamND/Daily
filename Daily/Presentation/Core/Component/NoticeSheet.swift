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
    
    let notice: NoticeModel
    
    var body: some View {
        // TODO: 추후 텍스트 타입 추가 및 시트 여러개 케이스 확장
        VStack(spacing: .zero) {
            Image(notice.image ?? "")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            HStack {
                Button {
                    UserDefaultManager.ignoreNoticeDate = Date(format: .daily).dayLater(value: 7)
                    dismiss()
                } label: {
                    Text("일주일 동안 보지 않기")
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.secondary)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("닫기")
                        .font(Fonts.bodyLgSemiBold)
                        .foregroundStyle(Colors.Text.secondary)
                }
            }
            .padding(16)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(
            GeometryReader { sheet in
                Colors.Background.primary
                    .ignoresSafeArea()
                    .onAppear { height = sheet.size.height }
                    .onChange(of: sheet.size.height) { height = $1 }
                    .padding(-100)  // MARK: 사용자 인터랙션(시트 끌어올림)에 대응
            }
        )
    }
}

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
            Button {
                dismiss()
            } label: {
                Image(.close)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .hTrailing()
            .padding(16)
            
            Image(notice.image ?? "")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Spacer().frame(height: 16)
            
            Button {
                print("test")
                System().openAppStore()
            } label: {
                Text("update_now".localized)
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Background.fixed)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .background(Colors.Brand.primary)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            
            Spacer().frame(height: 8)
            
            Button {
                UserDefaultManager.ignoreNoticeDate = Date(format: .daily).dayLater(value: 7)
                dismiss()
            } label: {
                Text("do_not_show_again_for_7_days".localized)
                    .font(Fonts.bodyMdSemiBold)
                    .foregroundStyle(Colors.Text.tertiary)
            }
            .padding(.horizontal, 16)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(
            GeometryReader { sheet in
                Colors.Background.fixed
                    .ignoresSafeArea()
                    .onAppear { height = sheet.size.height }
                    .onChange(of: sheet.size.height) { height = $1 }
                    .padding(-100)  // MARK: 사용자 인터랙션(시트 끌어올림)에 대응
            }
        )
    }
}

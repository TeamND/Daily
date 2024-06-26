//
//  RecordSection.swift
//  Daily
//
//  Created by 최승용 on 6/25/24.
//

import SwiftUI

struct RecordSection<Content: View>: View {
    var title: String
    var isEssential: Bool = false
    var essentialConditions: Bool = false
    @State var isShowEssentialConditions: Bool = false
    var content: () -> Content
    
    var body: some View {
        let essentialConditionText: String = title == "목표" ? "최소 두 글자 이상의 목표가 필요합니다." : "!!!!!!"
        ZStack {
            Group(content: content)
                .padding()
                .background(Color("BackgroundColor"))
                .cornerRadius(10)
                .overlay {
                    VStack {
                        HStack {
                            HStack(spacing: CGFloat.fontSize * 0.5) {
                                Text((title))
                                if isEssential && !essentialConditions {
                                    Button {
                                        withAnimation {
                                            self.isShowEssentialConditions.toggle()
                                        }
                                    } label: {
                                        HStack(spacing: CGFloat.fontSize) {
                                            Image(systemName: "exclamationmark.circle.fill")
                                                .foregroundColor(.red)
                                            if isShowEssentialConditions {
                                                Text(essentialConditionText)
                                                    .font(.system(size: CGFloat.fontSize * 1.5))
                                                    .foregroundColor(Color("OppositeColor"))
                                            }
                                        }
                                    }
                                }
                            }
                            .font(.system(size: CGFloat.fontSize * 2))
                            .padding(.horizontal, CGFloat.fontSize)
                            .padding(.vertical, CGFloat.fontSize * 0.5)
                            .background(Color("ThemeColor"))
                            .cornerRadius(5)
                            .padding(.top, -CGFloat.fontSize * 1.5)
                            .padding(.leading, CGFloat.fontSize * 2)
                            Spacer()
                        }
                        Spacer()
                    }
                }
        }
    }
}

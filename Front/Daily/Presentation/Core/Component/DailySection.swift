//
//  DailySection.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailySection<Content: View>: View {
    var type: SectionType
    var essentialConditions: Bool = false
    @State var isShowEssentialConditions: Bool = false
    var content: () -> Content
    
    var body: some View {
        Group(content: content)
            .padding()
            .background(Colors.background)
            .cornerRadius(10)
            .padding(.top, CGFloat.fontSize * 1.5)
            .overlay {
                HStack(spacing: CGFloat.fontSize * 0.5) {
                    Text(type.title)
                        .font(.system(size: CGFloat.fontSize * 2))
                    if type.isEssential && !essentialConditions {
                        essentialButton
                    }
                    if type.isNew {
                        Text("new")
                            .foregroundStyle(Colors.daily)
                    }
                }
                .font(.system(size: CGFloat.fontSize * 1.5))
                .padding(.horizontal, CGFloat.fontSize)
                .padding(.vertical, CGFloat.fontSize * 0.5)
                .background(Colors.theme)
                .cornerRadius(5)
                .padding(.leading, CGFloat.fontSize * 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
    }
    
    // MARK: - essentialButton
    private var essentialButton: some View {
        Button {
            withAnimation {
                self.isShowEssentialConditions.toggle()
            }
        } label: {
            HStack(spacing: CGFloat.fontSize) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                if isShowEssentialConditions {
                    Text(type.essentialConditionText)
                        .foregroundStyle(Colors.reverse)
                }
            }
        }
    }
}

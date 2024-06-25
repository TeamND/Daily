//
//  RecordSection.swift
//  Daily
//
//  Created by 최승용 on 6/25/24.
//

import SwiftUI

struct RecordSection<Content: View>: View {
    var title: String
    var content: () -> Content
    
    var body: some View {
        ZStack {
            Group(content: content)
                .padding()
                .background(Color("BackgroundColor"))
                .cornerRadius(10)
                .overlay {
                    VStack {
                        HStack {
                                Text(title)
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

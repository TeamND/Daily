//
//  DailyNavigationBar.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyNavigationBar: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    
    init(title: String = "") {
        self.title = title
    }
    
    var body: some View {
        HStack {
            // MARK: - leading
            Button {
                dismiss()
            } label: {
                Label("이전", systemImage: "chevron.left")
                    .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
            }
            .foregroundStyle(Colors.daily)
            .padding(CGFloat.fontSize)
            .frame(maxWidth:. infinity, alignment: .leading)
            
            // MARK: - center
            Text(title)
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .foregroundStyle(Colors.reverse)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // MARK: - trailing
            Text("")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    DailyNavigationBar()
}

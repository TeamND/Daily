//
//  NavigationHeader.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct NavigationHeader: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    
    init(title: String = "") {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("이전", systemImage: "chevron.left")
                    .font(Fonts.bodyLgMedium)
            }
            .foregroundStyle(Colors.Text.point)
            .frame(maxWidth:. infinity, alignment: .leading)
            
            Text(title)
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationHeader()
}

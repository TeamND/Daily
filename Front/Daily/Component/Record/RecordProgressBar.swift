//
//  RecordProgressBar.swift
//  Daily
//
//  Created by 최승용 on 4/15/24.
//

import SwiftUI

struct RecordProgressBar: View {
    @Binding var record_count: Int
    @Binding var goal_count: Int
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView(value: Double(record_count), total: Double(goal_count))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("CustomColor").opacity(0.6)))
        }
        .padding(.vertical, 6)
    }
}

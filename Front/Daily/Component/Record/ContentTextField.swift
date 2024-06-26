//
//  ContentTextField.swift
//  Daily
//
//  Created by 최승용 on 4/11/24.
//

import SwiftUI

struct ContentTextField: View {
    @Binding var content: String
    @Binding var type: String
    @FocusState var focusedField : Int?
    
    var body: some View {
        TextField(
            "",
            text: $content,
            prompt: Text(contentOfGoalHintText(type: type))
        )
        .focused($focusedField, equals: 0)
        .onSubmit {
            hideKeyboard()
        }
        .onAppear {
            self.focusedField = 0
        }
    }
}

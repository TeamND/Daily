//
//  ContentTextField.swift
//  Daily
//
//  Created by 최승용 on 4/11/24.
//

import SwiftUI

struct ContentTextField: View {
    @Binding var content: String
    
    var body: some View {
        TextField(
            "",
            text: $content,
            prompt: Text(contentOfGoalHintText)
        )
        .padding()
        .background(Color("BackgroundColor"))
        .cornerRadius(5.0)
        .onSubmit {
            hideKeyboard()
        }
    }
}

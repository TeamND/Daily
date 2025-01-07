//
//  AppInfoContent.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct AppInfoContent: View {
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            Divider().padding(.vertical, 5)
            HStack {
                Text(name).foregroundStyle(.gray)
                Spacer()
                Group {
                    if let content {
                        Text(content)
                    } else if let linkLabel, let linkDestination {
                        Group {
                            Link(destination: URL(string: "https://\(linkDestination)")!) { Text(linkLabel) }
                            Image(systemName: "arrow.up.right.square")
                        }
                        .foregroundStyle(Colors.daily)
                    } else {
                        EmptyView()
                    }
                }
                .fontWeight(.bold)
            }
        }
    }
}

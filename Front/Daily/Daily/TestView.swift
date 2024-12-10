//
//  TestView.swift
//  Daily
//
//  Created by seungyooooong on 12/7/24.
//

import SwiftUI
class ViewModel: ObservableObject {
    @Published var visibleMonths: [Int] = []
    @Published var initialIndex: Int = 0
    var centerPage: Int
    var initLoad: Bool = true
    var updateable: Bool = true
    
    init() {
        centerPage = 0
        loadVisibleMonths()
    }
    
    func loadVisibleMonths() {
        visibleMonths = (-3...3).map { offset in
            offset + centerPage
        }
    }
    
    func updateCenterPage(_ page: Int) {
        if updateable {
            DispatchQueue.main.async {
                self.updateable = false
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                    self.updateable = true
                }
            }
            centerPage = page
            loadVisibleMonths()
        }
    }
}

struct TestView: View {
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.initialIndex) {
//        TabView {
            ForEach(Array(viewModel.visibleMonths.enumerated()), id: \.element) { index, page in
                TestCalendarView(date: String(page))
//                    .tag(index)
                    .onAppear {
                        viewModel.updateCenterPage(page)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

struct TestCalendarView: View {
    let date: String
    
    var body: some View {
        LazyVStack {
            Text(date)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Int(date)! % 2 == 0 ? Color.red : Color.blue)
        }
    }
}


#Preview {
    TestView()
}

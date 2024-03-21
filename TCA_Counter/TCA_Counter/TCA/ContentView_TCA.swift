//
//  ContentView_TCA.swift
//  TCA_Counter
//
//  Created by 강창현 on 3/21/24.
//

import SwiftUI

struct ContentView_TCA: View {
    var body: some View {
        Form {
            Section {
                Text("\(self.counterFeature.count)")
                Button("+") {
                    self.counterFeature.count += 1
                }
                Button("-") {
                    self.counterFeature.count -= 1
                }
            }
            
            Section {
                Button {
                    Task {
                        await self.counterFeature.getFactButtonTapped()
                    }
                } label: {
                    Text("데이터 가져오기")
                }
                if let fact = counterFeature.fact {
                    Text(fact)
                }
            }
        }
    }

}

#Preview {
    ContentView_TCA()
}

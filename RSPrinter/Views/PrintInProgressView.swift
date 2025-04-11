//
//  SelectedPrinterView.swift
//  RSPrinter
//
//  Created by Rajasekhar on 11/04/25.
//

import SwiftUI
import Foundation

struct PrintInProgressView: View {
    
    @State private var isAnimated = false

    var body: some View {
        VStack {
            
            Image(systemName: "printer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolEffect(.pulse, value: isAnimated)
                .foregroundStyle(Color.navigationBarColor)
                .frame(width: 150, height: 150)
            Text("Printing in progress")
                .font(.title2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onAppear {
            animateIcon()
        }
    }
    
    func animateIcon() {
        
        isAnimated.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            animateIcon()
        }
    }

}

#Preview {
    PrintInProgressView()
}

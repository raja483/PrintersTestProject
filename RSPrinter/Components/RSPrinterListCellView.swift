//
//  RSPrinterListCellView.swift
//  RSPrinter
//
//  Created by Rajasekhar on 11/04/25.
//

import SwiftUI

struct RSPrinterListCellView: View {
    
    let name: String
    let location: String
    
    var body: some View {
        HStack {
            Image(systemName: "printer")
            VStack(alignment:.leading) {
                Text(name)
                    .font(.headline)
                Text(location)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: "chevron.forward")
        }
    }
    
}

#Preview {
    
    List {
        RSPrinterListCellView(name: "Printer 1", location: "Hyderabad")
    }
}

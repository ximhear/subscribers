//
//  ContentView.swift
//  Subscribers
//
//  Created by gzonelee on 2022/10/17.
//

import SwiftUI
import CoreTelephony

struct ContentView: View {
    @State var serviceProviders: [String : CTCarrier]?
    var body: some View {
        VStack {
            if let serviceProviders {
                List {
                    ForEach(serviceProviders.values.map({ $0 }), id: \.self) { provider in
                        VStack {
                            Text(provider.carrierName ?? "")
                            Text(provider.description)
                        }
                    }
                }
                GroupBox("keys") {
                    ForEach(serviceProviders.keys.map({ $0 }), id: \.self) { provider in
                        Text(provider.description)
                        
                    }
                }
                GroupBox("subscribers") {
                    ForEach(CTSubscriberInfo.subscribers().map({ $0 }), id: \.self) { provider in
                        Text(provider.identifier)
                        
                    }
                }
                GroupBox("dataServiceIdentifier") {
                    Text(CTTelephonyNetworkInfo().dataServiceIdentifier ?? "")
                }
            }
        }
        .padding()
        .onAppear {
            
            let a = CTTelephonyNetworkInfo()
            serviceProviders = a.serviceSubscriberCellularProviders
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

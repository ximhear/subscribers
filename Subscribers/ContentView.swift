//
//  ContentView.swift
//  Subscribers
//
//  Created by gzonelee on 2022/10/17.
//

import SwiftUI
import CoreTelephony

struct CarrierInfo: Identifiable, CustomStringConvertible {
    var description: String {
        """
\n =====
id : \(id)
carrierName : \(carrierName ?? "")
mobileNetworkCode : \(mobileNetworkCode ?? "")
isoCountryCode : \(isoCountryCode ?? "")
allowsVOIP : \(allowsVOIP)
"""
    }
    
    var id: String
    let carrierName: String?
    let mobileCountryCode: String?
    let mobileNetworkCode: String?
    let isoCountryCode: String?
    let allowsVOIP: Bool
}
    
struct ContentView: View {
    @State var serviceProviders: [CarrierInfo]?
    var body: some View {
        VStack {
            Button {
                let str = "prefs:root=General&path=About"
//                let str = "prefs:root=MOBILE_DATA_SETTINGS_ID&path=CELLULAR_DATA_OPTIONS"
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:]) { finished in
                        GZLogFunc(finished)
                    }
                }
            } label: {
                Text("Goto Cellular Data Settings")
            }

            if let serviceProviders {
                List {
                    ForEach(serviceProviders) { provider in
                        VStack {
                            Text(provider.carrierName ?? "")
                            Text(provider.description)
                        }
                    }
                }
                GroupBox("keys") {
                    ForEach(serviceProviders) { provider in
                        Text(provider.id)
                        
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
            if let providers = a.serviceSubscriberCellularProviders {
                serviceProviders = []
                for (key, c) in providers {
                    let a = CarrierInfo(id: key, carrierName: c.carrierName, mobileCountryCode: c.mobileCountryCode, mobileNetworkCode: c.mobileNetworkCode, isoCountryCode: c.isoCountryCode, allowsVOIP: c.allowsVOIP)
                    serviceProviders?.append(a)
                }
                
            }
            GZLogFunc(serviceProviders)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

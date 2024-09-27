//
//  MeView.swift
//  HotProspects
//
//  Created by David Hernandez on 25/09/24.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
    
    //Core Filter properties
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    //QR Code Image Cache
    @State private var qrCode = UIImage()
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .textContentType(.name)
                .font(.title)
            
            TextField("Email address", text: $emailAddress)
                .textContentType(.emailAddress)
                .font(.title)
            
            Image(uiImage: qrCode)
                .interpolation(.none) //remove pixellation from QR code
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .contextMenu {
                    ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                }
        }
        .navigationTitle("Your code")
        .onAppear(perform: updateCode)
        .onChange(of: name, updateCode)
        .onChange(of: emailAddress, updateCode)
    }
    
    //QR Code Generation. Returns xmark.circle if something fails. Returns UIImage if xmark.circle cannot be shown for whatever reason
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
}

#Preview {
    MeView()
}

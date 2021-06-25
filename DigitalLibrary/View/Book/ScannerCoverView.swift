//
//  ScannerCoverView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 20/06/21.
//

import SwiftUI
import VisionKit

struct ScannerCoverView: UIViewControllerRepresentable {
    
    var didFinishScannign: (_ result: Result<[UIImage], Error>) -> Void
    
    var didCancelScanning: () -> Void
        
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let scannerView: ScannerCoverView
        
        init(with scannerView: ScannerCoverView) {
            self.scannerView = scannerView
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            scannerView.didCancelScanning()
        }
     
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishScannign(.failure(error))
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedPages = [UIImage]()
             
            for i in 0..<scan.pageCount {
                scannedPages.append(scan.imageOfPage(at: i))
            }
            
            scannerView.didFinishScannign(.success(scannedPages))
        }
    }
}

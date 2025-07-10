//
//  BarcodeScannerRepresentable.swift
//  syosekiroku

import SwiftUI
import VisionKit

struct BarcodeScannerRepresentable: UIViewControllerRepresentable {
    var onScan: (String) -> Void

    let dataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [.barcode()],
        qualityLevel: .balanced,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: true,
        isPinchToZoomEnabled: false,
        isGuidanceEnabled: false,
        isHighlightingEnabled: true
    )

    func makeUIViewController(context: Context) -> DataScannerViewController {
        //UIKit <- SwiftUI
        dataScannerViewController.delegate = context.coordinator
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }

    //SwiftUIからの更新が必要になったときに呼び出される
    func updateUIViewController(
        _ uiViewController: DataScannerViewController, context: Context
    ) {
        try? uiViewController.startScanning()
    }

    //UIKitのdelegateとSwiftUIを接続
    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var onScan: (String) -> Void

        init(onScan: @escaping (String) -> Void) {
            self.onScan = onScan
        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didAdd addedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {
            for item in addedItems {
                if case let .barcode(barcode) = item,
                    let value = barcode.payloadStringValue
                {
                    onScan(value)
                    dataScanner.stopScanning()
                }
            }
        }
    }

}

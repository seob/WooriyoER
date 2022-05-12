//
//  ExampleFactory.swift
//  PinPle
//
//  Created by seob on 2020/06/30.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import TPPDF

protocol ExampleFactory {

    func generateDocument() -> [PDFDocument]

}

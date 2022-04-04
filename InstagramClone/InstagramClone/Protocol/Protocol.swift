//
//  Protocol.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 16/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation

protocol HomePageProtocol {
    
    func hometableCell(cell:HomeTableViewCell)
    func commentTableCell(cell:HomeTableViewCell,index:Int)
    func imageDoubleTapped(cell: HomeTableViewCell)
    func share(cell: HomeTableViewCell ,index:Int)

}




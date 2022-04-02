//
//  Protocol.swift
//  InstagramClone
//
//  Created by Dharam Singh on 16/03/20.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import Foundation

protocol HomePageProtocol {
    
    func hometableCell(cell:HomeTableViewCell)
    func commentTableCell(cell:HomeTableViewCell,index:Int)
    func imageDoubleTapped(cell: HomeTableViewCell)
    func share(cell: HomeTableViewCell ,index:Int)

}




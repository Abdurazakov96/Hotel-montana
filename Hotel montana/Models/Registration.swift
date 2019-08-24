//
//  Registration.swift
//  Hotel montana
//
//  Created by Магомед Абдуразаков on 21/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import Foundation

struct Registration {
    
    var firstName: String
    var lastName: String
    var email: String
    
    var chickInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType?
    var wifi: Bool
    
}

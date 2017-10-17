//
//  TripListItem.swift
//  GoeuroApp
//
//  Created by Michal Grman on 16/10/2017.
//  Copyright © 2017 Michal Grman. All rights reserved.
//

import ReactiveCocoa
import UIKit
import AlamofireImage

class TripListItem: UITableViewCell {

    @IBOutlet weak var logo:UIImageView!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var duration:UILabel!
    @IBOutlet weak var date:UILabel!
    
    static let Identifier = "\(TripListItem.self)"

}

extension TripListItem: TripListItemViewBinding {
    
    func bind(using provider:TripListItemViewProvider) {
        
        self.price.text =       provider.priceText
        self.date.text =        provider.dateText
        self.duration.text =    provider.durationText
        
        
        let placeholder = UIImage(named: "placeholder.png")!
        
        do {
            let url = try provider.logoUrl.asURL()
            self.logo.af_setImage(
                withURL: url,
                placeholderImage: placeholder,
                imageTransition:.crossDissolve(0.3),
                runImageTransitionIfCached:false
            )
        } catch {
            self.logo.image = placeholder
        }
    }
}

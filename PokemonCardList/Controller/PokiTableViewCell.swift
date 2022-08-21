//
//  PokiTableViewCell.swift
//  PokemonCardList
//
//  Created by Roberts Kursitis on 19/08/2022.
//

import UIKit
import SDWebImage

class PokiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokiImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var superTypeLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var favOutlet: UIButton!
    var ID: String = ""
    
    override func prepareForReuse() {
        pokiImageView.image = nil
    }
    
    @IBAction func favTapped(_ sender: Any) {
        PokemonViewController.pokiIDs.append(ID)
        print("tap tap")
        nameLabel.text = "pocket monster"
        print(PokemonViewController.pokiIDs)

    }
    @IBAction func checkTapped(_ sender: Any) {

    }
    
    
    
    func setupUI(withDataFrom: Datum) {
        
        self.pokiImageView.sd_setImage(with: URL(string: withDataFrom.images.small), placeholderImage: UIImage(named: "PokePlaceholder.jpg"))
        
        nameLabel.text = withDataFrom.name
        let numFormatted = String(format: "%03d", withDataFrom.nationalPokedexNumbers[0])
        numberLabel.text = "Pokedex entry: #" + numFormatted
        superTypeLabel.text = "Type: " + withDataFrom.types[0].rawValue
//        rarityLabel.text = "Rarity: " + withDataFrom.rarity.rawValue
        ID = withDataFrom.id
    }
    
}

//
//  PokiDetailViewController.swift
//  PokemonCardList
//
//  Created by Roberts Kursitis on 20/08/2022.
//

import UIKit
import AVFoundation

class PokiDetailViewController: UIViewController {
    
    @IBOutlet weak var weaknessOutlet: UILabel!
    @IBOutlet weak var subtypeOutlet: UILabel!
    @IBOutlet weak var hpOutlet: UILabel!
    @IBOutlet weak var levelOutlet: UILabel!
    @IBOutlet weak var pokemonCard: UIImageView!
    
    var pokemon: Datum?

    override func viewDidLoad() {
        view.backgroundColor = .systemYellow
        super.viewDidLoad()
        pokemonCard.sd_setImage(with: URL(string: pokemon?.images.large ?? ""), placeholderImage: UIImage(named: "PokePlaceholder.jpg"))
        levelOutlet.text = "Level: " + (pokemon?.level ?? "Unknown")
        hpOutlet.text = "HP: " + String(pokemon?.hp ?? "Unknown")
        subtypeOutlet.text = "Subtype: " + String(pokemon?.subtypes[0].rawValue ?? "None")
        weaknessOutlet.text = "Weakness: " + (pokemon?.weaknesses?[0].type.rawValue ?? "Unknown")
    }
    
    @IBAction func moreTapped(_ sender: Any) {
        let message = """
        \(String(describing: pokemon?.flavorText ?? ""))
        This card was released as part of \(String(describing: pokemon?.datumSet.series.rawValue ?? "")) set in \(String(describing: pokemon?.datumSet.releaseDate.rawValue ?? "")).
        Artwork by \(String(describing: pokemon?.artist ?? "")).
        """
        let ac = UIAlertController(title: pokemon?.name ?? "", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default))
        present(ac, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

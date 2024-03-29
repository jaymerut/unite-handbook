//
//  PokemonListViewController.swift
//  UniteHandbook
//
//  Created by Jayme Rutkoski on 2/9/23.
//

import UIKit
import SnapKit
import IGListKit

class PokemonListViewController: UIViewController {

    private var pokemonList: [Pokemon] = [Pokemon]()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(hex:0xFCA97B).cgColor, UIColor(hex:0xA971A2).cgColor]
        layer.startPoint = CGPoint(x:0, y:0)
        layer.endPoint = CGPoint(x:0, y:1)
        layer.anchorPoint = CGPointZero;
        layer.frame = self.view.bounds
        
        return layer
    }()
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater.init(), viewController: self, workingRangeSize: 0)
        
        return adapter
    }()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    public convenience init(pokemonList: [Pokemon]) {
        self.init(nibName: nil, bundle: nil)
        self.pokemonList = pokemonList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bgView = UIView(frame: self.view.bounds)
        bgView.layer.insertSublayer(self.gradientLayer, at: 0)
        self.collectionView.backgroundView = bgView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let newFrame = CGRect(x: 0, y: 0, width: abs(size.width), height: abs(size.height))
        let bgView = UIView(frame: newFrame)
        self.gradientLayer.frame = newFrame
        bgView.layer.insertSublayer(self.gradientLayer, at: 0)
        self.collectionView.backgroundView = bgView
    }
    
    private func setup() {
        self.title = "Pokemon"
        
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    private func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
            var gradientImage:UIImage?
            UIGraphicsBeginImageContext(gradientLayer.frame.size)
            if let context = UIGraphicsGetCurrentContext() {
                gradientLayer.render(in: context)
                gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            }
            UIGraphicsEndImageContext()
            return gradientImage
        }
}

extension PokemonListViewController: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.pokemonList
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if (object is Pokemon) {
            return PokemonSectionController(delegate: self)
        }
        
        return ListSectionController()
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension PokemonListViewController: PokemonSectionControllerDelegate {
    
    func didSelectPokemon(pokemon: Pokemon) {
        self.show(PokemonDetailsViewController(pokemon: pokemon), sender: self)
    }
}

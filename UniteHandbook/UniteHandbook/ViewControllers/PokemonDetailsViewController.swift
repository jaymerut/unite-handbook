//
//  PokemonDetailsViewController.swift
//  UniteHandbook
//
//  Created by Jayme Rutkoski on 2/10/23.
//

import UIKit
import SnapKit
import IGListKit
import GoogleMobileAds

class PokemonDetailsViewController: UIViewController, GADFullScreenContentDelegate {

    private var rewardedAd: GADRewardedAd?
    private var currentLevel: Int = 1
    private var pokemon: Pokemon = Pokemon()
    private var abilitiesArray: [BaseListDiffable] = [BaseListDiffable]()
    private var buildsArray: [BaseListDiffable] = [BaseListDiffable]()
    private var statsArray: [BaseListDiffable] = [BaseListDiffable]()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(hex:0xFCA97B).cgColor, UIColor(hex:0xA971A2).cgColor]
        layer.startPoint = CGPoint(x:0, y:0)
        layer.endPoint = CGPoint(x:0, y:1)
        layer.anchorPoint = CGPointZero;
        layer.frame = self.view.bounds
        
        return layer
    }()
    
    private var viewContainer: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var viewAttackerStyle: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private var labelName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.font = UIFont(name: "Georgia-Bold", size: 24.0)
        
        return label
    }()
    
    private var stackViewInformation: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    private var labelAttackerStyle: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: "Georgia", size: 15.0)
        button.layer.cornerRadius = 12.5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    private var labelRole: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: "Georgia", size: 15.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex:0x3B275E)
        button.layer.cornerRadius = 12.5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    private var labelStyle: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: "Georgia", size: 15.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex:0x3B275E)
        button.layer.cornerRadius = 12.5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    private var labelDifficulty: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: "Georgia", size: 15.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex:0x3B275E)
        button.layer.cornerRadius = 12.5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(frame: .zero)
        control.insertSegment(withTitle: "Abilities", at: 0, animated: false)
        control.insertSegment(withTitle: "Builds", at: 1, animated: false)
        control.insertSegment(withTitle: "Stats", at: 2, animated: false)
        
        control.selectedSegmentTintColor = UIColor(hex: 0xF9CB53)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected)
        control.backgroundColor = UIColor(hex: 0x3B276B)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        return control
    }()
    private lazy var buttonAddBuild: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Add Build", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 14.0)
        button.setImage(UIImage(named: "add.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonAddBuild_TouchUpInside), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x4AB438)
        button.layer.cornerRadius = 20.0
        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 8)
        
        return button
    }()
    
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater.init(), viewController: self, workingRangeSize: 0)
        
        return adapter
    }()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.backgroundColor = UIColor(hex: 0xAFFEFF)
        collectionView.layer.borderWidth = 1.5
        collectionView.layer.borderColor = UIColor.black.cgColor
        
        return collectionView
    }()
    
    public convenience init(pokemon: Pokemon) {
        self.init(nibName: nil, bundle: nil)
        self.pokemon = pokemon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.view.backgroundColor = .white
        self.createSections()
        self.setup()
        self.loadRewardedAd()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let newFrame = CGRect(x: 0, y: 0, width: abs(size.width), height: abs(size.height))
        self.gradientLayer.frame = newFrame
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    private func setup() {
        self.imageView.image = UIImage(named: self.pokemon.name.lowercased())
        self.title = self.pokemon.name
        //self.labelName.text = self.pokemon.name
        self.labelAttackerStyle.setTitle(self.pokemon.attackStyle.lowercased() == "attack" ? "Physical Attacker" : "Special Attacker", for: .normal)
        self.labelAttackerStyle.backgroundColor = self.pokemon.attackStyle.lowercased() == "attack" ? UIColor(hex: 0xF9CB53) : UIColor(hex: 0xC974DB)
        self.labelRole.setTitle(self.pokemon.role, for: .normal)
        self.labelStyle.setTitle(self.pokemon.style, for: .normal)
        self.labelDifficulty.setTitle(self.pokemon.difficulty, for: .normal)
        
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
        self.view.addSubview(self.viewContainer)
        self.viewContainer.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view.snp.left).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        
        /*self.viewContainer.addSubview(self.labelName)
        self.labelName.snp.makeConstraints { make in
            make.top.equalTo(self.viewContainer.snp.top)
            make.left.equalTo(self.imageView.snp.right).offset(12)
        }*/
        
        self.viewContainer.addSubview(self.stackViewInformation)
        self.stackViewInformation.snp.makeConstraints { make in
            make.top.equalTo(self.viewContainer.snp.top)
            make.right.equalTo(self.viewContainer.snp.right)
        }
        
        self.stackViewInformation.addArrangedSubview(self.labelAttackerStyle)
        self.labelAttackerStyle.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        self.stackViewInformation.addArrangedSubview(self.labelRole)
        self.labelRole.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        self.stackViewInformation.addArrangedSubview(self.labelStyle)
        self.labelStyle.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        self.stackViewInformation.addArrangedSubview(self.labelDifficulty)
        self.labelDifficulty.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        
        self.viewContainer.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.stackViewInformation.snp.bottom).offset(10)
            make.left.equalTo(self.viewContainer.snp.left)
            make.right.equalTo(self.viewContainer.snp.right)
        }
        
        self.viewContainer.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.viewContainer.snp.top)
            make.left.equalTo(self.viewContainer.snp.left)
            make.bottom.equalTo(self.segmentedControl.snp.top).offset(-10)
            make.width.equalTo(self.imageView.snp.height)
            //make.height.equalTo(155)
            //make.width.equalTo(155)
        }
        
        self.viewContainer.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(15)
            make.left.equalTo(self.viewContainer.snp.left)
            make.right.equalTo(self.viewContainer.snp.right)
            make.bottom.equalTo(self.viewContainer.snp.bottom)
        }
        
        self.collectionView.addSubview(self.buttonAddBuild)
        self.buttonAddBuild.snp.makeConstraints { make in
            make.bottom.equalTo(self.viewContainer.snp.bottom).offset(-20)
            make.right.equalTo(self.viewContainer.snp.right).offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(135)
        }
    }
    
    private func createSections() {
        // Abilities
        for ability in self.pokemon.ability {
            self.abilitiesArray.append(AbilityDetails(
                imageName: "\(self.pokemon.name.lowercased())_\(ability.name.replacingOccurrences(of: " ", with: "").lowercased()).png",
                name: ability.name,
                desc: ability.desc))
        }
        
        
        if let moves = convertMovesToMoveDetailsArray(moves: self.pokemon.moves) {
            var count = 0
            for move in moves {
                count+=1
                self.abilitiesArray.append(HeaderDivider(title: "Move \(count)"))
                self.abilitiesArray.append(move)
            }
        }
        
        self.abilitiesArray.append(HeaderDivider(title: "Unite Move"))
        for unite in self.pokemon.unite {
            self.abilitiesArray.append(MoveDetails(
                imageName: "\(self.pokemon.name.lowercased())_\(unite.name.replacingOccurrences(of: " ", with: "").lowercased()).png",
                name: unite.name,
                category: unite.category,
                cooldown: unite.cooldown,
                levelDetails: unite.levelDetails,
                upgrades: nil))
        }
        
        
        // Builds
        let builds = convertBuildsToBuildMovesArray(builds: self.pokemon.presetBuilds)
        let customBuilds = convertBuildsToBuildMovesArray(builds: SwiftAppDefaults.shared.customBuilds[self.pokemon.name] ?? [Build](), isCustomBuild: true)

        for build in builds {
            self.buildsArray.append(build)
        }
        for build in customBuilds {
            self.buildsArray.append(build)
        }
        
        // Stats
        self.statsArray.append(StatSlider(currentLevel: self.currentLevel))
        self.setStatsForLevel(self.currentLevel)
    }
    
    private func convertMovesToMoveDetailsArray(moves: [Move]?) -> [MoveDetails]? {
        guard let moves = moves else { return nil }
        var result = [MoveDetails]()
        for move in moves {
            result.append(MoveDetails(
                imageName: "\(self.pokemon.name.lowercased())_\(move.name.replacingOccurrences(of: " ", with: "").lowercased()).png",
                name: move.name,
                category: move.category,
                cooldown: move.cooldown,
                levelDetails: move.levelDetails,
                upgrades: convertMovesToMoveDetailsArray(moves: move.upgrades)))
        }
        return result
    }
    
    private func convertBuildsToBuildMovesArray(builds: [Build], isCustomBuild: Bool = false) -> [BaseListDiffable] {
        var results = [BaseListDiffable]()
        for build in builds {
            let section = BuildSection(
                
                name: "Build: \(build.name)",
                imagesMoves: build.moveOrders.map { UIImage(named: "\(self.pokemon.name.lowercased())_\($0.replacingOccurrences(of: " ", with: "").lowercased()).png") },
                imagesHeldItems: build.heldItems.map { UIImage(named: "\($0.replacingOccurrences(of: " ", with: "_").lowercased()).png")},
                imageBattleItem: UIImage(named: "\(build.battleItem.replacingOccurrences(of: " ", with: "_").lowercased()).png"),
                imageAltHeldItem: UIImage(named: "\(build.altHeldItem.replacingOccurrences(of: " ", with: "_").lowercased()).png"),
                imageAltBattleItem: UIImage(named: "\(build.altBattleItem.replacingOccurrences(of: " ", with: "_").lowercased()).png"),
                isCustomBuild: isCustomBuild)
            
            results.append(section)
        }
        return results
    }
    
    private func setStatsForLevel(_ level: Int) {
        let stats = self.pokemon.stats.first(where: { $0.level == level })

        if let stats = stats {
            self.statsArray.removeAll(where: { $0 is StatSection })
            
            self.statsArray.append(StatSection(title: "HP", value: "\(stats.hp)"))
            self.statsArray.append(StatSection(title: "Attack", value: "\(stats.attack)"))
            self.statsArray.append(StatSection(title: "Defense", value: "\(stats.defense)"))
            self.statsArray.append(StatSection(title: "Sp. Attack", value: "\(stats.spAttack)"))
            self.statsArray.append(StatSection(title: "Sp. Defense", value: "\(stats.spDefense)"))
            self.statsArray.append(StatSection(title: "Critical-Hit Rate", value: "\(Int(stats.critRate * 100))%"))
            self.statsArray.append(StatSection(title: "CD Reduction", value: "\(Int(stats.cdr * 100))%"))
            self.statsArray.append(StatSection(title: "Lifesteal", value: "\(Int(stats.lifesteal * 100))%"))
        }
    }
    
    

   func loadRewardedAd() {
       let request = GADRequest()
       GADRewardedAd.load(withAdUnitID:"ca-app-pub-7088839014127907/9930370848",
                       request: request,
                       completionHandler: { [self] ad, error in
           if let error = error {
               print("Failed to load rewarded ad with error: \(error.localizedDescription)")
               return
           }
           rewardedAd = ad
           print("Rewarded ad loaded.")
           rewardedAd?.fullScreenContentDelegate = self
       })
   }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.adapter.performUpdates(animated: false)
        self.adapter.reloadData()
    }
    
    @objc func buttonAddBuild_TouchUpInside(sender: UIButton) {
        if SwiftAppDefaults.shared.addBuildCredits == 0 {
            self.navigateToPopUpAd(title: "Watch Ad", message: "Please watch this video ad to add a new build! (This helps supports the developer, thank-you!)") { [weak self] in
                guard let self = self else { return }
                if let ad = self.rewardedAd {
                    ad.present(fromRootViewController: self) {
                        let reward = ad.adReward
                        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                        SwiftAppDefaults.shared.addBuildCredits = SwiftAppDefaults.shared.addBuildCredits + reward.amount.intValue
                    }
                } else {
                    print("Ad wasn't ready")
                    self.navigateToAddBuild()
                }
            }
        } else {
            self.navigateToAddBuild()
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.loadRewardedAd()
        if SwiftAppDefaults.shared.addBuildCredits > 0 {
            self.navigateToAddBuild()
        }
        print("Ad did dismiss full screen content.")
    }
    
    private func navigateToAddBuild() {
        let vc = AddBuildViewController(pokemonName: self.pokemon.name, pokemonMoves: self.pokemon.moves, delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    private func navigateToPopUpAd(title: String, message: String, willWatch: @escaping (() -> ())) {
        let vm = PopUpAdViewModel(title: title, message: message, headerBackgroundColor: UIColor(hex:0xA971A2), headerTextColor: .white, willWatch: willWatch)
        let vc = PopUpAdViewController(viewModel: vm)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}

extension PokemonDetailsViewController: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.buttonAddBuild.isHidden = true
            return self.abilitiesArray
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            self.buttonAddBuild.isHidden = false
            return self.buildsArray
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            self.buttonAddBuild.isHidden = true
            return self.statsArray
        }
        return [ListDiffable]()
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if object is AbilityDetails {
            return AbilitiesSectionController(delegate: self)
        } else if object is MoveDetails {
            return MoveSectionController(delegate: self)
        } else if object is HeaderDivider {
            return HeaderDividerSectionController()
        } else if object is BuildSection {
            return BuildSectionSectionController(delegate: self)
        } else if object is StatSection {
            return StatSectionController()
        } else if object is StatSlider {
            return StatSliderSectionController(delegate: self)
        }
        
        return ListSectionController()
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PokemonDetailsViewController : AbilitiesSectionControllerDelegate {
    func didSelectAbilityInfo(desc: String) {
        let vc = PokemonLevelDetailsViewController(desc: desc)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)
    }
}

extension PokemonDetailsViewController : MoveSectionControllerDelegate {
    func didSelectMoveInfo(levelDetails: [LevelDetails]) {
        let vc = PokemonLevelDetailsViewController(levelDetails: levelDetails)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)
    }
    
    func showUpgrades(forMove: MoveDetails, upgrades: [MoveDetails], shouldAddUpgrades: Bool) {
        for ability in self.abilitiesArray {
            if ability.isEqual(forMove) {
                if let move = ability as? MoveDetails {
                    move.isShowingUpgrades = true
                }
            }
        }
        let index: Int? = self.abilitiesArray.firstIndex(where: {$0 == forMove})
        var newObjects: [BaseListDiffable] = upgrades
        if index != nil {
            let startIndex = index!+1
            newObjects.insert(HeaderDivider(title: "\(forMove.name) Upgrade Choices", isSubHeader: true), at: 0)
            if shouldAddUpgrades {
                self.abilitiesArray.insert(contentsOf: newObjects, at: startIndex)
            } else {
                self.abilitiesArray.removeSubrange(startIndex...startIndex+newObjects.count-1)
            }
            
            self.adapter.performUpdates(animated: true)
            self.adapter.reloadObjects(newObjects)
        }
    }
}

extension PokemonDetailsViewController : BuildSectionSectionControllerDelegate {
    
    func didClickDelete(section: BuildSection) {
        let alert = UIAlertController(title: "Delete Build", message: "Are you sure you want to delete this build?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            guard let sectionIndex = self.buildsArray.firstIndex(of: section) else { return }
            SwiftAppDefaults.shared.customBuilds[self.pokemon.name]?.remove(at: sectionIndex - self.pokemon.presetBuilds.count )
            self.buildsArray.remove(at: sectionIndex)
            
            self.adapter.performUpdates(animated: true)
            self.adapter.reloadObjects(self.buildsArray.filter( { $0 is BuildSection }))
          }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }
}

extension PokemonDetailsViewController : StatSliderSectionControllerDelegate {
    
    func didChangeLevel(level: Int) {
        self.currentLevel = level
        for stat in statsArray {
            if let statSlider = stat as? StatSlider {
                statSlider.currentLevel = level
            }
        }
        self.setStatsForLevel(level)
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadObjects(self.statsArray.filter( { $0 is StatSection }))
    }
}

extension PokemonDetailsViewController : AddBuildDelegate {
    
    func addBuild(pokemonName: String, build: Build) {
        SwiftAppDefaults.shared.addBuildCredits = SwiftAppDefaults.shared.addBuildCredits - 1
        
        var buildsForPokemon = SwiftAppDefaults.shared.customBuilds[pokemonName] ?? [Build]()
        buildsForPokemon.append(build)
        SwiftAppDefaults.shared.customBuilds[pokemonName] = buildsForPokemon
        self.buildsArray.append(contentsOf: convertBuildsToBuildMovesArray(builds: [build], isCustomBuild: true))
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadObjects(self.buildsArray.filter( { $0 is BuildSection }))
    }
}

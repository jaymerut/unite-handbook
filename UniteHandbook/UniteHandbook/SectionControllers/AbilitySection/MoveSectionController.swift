//
//  MoveSectionController.swift
//  UniteHandbook
//
//  Created by Jayme Rutkoski on 2/10/23.
//

import IGListKit

protocol MoveSectionControllerDelegate: AnyObject {
    func didSelectMoveInfo(levelDetails: [LevelDetails])
    func showUpgrades(forMove: MoveDetails, upgrades: [MoveDetails], shouldAddUpgrades: Bool)
}

class MoveSectionController: ListSectionController {
    
    private var model: MoveDetails? = nil
    private weak var delegate: MoveSectionControllerDelegate?
    
    convenience init(delegate: MoveSectionControllerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    internal override func numberOfItems() -> Int {
        return 1
    }
    internal override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: self.collectionContext?.containerSize.width ?? 0, height: 93)
    }
    internal override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = (self.collectionContext?.dequeueReusableCell(of: MoveCollectionViewCell.self, for: self, at: index))! as? MoveCollectionViewCell else { return UICollectionViewCell() }
        
        guard let model = model else { return cell }
        cell.image = UIImage(named: model.imageName.lowercased())
        cell.name = model.name
        cell.category = model.category
        cell.cooldown = model.cooldown
        cell.hasUpgrades = model.upgrades != nil && model.upgrades?.count ?? 0 > 0
        cell.isShowingUpgrades = model.isShowingUpgrades
        cell.sectionController = self
        
        return cell
    }
    internal override func didUpdate(to object: Any) {
        self.model = object as? MoveDetails
    }
    internal override func didSelectItem(at index: Int) {

    }
    
    internal func didSelectInfo() {
        guard let model = model else { return }
        self.delegate?.didSelectMoveInfo(levelDetails: model.levelDetails)
    }
    internal func showUpgrades(shouldAddUpgrades: Bool) {
        guard let model = model else { return }
        guard let upgrades = model.upgrades else { return }
        self.delegate?.showUpgrades(forMove: model, upgrades: upgrades, shouldAddUpgrades: shouldAddUpgrades)
    }
}

public class MoveDetails : BaseListDiffable {
    public var imageName: String
    public var name: String
    public var category: String
    public var cooldown: Double
    public var levelDetails: [LevelDetails]
    public var upgrades: [MoveDetails]?
    public var isShowingUpgrades: Bool = false
    
    public init(imageName: String, name: String, category: String, cooldown: Double, levelDetails: [LevelDetails], upgrades: [MoveDetails]?) {
        self.imageName = imageName
        self.name = name
        self.category = category
        self.cooldown = cooldown
        self.levelDetails = levelDetails
        self.upgrades = upgrades
    }
}

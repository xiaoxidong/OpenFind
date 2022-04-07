//
//  PhotosVC+Delegate.swift
//  Find
//
//  Created by A. Zheng (github.com/aheze) on 2/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

/// Scroll view
extension PhotosViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavigationBlur(with: scrollView)

        /// For photos caching
        updateCachedAssets()
    }

    /// update the blur with a scroll view's content offset
    func updateNavigationBlur(with scrollView: UIScrollView) {
        let contentOffset = -scrollView.contentOffset.y
        additionalSearchBarOffset = contentOffset - baseSearchBarOffset - searchViewModel.getTotalHeight()
        updateNavigationBar?()
    }

    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        if model.isSelecting {
            return true
        } else {
            return false
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if model.isSelecting {
            if model.resultsState != nil {
                photoResultsSelected(at: indexPath)
            } else {
                photoSelected(at: indexPath)
            }
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if model.isSelecting {
            if model.resultsState != nil {
                photoResultsDeselected(at: indexPath)
            } else {
                photoDeselected(at: indexPath)
            }
        }
    }
}

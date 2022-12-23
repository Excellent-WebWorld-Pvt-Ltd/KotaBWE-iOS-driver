

import UIKit

class CheckViewController: UIPageViewController,UIScrollViewDelegate
{
   
    lazy var pages = [UIViewController]()
    var didSwipe = true
    weak var containerDelegate: pagesContainerDelegate?
    weak var containerDataSource: pagesContainerDataSource?{
        didSet{
            if let dataSource = containerDataSource{
                pages = (dataSource.vcIdentifiers.map {
                    self.getViewController(name: $0.0, withIdentifier: $0.1)
                })
                if let firstVC = pages.first
                {
                    setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                }
            }
        }
    }
    var indexOfPresentVC = 0
    var isSrollingEnabled = true {
        didSet{
            for v in view.subviews{
                if v is UIScrollView {
                    (v as! UIScrollView).isScrollEnabled = isSrollingEnabled
                }
            }
        }
    }
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        
        for v in view.subviews{
            if v is UIScrollView {
                (v as! UIScrollView).delegate = self
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard didSwipe else { return }
       containerDelegate?.pageIsIntransition(transition: scrollView.contentOffset.x - view.frame.width, index: indexOfPresentVC)
    }
    
    fileprivate func getViewController(name: String, withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard.init(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
extension CheckViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil       }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished{ didSwipe = true }
        if completed{
            didSwipe = true
            let index = pages.firstIndex(of: pageViewController.viewControllers![0])!
            self.indexOfPresentVC = index
            let lastIndex = pages.firstIndex(of: previousViewControllers[0])!
            containerDelegate?.pageTransitionCompleted(from: lastIndex, to: indexOfPresentVC)
        }
    }
    func customChangeVC(index: Int, previousIndex: Int) {
        didSwipe = false
        if previousIndex < index{
            setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        }else if previousIndex > index{
            setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
        }
    }
}
protocol pagesContainerDelegate: class {
    func pageTransitionCompleted(from index: Int, to newIndex: Int)
    func pageIsIntransition(transition: CGFloat,index: Int)
}
protocol pagesContainerDataSource: class{
    var vcIdentifiers: [(String,String)] {get}
    var storyBoardName: String{ get}
}








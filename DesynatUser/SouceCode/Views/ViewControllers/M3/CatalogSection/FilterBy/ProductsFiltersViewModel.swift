//
//  ProductsFiltersViewModel.swift
//  DesynatUser
//
//  Created by fluper on 28/11/25.
//

class ProductsFiltersViewModel {
    
    private var hostVC: ProductsFiltersViewController
    
    var getAllCategoriesList: [CategoriesDataModel] = []
    var getAllBrandsList: [AllBrandsListData] = []
    var getAllColorsList: [AllColorsList] = []
    var getAllSizesList: [AllSizesList] = []
    
    init(hostVC: ProductsFiltersViewController) {
        self.hostVC = hostVC
    }
    
    // CATEGORY
    func getAllCategory(completion: @escaping () -> Void) {
        WebService.sharedInstance.getCategoriesService { list in
            self.getAllCategoriesList = list
            completion()
        }
    }
    
    // BRANDS
    func getAllBrands(completion: @escaping () -> Void) {
        WebService.sharedInstance.getBrandsService { list in
            self.getAllBrandsList = list
            completion()
        }
    }
    
    // COLORS
    func getAllColors(completion: @escaping () -> Void) {
        WebService.sharedInstance.getColorsService { list in
            self.getAllColorsList = list
            completion()
        }
    }
    
    // SIZES
    func getAllSize(completion: @escaping () -> Void) {
        WebService.sharedInstance.getSizeService { list in
            self.getAllSizesList = list
            completion()
        }
    }
}

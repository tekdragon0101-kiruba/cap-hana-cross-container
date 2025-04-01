using {
    opensap.MD.Addresses as Addr,
    opensap.MD.Employees as Empl,
    opensap.MD.BusinessPartners as BP,
    opensap.MD.Products as Prod,
    opensap.MD.ProductImages as ProdImages,
    opensap.MD.productCategoryVH as prodCat,
    opensap.MD.BuyerView as BuyerViewNative,
    opensap.MD.partnerRoles as partRoles,
} from '../db/schema';

service MasterDataService @(path: '/odata/v4/MasterDataService') {
    entity Addresses                                            as projection on Addr;
    entity Employees                                            as projection on Empl;
    entity BusinessPartners @(title: '{i18n>businessParnters}') as projection on BP;

    entity Products @(title: '{i18n>products}')                 as
        projection on Prod {
            *,
            partner : redirected to BusinessPartners
        };

    @readonly
    view productCategoryVH as select from prodCat;

    view partnerRoles as select from partRoles;
    view Buyer as select from BuyerViewNative;

    entity ProductImages                                        as
        projection on ProdImages {
            *,
            product : redirected to Products
        };

    function loadProductImages() returns Boolean;
}

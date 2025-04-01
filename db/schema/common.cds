using {
    sap,
    Currency,
    temporal,
    managed
} from '@sap/cds/common';


extend sap.common.Currencies with {
    numCode  : Integer;
    exponent : Integer; //> e.g. 2 ==> 1 dollar = 10^2 cent
    minor    : String; //> e.g. cent
}

annotate temporal with {
    validFrom @title: '{i18n>validFrom}';
    validTo   @title: '{i18n>validTo}';
};

extend sap.common.Countries with {
    code1           : Integer;
    alpha3          : String(3);
    iso             : String(16);
    region          : String(20);
    sub_region      : String(40);
    region_code     : String(3);
    sub_region_code : String(3);
    regions         : Composition of many sap.common_Countries.Regions
                          on regions.country = $self.code;
}

annotate sap.common.Countries with {
    code1           @(
        title       : '{i18n>code1}',
        Common.Label: '{i18n>code1}'
    );
    alpha3          @(
        title       : '{i18n>alpha3}',
        Common.Label: '{i18n>alpha3}'
    );
    iso             @(
        title       : '{i18n>iso}',
        Common.Label: '{i18n>iso}'
    );
    region          @(
        title       : '{i18n>region}',
        Common.Label: '{i18n>region}'
    );
    sub_region      @(
        title       : '{i18n>sub_region}',
        Common.Label: '{i18n>sub_region}'
    );
    region_code     @(
        title       : '{i18n>region_code}',
        Common.Label: '{i18n>region_code}'
    );
    sub_region_code @(
        title       : '{i18n>sub_region_code}',
        Common.Label: '{i18n>sub_region_code}'
    );
};

context opensap.common {
    type BusinessKey : String(10);
    type SDate       : DateTime;

    type AmountT     : Decimal(15, 2) @(
        Semantics.amount.currencyCode: 'CURRENCY_code',
        sap.unit                     : 'CURRENCY_code'
    );

    type QuantityT   : Decimal(13, 2) @title: '{i18n>quantity}';
    type UnitT       : String(3) @title: '{i18n>quantityUnit}';

    type StatusT     : String(1) enum {
        New          = 'N';
        Incompleted  = 'I';
        Approved     = 'A';
        Rejected     = 'R';
        Confirmed    = 'C';
        Saved        = 'S';
        Delivered    = 'D';
        Cancelled    = 'X';
    };

    aspect Quantity {
        quantity     : QuantityT;
        quantityUnit : UnitT;
    }

    aspect Amount {
        currency    : Currency;
        grossAmount : AmountT;
        netAmount   : AmountT;
        taxAmount   : AmountT;
    }

    annotate Amount with {
        grossAmount @title: '{i18n>grossAmount}';
        netAmount   @title: '{i18n>netAmount}';
        taxAmount   @title: '{i18n>taxAmount}';
    };

    type Gender      : String(1) enum {
        male         = 'M';
        female       = 'F';
        nonBinary    = 'N';
        noDisclosure = 'D';
        selfDescribe = 'S';
    }

    annotate Gender with @(
        title      : '{i18n>gender}',
        description: '{i18n>gender}',
        assert.enum
    );

    type Email       : String(255)  @title: '{i18n>email}'  @assert.format: '^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    type PhoneNumber : String(30)  @title: '{i18n>phoneNumber}'  @assert.format: '((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))';
}

context sap.common_Countries {
    entity Regions {
        key country     : String(3);
        key sub_code    : String(3);
            toCountries : Association to one sap.common.Countries
                              on toCountries.code = $self.country;
            name        : String(80);
            type        : String(80);
    }

    annotate Regions with {
        country  @(
            title       : '{i18n>country}',
            Common.Label: '{i18n>country}'
        );
        sub_code @(
            title       : '{i18n>sub_code}',
            Common.Label: '{i18n>sub_code}'
        );

        name     @(
            title              : '{i18n>name}',
            Common.FieldControl: #Mandatory,
            Search.defaultSearchElement,
            Common.Label       : '{i18n>name}'
        );
        type     @(
            title       : '{i18n>type}',
            Common.Label: '{i18n>type}'
        );
    }


    define view iso_countries_regions as
        select from sap.common_Countries.Regions {
            country          as COUNTRY_CODE,
            toCountries.name as COUNTRY_NAME,
            sub_code,
            name,
            type
        };

    define view iso_us_states as
        select from sap.common_Countries.Regions {
            sub_code,
            name
        }
        where
                country = 'US'
            and type    = 'State';

    define view iso_us_states_and_territories as
        select from sap.common_Countries.Regions {
            sub_code,
            name
        }
        where
            country = 'US';

    define view counties as
        select from sap.common.Countries {
            @EndUserText.label: [{
                language: 'EN',
                text    : 'Country Name'
            }]
            name,
            @EndUserText.label: [{
                language: 'EN',
                text    : 'Country Code'
            }]
            code
        };
}

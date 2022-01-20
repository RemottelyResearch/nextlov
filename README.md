# shop_reference

## Need to improve:
- Forget password ⚠️✅
- Confirm email on register ⚠️✅
- Verify and confirm email on login ⚠️✅
- Google SignIn ⚠️✅
- Loading animation on items ⭕
- Redirect to whatsapp ✅
- Create Categories ✅
- Create all products outside categories ✅
- Error when load all products, images was not saving into both collections ⚠️✅
- Format send email verification ⭕
- Users:
    - Generate random code for what? ⚠️✅
    - ImageProfile only on google SignIn create ⚠️✅
    - ImageProfile for facebook SignIn create ⚠️⭕
    - ImageProfile for SignUp create ⚠️⭕
- Create Insert Stores Locations Screen ⭕
- Format everything to be named parameters ⭕
- Set all orders status filter enabled by default ✅
- Set icon into Filters SlidingUpPanel ✅

## _______________________________

## Need to fix on original project:
- Cart error when deleted a product from products collection ⚠️⭕
- Refact User() to UserModel() ⚠️✅
- Remove all whitespace on inputs ⚠️✅
- CEP mask ⚠️✅
- Credit Card mask ⚠️✅
    - Number mask ⚠️✅
    - Validate date mask ⚠️✅
- Error Invalid Credentials ⚠️⭕ > its about course problem. dont have to be fixed.
<!-- - Home page not loading when the app opens at first time ⚠️⭕
    - maybe the solution:
        - Firebase.initializeApp(); ⚠️⭕
        - await ⚠️⭕ --> FIXED BY YOURSELF
- packages deprecated ⛔
- Facebook Login not working ⛔
- FunctionsError fix: ⚠️✅
    - sandbox: true, ⚠️✅
    - debug: true, ⚠️✅
- User token not deleting when logout ⚠️✅

## _______________________________

## Need to implement each project:
- flutter pub run change_app_package_name:main com.new.package.name
- Customize the app: ⚠️⭕
    - Change the package name ⚠️⭕
    - Insert the google-services ⚠️⭕
    - Configure firebase products: ⚠️⭕
        - Login email/password ⚠️✅
        - Login Facebook: ⛔
            - Go to facebook.com configurations ⛔
        - Activate Firebase Blaze Plan ⚠️✅
    - functions:
        - $ cd functions ⚠️✅
        - $ npm install ⚠️✅
        - set functions.config().cielo.merchantid; ⚠️✅
        - set functions.config().cielo.merchantkey; ⚠️✅
        - Class 163. sandbox > dev mode > change to a real key later: ⚠️✅
            - https://cadastrosandbox.cieloecommerce.cielo.com.br ⚠️✅
            - $ firebase functions:config:set cielo.merchantid="30cdfad2-3fbb-442a-9c76-e440ee67d6e2" ⚠️✅
            - $ firebase functions:config:set cielo.merchantkey="OSKVVKHHQYLMSQUKYRWLFQEWHFMIBMTGEHNEUJHD" ⚠️✅
            - $ firebase functions:config:get ⚠️✅
            - $ firebase deploy --only functions ⚠️✅
    - include some firestore documents configuring the data about CEP and delivery distance ⚠️✅
        - Class 59. set user in admin collection ⚠️✅
        - Class 102 & 103. calculating distance > set lat, long, km, maxkm, base ⚠️✅
        - Class 110. aux/ordercounter ⚠️✅
    - Config Firestore roles:
        - For test and run ⚠️✅
        - For secure access ⚠️⭕
    - 137. Set Storeslocations on Firebase ⛔
        
Test data example: ⚠️✅
    - CEP: 13.087-000 ⚠️✅
    - Credit Card:
        - Number: 43?? ???? ???? ???1
        - Date: 11/2028
        - Titular: Kevin Kobori
        - Verification: 235
    - CPF: 385.631.880-11

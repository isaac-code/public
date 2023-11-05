workspace {

    model {
        agent = person "Agent" "Process Transation for Customers"
        agentMobileDevice = person "Mobile Device"
        admin = person "Admin" "Manages Platform"
        switchVendor = softwareSystem "Switch Vendor"
        otherBankSystem = softwareSystem "Other Bank" {
            otherBankApp = container "Other Bank App"
        }
        nibssBankingSystem = softwareSystem "NIBSS Banking System" {
            ftCreditProcessor = container "Credit Processor"
            tsqProcessor = container "TSQ Processor"
        }
        pushNotificationVendor = softwareSystem "Push Notification Vendor"
        transferVendor = softwareSystem "Transfer Vendor"
        rechargeVendor = softwareSystem "Recharge Vendor"
        billVendor = softwareSystem "Bill Vendor"
        verificationVendor = softwareSystem "Verification Vendor"
        
        agencyBankingSystem = softwareSystem "Agency Banking System" "Agency Banking" {
            posTerminal = container "POS Device" "Mutiple Language" "Android POS and Conventional POS"
            mobileApp = container "Mobile App" "Flutter" "Android/IOS App for Agency Banking"
            webApp = container "Web App" "NextJS" "Agency Web App"
            tms = container "Terminal Management Service" "JAVA" "Manages POS Terminals" {
                terminalProductModule = component "Terminal Product Module"
                terminalAccountModule = component "Terminal Account Module"
                terminalTransactionProcessorModule = component "Terminal Transaction Processor Module"
            }
            terminalSwitchService = container "Terminal Switch Service" "JAVA" {
                terminalTransactionProcessor = component "Terminal Transaction Processor"
                terminalOracleServiceModule = component "Oracle Servie Module"
                switchVendorModule = component "Switch-Vendor Module"
            }
            watchtower = container "Watchtower" "NextJS" "Admin Portal"
            appService = container "App Service" "NestJS" "Interface for Apps" {
                appProductModule = component "App Product Module"
                appAccountModule = component "App Account Module"
                appTransactionProcessorModule = component "App Transaction Processor Module"
            }
            pushNotificationService = container "Push Notification Service" "JAVA" "Manages Push Notification" {
                terminalPushNotificationModule = component "Terminal Push Notification Module"
                appPushNotificationModule = component "App Push Notification Module"
            }
            watchtowerService = container "Watchtower Service" "NestJS" "Interface for Admin Portal"
            iamService = container "IAM Service" "JAVA" "User Management and Authentication" {
                accountCreationModule = component "IAM Account Creation Module" "Manage Account Creation"
                authenticationModule = component "IAM Authentication Module" "Manage User Authentication"
                userManagementModule = component "User Management Module" "Manage Users"
                permissionModule = component "IAM Permission Module" "Manage Permissions"
            }
            identityVerificationService = container "Verification Service" "JAVA" "Manages Verification using Vendors" {
                userVerificationModule = component "Manage User Verification with Vendors"
            }
            inventoryService = container "Inventory Service" "JAVA" "Manages Product And Service List with their Category and their Pricing including Commissions" {
                productCategoryModule = component "Product Category Module" "Category include bill, cashout, transfer, recharge"
                productModule = component "Product Module"
                pricingGroupModule = component "Pricing Module"
            }
            nipWebService = container "NIP Web Service" "JAVA" "Process NIP Request" {
                nipFTCreditProcessorModule = component "NIP FT Credit Processor Module"
                nipTransactionResolverModule = component "NIP Transaction Resolver Module"
            }
            nubanAccountService = container "Nuban Account Service" "JAVA" "Manage NUBAN Account" {
                nubanAccountModule = component "NUBAN Account Module"
            }
            transactionProcessor = container "Transaction Processor" "JAVA" "Process Transaction through Vendors and Keep Track of them" {
                transactionProcessingModule = component "Transaction Processing Module" ""
                transactionIdempotencyModule = component "Transaction Idempotency Module"
                transactionResolverModule = component "Transaction Resolver Module" "Ensures Completion of Transaction In Pending State"
            }
            walletService = container "Wallet Service" "JAVA" "Manage Account Wallet" {
                accountWalletModule = component "Manage Account Debit And Credit"
            }
            oracleService = container "Oracle Service" "RUST" "Prediction Service" {
                oracleVendorModule = component "Oracle Product/Switch Vendor Module"
                predictionModule = component "Prediction Module"
            }
            transferService = container "Transfer Service" "JAVA" "Manages Transfer Vendor Integration"
            rechargeService = container "Recharge Service" "JAVA" "Manages Recharge Vendor Integration"
            billService = container "Bill Service" "JAVA" "Manages Bill Vendor Integration"
            communicationService = container "Communication Service" "JAVA" "Manage Sending Message/Email" {
                otpModule = component "OTP Module"
            }
            disputeReconciliationService = container "Dispute Reconciliation Service" "JAVA" "Automatically Reconcile Dispute Raised from Banks" {
                disputeModule = component "Dispute Module"
                reconciliationModule = component "Automated Reconciliation Module"
            }
        }
        
        #Usage
        agent -> posTerminal "Uses"
        agent -> mobileApp "Uses"
        agent -> webApp "Uses
        admin -> watchtower "Uses"
        
        #User Interface Interactions
        posTerminal -> tms "Interacts"
        mobileApp -> appService "Interacts"
        webApp -> appService "Interacts"
        watchtower -> watchtowerService "Interacts"
        
        #Create Account"
        terminalAccountModule -> accountCreationModule "Create User Account" "GRPC"
        appAccountModule -> accountCreationModule "Create User Account" "GRPC"
        watchtowerService -> accountCreationModule "Create Admin User Account" "GRPC"
        accountCreationModule -> otpModule "Generate Account Creation OTP"
        otpModule -> agentMobileDevice "Send OTP to Agent"
        accountCreationModule -> userVerificationModule "User Verification" "GRPC"
        userVerificationModule -> verificationVendor "Process Verification"
        
        #Authentication (Login/Change Password/Reset Password)
        terminalAccountModule -> authenticationModule "Authenticate User Account" "GRPC" "Login/Change Password/Reset Password"
        appAccountModule -> authenticationModule "Authenticate User Account" "GRPC" "Login/Change Password/Reset Password"
        watchtowerService -> authenticationModule "Authenticate User Account" "GRPC" "Login/Change Password/Reset Password"
        
        #CRUD Product Category
        watchtowerService -> productCategoryModule "CRUD Product Category" "GRPC"
        
        #CRUD Product
        watchtowerService -> productModule "CRUD Product" "GRPC"
        watchtowerService -> pricingGroupModule "CRUD Product Pricing Group" "GRPC"
        watchtowerService -> oracleVendorModule "CRUD Oracle Product/Switch Vendor" "GRPC"
        
        #Fetch Product
        terminalProductModule -> productModule "Fetch Product for POS" "GRPC"
        appProductModule -> productModule "Fetch Product for APP" "GRPC"
        
        #Perform Terminal Transaction
        terminalTransactionProcessorModule -> terminalTransactionProcessor "Process Transaction" "GooglePubSub"
        terminalTransactionProcessor -> predictionModule "Predict Switch Vendor" "GRPC"
        terminalTransactionProcessor -> switchVendorModule "Process Card Transaction" "ISO/REST"
        switchVendorModule -> switchVendor "Process Card Transaction With Vendor" "ISO/REST"
        terminalTransactionProcessor -> transactionProcessingModule "Create Transaction" "GooglePubSub"
        
        #Perform APP Transaction
        appTransactionProcessorModule -> transactionProcessingModule "Create Transaction" "GooglePubSub"
        
        #Processing Transaction
        transactionProcessingModule -> transactionIdempotencyModule "Lock Transaction with ActionUniqueID"
        transactionProcessingModule -> pricingGroupModule "Get Pricing And Commission For Transaction"
        
        #Charge For Transaction
        transactionProcessingModule -> accountWalletModule "Debit Account Based On Pricing"
        
        #Cashout/WalletTopup Transaction (Withdrawal/WalletTopup)
        transactionProcessingModule -> accountWalletModule "Credit Account Wallet Based on Cashout"
        
        #Transaction Vendor Prediction
        transactionProcessingModule -> predictionModule "Predict Product Vendor" "GRPC"
        
        #Perform Transfer Transaction
        transactionProcessingModule -> transferService "Process Transaction" "GooglePubSub" "Push Transaction to Vendor for Processing"
        transferService -> transferVendor "Process Transaction With Vendor" "REST"
        transferService -> transactionProcessingModule "Return Transaction Result" "GooglePubSub"
    
        #Perform Recharge Transaction
        transactionProcessingModule -> rechargeService "Process Transaction" "GooglePubSub" "Push Transaction to Vendor for Processing"
        rechargeService -> rechargeVendor "Process Transaction With Vendor" "REST"
        rechargeService -> transactionProcessingModule "Return Transaction Result" "GooglePubSub"
        
        #Perform Bill Transaction
        transactionProcessingModule -> billService "Process Transaction" "GooglePubSub" "Push Transaction to Vendor for Processing"
        billService -> billVendor "Process Transaction With Vendor" "REST"
        billService -> transactionProcessingModule "Return Transaction Result" "GooglePubSub"
        
        #Transaction Resolution
        transactionResolverModule -> transactionProcessingModule "Process Pending Transaction" "GooglePubSub" "Loops through DB to get pending transaction and tries to complete them or assert them failed"
        
        #Successful Transaction Completion
        transactionProcessingModule -> terminalPushNotificationModule "Push Final State of Transaction For Terminal Transaction"
        transactionProcessingModule -> appPushNotificationModule "Push Final State of Transaction For APP Transaction"
        
        #Push Notification
        terminalPushNotificationModule -> pushNotificationVendor "Push Notification To Terminal" "REST"
        appPushNotificationModule -> pushNotificationVendor "Push Notification To APP" "REST"
        pushNotificationVendor -> posTerminal "Vendor Push Notification To Terminal"
        pushNotificationVendor -> mobileApp "Vendor Push Notification To APP"
        
        #Dispute Reconciliation
        watchtowerService -> reconciliationModule "Upload Disputes from Banks"
        reconciliationModule -> reconciliationModule "Automatically Reconcile Dispute"
        
        #Wallet Topup
        agent -> otherBankApp "Make Funds Transfer Request"
        otherBankApp -> ftCreditProcessor "Send Funds Transfer Request"
        ftCreditProcessor -> nipFTCreditProcessorModule "Send Funds Transfer Request" "SOAP"
        nipFTCreditProcessorModule -> nubanAccountModule "Name Enquiry" "GRPC"
        nipFTCreditProcessorModule -> tsqProcessor "Transaction Status Query" "SOAP"
        nipFTCreditProcessorModule -> transactionProcessingModule "Create Transaction" "PubSub"
        
        #NIP Transaction Resolver
        nipTransactionResolverModule -> nipFTCreditProcessorModule "Process Pending NIP Transaction" "PubSub"
        
    }

    views {
        theme default
    }
    
}
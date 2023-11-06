workspace {

    model {
        agent = person "Agent" "Process Transation for Customers"
        agentMobileDevice = person "Mobile Device"
        admin = person "Admin" "Manages Platform"
        switchServiceProvider = softwareSystem "Switch Service Provider"
        otherBankSystem = softwareSystem "Other Bank" {
            otherBankApp = container "Other Bank App"
        }
        nibssBankingSystem = softwareSystem "NIBSS Banking System" {
            ftCreditProcessor = container "Credit Processor"
            tsqProcessor = container "TSQ Processor"
        }
        pushNotificationServiceProvider = softwareSystem "Push Notification Service Provider"
        transferServiceProvider = softwareSystem "Transfer Service Provider"
        rechargeServiceProvider = softwareSystem "Recharge Service Provider"
        billServiceProvider = softwareSystem "Bill Service Provider"
        verificationServiceProvider = softwareSystem "Verification Service Provider"
        
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
                switchServiceProviderModule = component "Switch-Service Provider Module"
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
            identityVerificationService = container "Verification Service" "JAVA" "Manages Verification using Service Providers" {
                userVerificationModule = component "Manage User Verification with Service Providers"
            }
            inventoryService = container "Inventory Service" "JAVA" "Manages Product And Service List with their Category and their Pricing including Commissions" {
                serviceModule = component "Service Module" "Service include bill, cashout, transfer, recharge"
                productModule = component "Product Module"
                feeCatalogueModule = component "Fee Catalogue Module"
            }
            nipWebService = container "NIP Web Service" "JAVA" "Process NIP Request" {
                nipFTCreditProcessorModule = component "NIP FT Credit Processor Module"
                nipTransactionResolverModule = component "NIP Transaction Resolver Module"
            }
            nubanAccountService = container "Nuban Account Service" "JAVA" "Manage NUBAN Account" {
                nubanAccountModule = component "NUBAN Account Module"
            }
            transactionProcessor = container "Transaction Processor" "JAVA" "Process Transaction through Service Providers and Keep Track of them" {
                transactionProcessingModule = component "Transaction Processing Module" ""
                transactionIdempotencyModule = component "Transaction Idempotency Module"
                transactionResolverModule = component "Transaction Resolver Module" "Ensures Completion of Transaction In Pending State"
            }
            walletService = container "Wallet Service" "JAVA" "Manage Account Wallet" {
                accountWalletModule = component "Manage Account Debit And Credit"
            }
            oracleService = container "Oracle Service" "RUST" "Prediction Service" {
                oracleServiceProviderModule = component "Oracle Product/Switch Service Provider Module"
                predictionModule = component "Prediction Module"
            }
            transferService = container "Transfer Service" "JAVA" "Manages Transfer Service Provider Integration"
            rechargeService = container "Recharge Service" "JAVA" "Manages Recharge Service Provider Integration"
            billService = container "Bill Service" "JAVA" "Manages Bill Service Provider Integration"
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
        userVerificationModule -> verificationServiceProvider "Process Verification"
        
        #Authentication (Login/Change Password/Reset Password)
        terminalAccountModule -> authenticationModule "Authenticate User Account" "GRPC" "Login/Change Password/Reset Password"
        appAccountModule -> authenticationModule "Authenticate User Account" "GRPC" "Login/Change Password/Reset Password"
        watchtowerService -> authenticationModule "Authenticate User Account" "GRPC" "Login/Change Password/Reset Password"
        
        #CRUD Product/Service/Fee
        watchtowerService -> serviceModule "CRUD Service" "GRPC"
        watchtowerService -> productModule "CRUD Product" "GRPC"
        watchtowerService -> feeCatalogueModule "CRUD Fee Catalogue" "GRPC"
        watchtowerService -> oracleServiceProviderModule "CRUD Oracle Product/Switch Service Provider" "GRPC"
        
        #Fetch Product/Service
        terminalProductModule -> productModule "Fetch Product for POS" "GRPC"
        appProductModule -> productModule "Fetch Product for APP" "GRPC"
        terminalProductModule -> serviceModule "Fetch Service for POS" "GRPC"
        appProductModule -> serviceModule "Fetch Service for APP" "GRPC"
        
        #Perform Terminal Transaction
        terminalTransactionProcessorModule -> terminalTransactionProcessor "Process Transaction" "GooglePubSub"
        terminalTransactionProcessor -> predictionModule "Predict Switch Service Provider" "GRPC"
        terminalTransactionProcessor -> switchServiceProviderModule "Process Card Transaction" "ISO/REST"
        switchServiceProviderModule -> switchServiceProvider "Process Card Transaction With Service Provider" "ISO/REST"
        terminalTransactionProcessor -> transactionProcessingModule "Create Transaction" "GooglePubSub"
        
        #Perform APP Transaction
        appTransactionProcessorModule -> transactionProcessingModule "Create Transaction" "GooglePubSub"
        
        #Processing Transaction
        transactionProcessingModule -> transactionIdempotencyModule "Verify Not Duplicate ActionUniqueID"
        transactionProcessingModule -> transactionIdempotencyModule "Lock Transaction with ActionUniqueID"
        transactionProcessingModule -> feeCatalogueModule "Get Pricing For Transaction"
        
        #Charge For Transaction
        transactionProcessingModule -> accountWalletModule "Debit Account Based On Pricing"
        
        #Cashout/WalletTopup Transaction (Withdrawal/WalletTopup)
        transactionProcessingModule -> accountWalletModule "Create and Credit Account Wallet Based on Cashout"
        
        #Transaction ServiceProvider Prediction
        transactionProcessingModule -> predictionModule "Predict Product Service Provider" "GRPC"
        
        #Perform Transfer Transaction
        transactionProcessingModule -> transferService "Process Transaction" "GooglePubSub" "Push Transaction to Service Provider for Processing"
        transferService -> transferServiceProvider "Process Transaction With Service Provider" "REST"
        transferService -> transactionProcessingModule "Return Transaction Result" "GooglePubSub"
    
        #Perform Recharge Transaction
        transactionProcessingModule -> rechargeService "Process Transaction" "GooglePubSub" "Push Transaction to Service Provider for Processing"
        rechargeService -> rechargeServiceProvider "Process Transaction With Service Provider" "REST"
        rechargeService -> transactionProcessingModule "Return Transaction Result" "GooglePubSub"
        
        #Perform Bill Transaction
        transactionProcessingModule -> billService "Process Transaction" "GooglePubSub" "Push Transaction to Service Provider for Processing"
        billService -> billServiceProvider "Process Transaction With Service Provider" "REST"
        billService -> transactionProcessingModule "Return Transaction Result" "GooglePubSub"
        
        #Transaction Resolution
        transactionResolverModule -> transactionProcessingModule "Process Pending Transaction" "GooglePubSub" "Loops through DB to get pending transaction and tries to complete them or assert them failed"
        
        #Successful Transaction Completion
        transactionProcessingModule -> feeCatalogueModule "Get Commission For Transaction"
        transactionProcessingModule -> accountWalletModule "Create and Credit Commission Wallets"
        transactionProcessingModule -> terminalPushNotificationModule "Push Final State of Transaction For Terminal Transaction"
        transactionProcessingModule -> appPushNotificationModule "Push Final State of Transaction For APP Transaction"
        
        #Push Notification
        terminalPushNotificationModule -> pushNotificationServiceProvider "Push Notification To Terminal" "REST"
        appPushNotificationModule -> pushNotificationServiceProvider "Push Notification To APP" "REST"
        pushNotificationServiceProvider -> posTerminal "Service Provider Push Notification To Terminal"
        pushNotificationServiceProvider -> mobileApp "Service Provider Push Notification To APP"
        
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
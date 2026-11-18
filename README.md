# First-Solidity-Contract
This is my first solidity contract written for Patient Consent and Authorization

# Accounts Used in this project

Label	Remix account	Role in the test	InThePortal
A0	1st account in the list	Administrator, the account that deploys the contract	Admin
A1	2nd account	Patient	Patient
A2	3rd account	Healthcare provider	HealthCareProvider
A3	4th account	Second account used for unauthorized attempts	Hacker
<img width="924" height="146" alt="image" src="https://github.com/user-attachments/assets/1879139e-9e1e-42ff-a946-084a7b0c464a" />

# Problem Statement and Objectives 

Healthcare data is among the most sensitive information that organisations hold. A patient should be 
able to decide which healthcare provider may access their information, for what purpose and for how 
long, and should be able to withdraw that permission at any time. In conventional systems consent is 
often stored in a central database that the hospital itself controls, which makes consent records hard 
to audit and easy to alter without the patient noticing. 
This practical builds a prototype smart contract that records simulated patient consent on a 
blockchain, lets the patient grant and revoke provider access, and maintains the current consent 
status in a tamper evident way. No real patient data is used. Patients and providers are represented 
only by Ethereum style addresses and no medical content is stored. 

# Objectives 
• Design and implement a Solidity smart contract that records consent between a patient and a 
healthcare provider. 
• Allow a patient to grant, renew and revoke access, and allow anyone to verify the current consent 
status. 
• Restrict administrative actions to an administrator and access requests to registered providers. 
• Validate inputs and reject duplicate, invalid and unauthorized operations with clear error 
messages. 
• Compile, deploy and test the contract in Remix IDE using the Remix VM and document at least six 
test cases. 

# Test Cases

ID and description	Input or call	Expected outcome	Actual outcome	Result
TC1. Administrator registers a healthcare provider	registerProvider(doctor) from account 0	Transaction succeeds and registeredProviders(d octor) is true	Succeeded, registeredProviders	PASS
			TRUE	
TC2. Patient grants consent to a registered provider	grantConsent(doctor, "Treatment review", 2592000)	Transaction succeeds and status becomes Active	Succeeded, status = Active	PASS
	from account 1			
TC3. Retrieve and verify stored consent	hasAccess(patient, doctor) and getConsent(patient, doctor)	hasAccess returns true and purpose equals the stored purpose	hasAccess = true, status = Active, purpose = "Treatment review"	PASS
TC4. Registered provider requests access with active consent	requestAccess(patient) from account 2	Succeeds, AccessLogged event emitted, accessCount = 1	Succeeded, AccessLogged events = 1, accessCount = 1	PASS
TC5. Valid state update: renew active consent	renewConsent(doctor, 5184000) from account 1	Succeeds and expiresAt increases	Succeeded, expiresAt 1796404959 -> 1798996959	PASS
TC6. Duplicate consent while one is already active	grantConsent(doctor, "Second grant", 864000) from account 1	Reverts with "Consent already active"	Reverted: Consent already active	PASS
TC7. Unauthorized provider registration by a	registerProvider(stranger) from account 3	Reverts with "Only administrator"	Reverted: Only administrator	PASS
non-administrator				
TC8. Unregistered account tries to request patient access	requestAccess(patient) from account 3	Reverts with "Not a registered provider"	Reverted: Not a registered provider	PASS
TC9. Grant consent to a provider who is not registered	grantConsent(stranger, "Checkup", 86400) from	Reverts with "Provider not registered"	Reverted: Provider not registered	PASS
	account 1			
TC10. Invalid inputs rejected: zero duration, empty purpose, zero address	grantConsent(stranger, "Checkup", 0); grantConsent(stranger, "", 86400);	Reverts with "Duration must be positive", "Purpose required" and "Invalid provider"	Duration must be positive | Purpose required | Invalid provider	PASS
	registerProvider(0x000...0)			
TC11. Boundary test on consent duration (maximum 365 days)	grantConsent(stranger, "Boundary max", 31536001) then grantConsent(stranger, "Boundary max", 31536000)	First reverts with "Duration exceeds maximum", second succeeds and status is Active	Reverted: Duration exceeds maximum | Succeeded, status = Active	PASS
TC12. Patient revokes consent (state transition to Revoked)	revokeConsent(doctor) from account 1	Succeeds, status becomes Revoked and hasAccess is false	Succeeded, status = Revoked, hasAccess = false	PASS
TC13. Repeated revoke of already revoked consent	revokeConsent(doctor) from account 1 again	Reverts with "No active consent"	Reverted: No active consent	PASS
TC14. Provider requests access after consent was revoked	requestAccess(patient) from account 2	Reverts with "Consent not active"	Reverted: Consent not active	PASS
<img width="1941" height="717" alt="image" src="https://github.com/user-attachments/assets/3097436b-8ce2-411f-9f4c-022ea1b950a4" />




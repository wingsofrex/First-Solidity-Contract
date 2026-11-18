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

<img width="1941" height="717" alt="image" src="https://github.com/user-attachments/assets/3097436b-8ce2-411f-9f4c-022ea1b950a4" />




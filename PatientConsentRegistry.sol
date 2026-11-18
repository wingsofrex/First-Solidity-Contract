// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PatientConsentRegistry
/// @notice Simulated patient consent and access authorization registry.
/// No real patient data is stored. Patients are represented by wallet addresses.
contract PatientConsentRegistry {
    enum Status { None, Active, Revoked, Expired }

    struct Consent {
        bool granted;
        bool revoked;
        uint64 grantedAt;
        uint64 expiresAt;
        string purpose;
    }

    uint256 public constant MAX_DURATION = 365 days;

    address public administrator;

    mapping(address => bool) public registeredProviders;
    mapping(address => mapping(address => Consent)) private consents;
    mapping(address => uint256) public accessCount;

    event ProviderRegistered(address indexed provider);
    event ProviderRemoved(address indexed provider);
    event ConsentGranted(address indexed patient, address indexed provider, string purpose, uint64 expiresAt);
    event ConsentRenewed(address indexed patient, address indexed provider, uint64 newExpiresAt);
    event ConsentRevoked(address indexed patient, address indexed provider);
    event AccessLogged(address indexed patient, address indexed provider, uint256 timestamp);

    constructor() {
        administrator = msg.sender;
    }

    modifier onlyAdministrator() {
        require(msg.sender == administrator, "Only administrator");
        _;
    }

    modifier onlyRegisteredProvider() {
        require(registeredProviders[msg.sender], "Not a registered provider");
        _;
    }

    // ---------- Administration ----------

    function registerProvider(address provider) external onlyAdministrator {
        require(provider != address(0), "Invalid provider");
        require(!registeredProviders[provider], "Provider already registered");
        registeredProviders[provider] = true;
        emit ProviderRegistered(provider);
    }

    function removeProvider(address provider) external onlyAdministrator {
        require(registeredProviders[provider], "Provider not registered");
        registeredProviders[provider] = false;
        emit ProviderRemoved(provider);
    }

    // ---------- Patient actions ----------

    function grantConsent(
        address provider,
        string calldata purpose,
        uint256 durationSeconds
    ) external {
        require(registeredProviders[provider], "Provider not registered");
        require(bytes(purpose).length > 0, "Purpose required");
        require(durationSeconds > 0, "Duration must be positive");
        require(durationSeconds <= MAX_DURATION, "Duration exceeds maximum");
        require(
            _status(msg.sender, provider) != Status.Active,
            "Consent already active"
        );

        uint64 expiry = uint64(block.timestamp + durationSeconds);
        consents[msg.sender][provider] = Consent({
            granted: true,
            revoked: false,
            grantedAt: uint64(block.timestamp),
            expiresAt: expiry,
            purpose: purpose
        });

        emit ConsentGranted(msg.sender, provider, purpose, expiry);
    }

    function renewConsent(address provider, uint256 durationSeconds) external {
        require(_status(msg.sender, provider) == Status.Active, "No active consent");
        require(durationSeconds > 0, "Duration must be positive");
        require(durationSeconds <= MAX_DURATION, "Duration exceeds maximum");

        uint64 expiry = uint64(block.timestamp + durationSeconds);
        consents[msg.sender][provider].expiresAt = expiry;

        emit ConsentRenewed(msg.sender, provider, expiry);
    }

    function revokeConsent(address provider) external {
        require(_status(msg.sender, provider) == Status.Active, "No active consent");
        consents[msg.sender][provider].revoked = true;
        emit ConsentRevoked(msg.sender, provider);
    }

    // ---------- Provider actions ----------

    /// @notice A registered provider requests access to a patient. Reverts without valid consent.
    function requestAccess(address patient) external onlyRegisteredProvider {
        require(_status(patient, msg.sender) == Status.Active, "Consent not active");
        accessCount[patient] += 1;
        emit AccessLogged(patient, msg.sender, block.timestamp);
    }

    // ---------- Views ----------

    function getConsentStatus(address patient, address provider) external view returns (Status) {
        return _status(patient, provider);
    }

    function hasAccess(address patient, address provider) external view returns (bool) {
        return registeredProviders[provider] && _status(patient, provider) == Status.Active;
    }

    function getConsent(address patient, address provider)
        external
        view
        returns (Status status, string memory purpose, uint64 grantedAt, uint64 expiresAt)
    {
        Consent storage c = consents[patient][provider];
        return (_status(patient, provider), c.purpose, c.grantedAt, c.expiresAt);
    }

    // ---------- Internal ----------

    function _status(address patient, address provider) internal view returns (Status) {
        Consent storage c = consents[patient][provider];
        if (!c.granted) return Status.None;
        if (c.revoked) return Status.Revoked;
        if (block.timestamp >= c.expiresAt) return Status.Expired;
        return Status.Active;
    }
}

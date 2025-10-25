🛑 Approval Drain Trap (Phishing / Allowance Exploit Detector)

This trap detects when a wallet suddenly grants a large ERC-20 token allowance to a spender, which often happens during phishing attacks, malicious dApps, or approval-drain exploits (e.g., “Approve Unlimited Tokens” scams).

✅ What It Detects

This trap monitors ERC-20 token approvals and triggers if:

✔ A wallet grants an allowance to a spender that exceeds a threshold, and
✔ The allowance increased compared to earlier snapshots, and
✔ The data is collected in a way that cannot revert (safe collect with try/catch).

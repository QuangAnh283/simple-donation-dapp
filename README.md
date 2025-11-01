# 💛 Simple Donation DApp (CELO + Foundry)

Dự án này là một **ứng dụng phi tập trung (DApp)** đơn giản cho phép người dùng gửi **donation (ủng hộ)** bằng CELO vào một smart contract, và chủ sở hữu (owner) có thể rút toàn bộ tiền.

## ⚙️ Công nghệ sử dụng

- [Foundry](https://book.getfoundry.sh/) — Framework phát triển smart contract bằng Solidity
- [Solidity](https://soliditylang.org/) — Ngôn ngữ viết smart contract
- [Ethers.js](https://docs.ethers.org/) — Kết nối frontend với blockchain
- [MetaMask](https://metamask.io/) — Ví để kết nối và ký giao dịch
- [CELO Testnet](https://celo.org/developers) — Mạng blockchain dùng để thử nghiệm

---

## 📁 Cấu trúc thư mục

hello_foundry/
├── src/
│ └── Counter.sol # Smart contract chính (donation)
├── script/
│ └── Counter.s.sol # Script triển khai contract
├── test/
│ └── Counter.t.sol # Unit test contract
├── out/
│ └── Counter.sol/Counter.json # ABI + metadata sau khi build
├── index.html # Frontend giao diện web
├── foundry.toml
├── .env # Chứa PRIVATE_KEY và CELO_RPC_URL
└── README.md

---

## 🚀 Cài đặt môi trường

###

1️⃣ Cài Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup

```

2️⃣ Kiểm tra phiên bản
forge --version
Nên dùng Foundry 1.3.0 hoặc cao hơn.

3️⃣ Cấu hình .env
Tạo file .env:

PRIVATE_KEY=0x_your_wallet_private_key
CELO_RPC_URL=https://forno.celo-sepolia.celo-testnet.org
🧱 Smart Contract
File: src/Counter.sol

solidity
Sao chép mã
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
address public owner;
uint public totalDonations;

    struct Donor {
        address addr;
        uint amount;
    }

    Donor[] public donors;

    event DonationReceived(address indexed donor, uint amount);
    event Withdraw(address indexed owner, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function donate() external payable {
        require(msg.value > 0, "Must send CELO to donate");
        totalDonations += msg.value;
        donors.push(Donor(msg.sender, msg.value));
        emit DonationReceived(msg.sender, msg.value);
    }

    function getDonors() external view returns (Donor[] memory) {
        return donors;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint amount = address(this).balance;
        payable(owner).transfer(amount);
        emit Withdraw(owner, amount);
    }

}
🧪 Kiểm thử
Chạy lệnh:

forge test
Kết quả mong đợi:

Ran 6 tests for test/Counter.t.sol:CounterTest
[PASS] testDonateIncreasesTotal()
[PASS] testInitialState()
[PASS] testMultipleDonations()
[PASS] testWithdrawByOwner()
[PASS] test_RevertWhen_DonateZeroValue()
[PASS] test_RevertWhen_NotOwnerWithdraws()
📤 Triển khai (Deploy)
Chạy lệnh deploy lên mạng CELO:

forge script script/Counter.s.sol --rpc-url $CELO_RPC_URL --private-key $PRIVATE_KEY --broadcast
Kết quả hiển thị:

✅ Deployed contract Counter at: 0x51165F4C1A141F81865d5b45eeb75D8a02718cCC
Copy lại địa chỉ contract và mở file:

pgsql
out/Counter.sol/Counter.json
→ Copy phần "abi": [...]

🌐 Frontend (index.html)
File: index.html

Kết nối MetaMask

Hiển thị danh sách người donate

Gửi CELO

Withdraw cho owner

Chạy frontend local:
python -m http.server 5500
Mở trình duyệt tại:

http://localhost:5500/index.html
Sau khi kết nối ví, bạn có thể:

Nhập số CELO và Donate 💰

Xem danh sách Donors 👥

Nếu là owner, có thể Withdraw 🏦

🔒 Ghi chú bảo mật
Không chia sẻ PRIVATE_KEY công khai.

DApp chỉ dùng cho mục đích học tập hoặc demo.

Đảm bảo bạn đang sử dụng CELO Testnet, không phải mainnet.

✨ Tác giả
Phenikaa University — IT Student Project
Người phát triển: [Bạch Quang Anh,Lê Ngọc Diệp]
Liên hệ: [https://github.com/QuangAnh283]

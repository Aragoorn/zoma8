// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseMultiSplitter {
    // آدرس مالک قرارداد
    address public immutable owner;
    string public constant contractVersion = "5.5.0-PRO";

    // آرایه‌ای از ذینفعان و سهم هر کدام (بر حسب درصد، جمعاً باید 100 شود)
    address[] public payees;
    mapping(address => uint256) public shares;
    uint256 public totalShares;

    // رویدادها برای رهگیری شفاف تراکنش‌ها در بیس‌اسکن
    event PaymentReceived(address indexed from, uint256 amount);
    event PaymentReleased(address indexed to, uint256 amount);
    event PayeeAdded(address indexed account, uint256 shares);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized: Owner only");
        _;
    }

    // در زمان دیپلوی، آدرس کیف پول خودت به عنوان مالک ثبت می‌شود
    constructor() {
        owner = msg.sender;
    }

    // ۱. تنظیم ذینفعان و سهم‌ها (فقط یک‌بار توسط مالک قابل اجراست)
    function setupPayees(address[] calldata _payees, uint256[] calldata _shares) external onlyOwner {
        require(totalShares == 0, "Payees already configured");
        require(_payees.length == _shares.length, "Mismatched arrays");
        require(_payees.length > 0, "No payees provided");

        for (uint256 i = 0; i < _payees.length; i++) {
            address payee = _payees[i];
            uint256 share = _shares[i];

            require(payee != address(0), "Invalid address");
            require(share > 0, "Share must be greater than 0");
            require(shares[payee] == 0, "Duplicate payee detected");

            payees.push(payee);
            shares[payee] = share;
            totalShares += share;

            emit PayeeAdded(payee, share);
        }
        
        require(totalShares == 100, "Total shares must equal exactly 100");
    }

    // ۲. دریافت اتریوم و توزیع آنی و خودکار بین ذینفعان
    receive() external payable {
        require(msg.value > 0, "No ETH sent");
        require(totalShares == 100, "Splitter not configured yet");

        uint256 amountReceived = msg.value;
        emit PaymentReceived(msg.sender, amountReceived);

        // تقسیم خودکار مبالغ بر اساس درصد سهم‌ها
        for (uint256 i = 0; i < payees.length; i++) {
            address payee = payees[i];
            // محاسبه سهم: (مبلغ کل * درصد سهم) / 100
            uint256 payment = (amountReceived * shares[payee]) / totalShares;

            if (payment > 0) {
                (bool success, ) = payable(payee).call{value: payment}("");
                require(success, "ETH transfer failed");
                emit PaymentReleased(payee, payment);
            }
        }
    }

    // تابع کمکی برای دیدن تعداد کل اعضا
    function getPayeesCount() external view returns (uint256) {
        return payees.length;
    }
}
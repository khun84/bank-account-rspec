require "rspec"

require_relative "account"

describe Account do
    let(:invalid_account_number) {'12321'}
    let(:account_number) {'1234567890'}
    let(:starting_balance) {50}
    let(:account) { Account.new(account_number, starting_balance) }
    let(:deposit_amt) {100}
    let(:withdrawal_amt) {starting_balance/2}

    describe "#initialize" do
        it 'should requires at least one argument' do
            expect{Account.new}.to raise_error ArgumentError
        end

        it 'should accept account number that is not valid' do
            expect{Account.new(invalid_account_number)}.to raise_error InvalidAccountNumberError
        end

        it 'should accept valid account number' do
            expect(Account.new(account_number).class).to eq(Account)
        end

    end

    describe "#transactions" do
        it 'should return an array object' do
            expect(account.transactions.class).to eq Array
        end

        it 'should return the transactions record' do
            expect(account.transactions.length).to eq 1
        end
    end

    describe "#balance" do
        it 'should return the current balance of the account' do
            expect(account.balance).to eq starting_balance
        end
    end

    describe "#account_number" do
        it 'should not return whole account number' do
            expect(account.acct_number).not_to eq account_number
        end

        it 'should masked the first 6 digits' do
            expect(account.acct_number[0..5]).to eq '*'*6
        end

        it 'should return the last 4 digits of the account number' do
            expect(account.acct_number[6..9]).to eq account_number[6..9]
        end
    end

    describe "deposit!" do
        it 'should require one argument' do
            expect{account.deposit!}.to raise_error ArgumentError
            expect{account.deposit!}.to raise_error ArgumentError
        end

        it 'should only take positive number as argument' do
            expect{account.deposit!(-100)}.to raise_error NegativeDepositError
        end

        context 'successful deposit transaction' do
            it 'should return the latest balance after deposit' do
                old_balance = account.balance
                balance = account.deposit!(deposit_amt)
                expect(balance).to eq old_balance + deposit_amt
            end

            it 'should add the deposit amount to the transactions' do
                transaction_length = account.transactions.length
                account.deposit!(deposit_amt)
                expect(account.transactions[transaction_length]).to eq deposit_amt
            end
        end

    end

    describe "#withdraw!" do
        it 'should require on argument' do
            expect{account.withdraw!}.to raise_error ArgumentError
        end

        it 'should not withdraw more than the balance' do
            withdrawal_amt = account.balance*2
            expect{account.withdraw! withdrawal_amt}.to raise_error OverdraftError
        end

        context 'successful withdrawal' do
            it 'should return the account balance after withdrawal' do
                balance = account.balance
                new_balance = account.withdraw! withdrawal_amt
                expect(new_balance).to eq (balance - withdrawal_amt)
            end

            it 'should add the withdrawal to the transaction records' do
                transactions_length = account.transactions.length
                account.withdraw! withdrawal_amt
                expect(account.transactions[transactions_length]).to eq -withdrawal_amt
            end
        end

    end
end
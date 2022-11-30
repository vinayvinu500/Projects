# banking System
ACCOUNTS = {}  # database

# create account
def create_new_account(acc_no):
    # write your code to create a new account
    if acc_no in ACCOUNTS:
        return f'Account no: {acc_no} already created!'
    ACCOUNTS[acc_no] = 0
    return f"Account no: {acc_no} created successfully!"

# withdraw
def withdraw(acc_no, amount):
    # Write your code to withdraw money and while doing so please ensure that the account has sufficient amount
    # and the account is a valid account
    if acc_no not in ACCOUNTS:
        return f'Account no: {acc_no} doesn\'t exists'

    if amount <= 0:
	    return f"Can't pass {amount} value!"

    # validate the amount is greater than account.balance
    if amount > ACCOUNTS[acc_no]:
        return f'Insufficent Balanace!'

    # process continues
    ACCOUNTS[acc_no] -= amount
    return f'Withdraw Amount: {amount} sucessfully debited!'

# deposit
def deposit(acc_no, amount):
    # Write your code to deposit money and while doing so please ensure that the account is a valid account
    if acc_no not in ACCOUNTS:
        return f'Account no: {acc_no} doesn\'t exists'
    if amount <= 0:
	    return f"Can't pass {amount} value!"
    ACCOUNTS[acc_no] += amount
    return f'Deposit Amount: {amount} sucessfully credited!'

# balance
def show_balance(acc_no):
    # Write your code to show balance
    if acc_no not in ACCOUNTS:
        return f'Account no: {acc_no} doesn\'t exists'
    return f'Current Balance: {ACCOUNTS[acc_no]}'

# representation
def show_menu():
    print("\n1. New Account Opening")
    print("2. Deposit money to account")
    print("3. Withdraw money from account")
    print("4. Show balance")
    print("5. Quit")


# user validation
def ask():
    show_menu()
    user = input('\nEnter the operation to be performed : ')
    try:
        assert user in map(str, range(1, 6))
    except:
        print('You entered Wrong!')
        return ask()
    else:
        return user
    show_menu()
    return ask()

# account_number validation
def acc_num():
    try:
        user = input('Enter account number : ')
        assert isinstance(user, str) and (user.isalnum() or user.isalpha() or user.isdigit())
    except:
        print('You entered Wrong!')
        return acc_num()
    else:
        return user
    return acc_num()

# amount validation
def amount():
    try:
        user = int(input('Enter amount : '))
        assert isinstance(user,int) and user > 0
    except:
        print('You entered Wrong!')
        return amount()
    else:
        return user
    return amount()
    

# run the script
if __name__ == "__main__":
    user = 1

    while user:
        user = ask()

        # match case # 3.10.8 version python
        match user:
            case '1':
                acc_number = acc_num()
                print(create_new_account(acc_number))

            case '2':
                acc_number = acc_num()
                amt = amount()

                print(deposit(acc_number, amt))

            case '3':
                acc_number = acc_num()
                amt = amount()

                print(withdraw(acc_number, amount))

            case '4':
                acc_number = acc_num()

                print(show_balance(acc_number))

            case '5':
                print("\nThanks for banking with us")
                break

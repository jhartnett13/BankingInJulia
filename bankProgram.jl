using CSV
using DataFrames
using Dates

function signIn()
    ### need to account for what to do if the user doesn't exist in the data set/ the password is incorrect

    println("Enter your name: ") # get the users name
    username = readline()
    df = CSV.read("userAccounts.csv", DataFrame) # dataframe of the users
    df2 = filter(:name => ==(username), df) # find the users name in the data set, make a data set of the users with that name
    println(df2)
    println("Enter your password: ") # get their password
    pass = readline()
    userRow = filter(:password => ==(pass), df2)
    println(userRow)


    # once they sign in -- have a second loop to select the other options

    # maybe this should return the file name of the users file??
end


function createAccount()
    # does this function do too much? it makes sense to me to have it all here
    println("Welcome! Thanks for opening a new account.")
    println("Enter your name: ")
    name = readline()
    
    password1 = 1 # have the user create a password
    while typeof(password1) != String # the passwords having to be a string makes the dataframe easier to work with
        println("Create a password for your account. Passwords must start with a letter: \n")
        password1 = readline()
    end
    
    # have the user enter their password again to verify that they match
    password2 = 2
    while password1 != password2
        println("Please verify your password: ")
        password2 = readline()
    end

    # have the user enter a starting balance for their account
    println("Enter your accounts starting balance: \$")
    startBalance = readline()
    startBalance = parse(Float64, startBalance)  #get a float of the start balance

    # create a file that will track their data
    timeStamp = Dates.now()
    timeStamp = Dates.format(timeStamp, "yyyy-mm-ddHH:MM:SS")
    timeStamp = replace(timeStamp, ":"=>"-")

    userFileName = name * timeStamp *".csv"
    
    ##########  WRITE THIS TO THE FILE OF ALL THE USERS #########################
    df = CSV.read("userAccounts.csv", DataFrame)
    println(df)
    push!(df, [name password1 startBalance userFileName])  ## work around is to have the first line be a bunch of nonsense
    CSV.write("userAccounts.csv", df)
    close("userAccounts.csv")

    # create a df of the users info
    date3 = Dates.today()
    df = DataFrame(Date = [date3], TransactionAmount = [startBalance], Category = ["Initial Deposit"], AccountTotal = [startBalance] )
    println(df)


    # create a file for the specific user
    touch(userFileName)
    openFile = open(userFileName, "w")
    CSV.write(userFileName, df)
    close(userFileName)
end


function useProgram() # might take in the users file name? so that cna be updated/data can be found and spent

    #once a user signs in, they will be directed here so signing in isn't an option anymore
    #once they exit from this loop they will be back at the signin /exit screen

    kg = "yes"
    println("What would you like to do? ")
    while kg == "yes"
        println("1. Enter a transaction (spending/withdrawl)")
        println("2. Enter a deposit")          # should transaction and deposit be the same thing???
        println("3. Set a Budget")
        println("4. View Statistics")
        println("5. Quit")
        choice = readline()
        choice = parse(Int64, choice)
        if choice == 1
            enterTransaction()
        elseif choice == 2
            enterDeposit()
        elseif choice == 3
            setBudget()
        elseif choice == 4
            getStats()
        elseif choice == 5
            global kg = "no"

        end
end



end


function enterTransaction() # take in users file
    kg = "yes"
    while kg == "yes"
        #enter the amount of the transaction

        #ask for the type of the transaction

        # if withdrawl then subtract the value from their total amount




    end



    println("Enter the amount you spent: \$")
    amount = readline()
    amount = parse(Float64, amount)
    println(amount)

    # ask the user for the transaction date, amount, and category. other data TBD
    # write the data to a file
    # keeping track of the balance
end

function enterDeposit() # take in the users file



    # ask the user for the deposit amount and date
    # update the account balance
end 

function setBudget()
    # will ask the user to select the category and set the percent of their budget to make the category
    # percents can not exceed 100%
    # will need to adjust based on the users balance

    # how much would you like to spend each month
    # 
end 

function getStats()
    # will give the user different options for stats they can get about their account
    # viewing spending by category, looking at data within a particular month, etc.
end


## main loop
kg = "yes"

println("Welcome! What would you like to do? ")
while kg == "yes"
    println("1. Sign in to my account")
    println("2. Create a new account")
    println("3. Quit")
    choice = readline()
    choice = parse(Int64, choice)
    if choice == 1
        signIn()
    elseif choice == 2
        createAccount()
    elseif choice == 3
        global kg = "no"

    end
end


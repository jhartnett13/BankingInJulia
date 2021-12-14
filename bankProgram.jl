using CSV
using DataFrames
using Dates
using Plots

function signIn()

    println("Enter your name: ") # get the users name
    username = readline()
    df = CSV.read("userAccounts.csv", DataFrame) # dataframe of the user
    df2 = filter(:userName => ==(username), df) # find the users name in the data set, make a data set of the users with that name

    println("Enter your password: ") # get their password
    pass = readline()
    userRow = filter(:password => ==(pass), df2) #this is still a dataframe

    printstyled("\nWelcome, $username \n", color = :cyan) 
    fileName = userRow[1, "transactionFile"] #the users transaction file
    
    useProgram(fileName)

end


function createAccount()
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
    push!(df, [name password1 startBalance userFileName])  ## work around is to have the first line be a bunch of nonsense
    #println(df)
    CSV.write("userAccounts.csv", df)

    # create a df of the users info
    date3 = Dates.today()
    df = DataFrame(Date = [date3], TransactionAmount = [startBalance], Category = ["Initial Deposit"], AccountTotal = [startBalance] )
    #println(df)

    # create a file for the specific user
    touch(userFileName)
    openFile = open(userFileName, "w")
    CSV.write(userFileName, df)

    useProgram(userFileName)
end


function useProgram(fileName)

    #once a user signs in, they will be directed here so signing in isn't an option anymore
    #once they exit from this loop they will be back at the signin /exit screen

    k = "yes"
    println("What would you like to do? ")
    while k == "yes"
        println("1. Enter a transaction (spending/withdrawal)")
        println("2. Enter a deposit")          
        println("3. View Statistics")
        println("4. Quit")
        choice = readline()
        choice = parse(Int64, choice)
        if choice == 1
            enterTransaction(fileName)
        elseif choice == 2
            enterDeposit(fileName)
        elseif choice == 3
            getStats(fileName)
        elseif choice == 4
             k = "no"

        end # end if else
    end # end loop
end # end function


function enterTransaction(fileName) # take in users file

    g = "yes"
    while g == "yes"
        println("Was this transaction 1. a cash withdrawal or 2. a purchase? Press 3 to quit")

        choice = readline()
        choice = parse(Int64, choice)

        println("What date was the transaction made? Enter in the following format: dd mm yyyy")
        strDate = readline()

        date = Dates.Date(strDate, "d m y")

        if choice == 1 # cash withdrawal
            println("Enter the amount of the withdrawal: ")
            amount = readline()
            amount = parse(Float64, amount)
            category = "Withdrawal"

        elseif choice == 2 # purchase
            println("Enter the amount of the purchase: ")
            amount = readline()
            amount = parse(Float64, amount)
            println("Select the category of the purchase: \n1. Shopping \n2. Food \n3. Entertainment \n4. Bills \n5.Other") # break this up if i have time later
            c = readline()
            c = parse(Int64, c)
            if c == 1
                category = "Shopping"
            elseif c == 2
                category = "Food"
            elseif c == 3
                category = "Entertainment"
            elseif c == 4
                category = "Bills"
            else
                category = "Other"
            end # end if else
            

        elseif choice == 3
            g = "no"
    
        end # end if else

    # update the account info

    df = CSV.read(fileName, DataFrame) #open the file as a dataframe
    numRows = nrow(df) #how many rows are in the dataframe
    accountBalance = df[numRows, "AccountTotal"] #get the current account total
    newAccountBalance = accountBalance - amount # new account balance - subtract the money just spent

    push!(df, [date amount category newAccountBalance])  ##  push to the dataframe date, transactionAmount, category, AccountTotal
    println(df)
    CSV.write(fileName, df)

    
    printstyled("\nYour account balance is currently $newAccountBalance \n", color = :cyan) #print out a message with the account balance
    
    println("Would you like to enter another transaction? Enter 1 for yes and 2 for no ")
    choice = readline()
    choice = parse(Int64, choice)
    if choice != 1
        g = "no"
    end #end if else
    end # end loop
end # end function



function enterDeposit(fileName) # take in the users file

    g = "yes"
    while g == "yes"
        println("Enter the amount of the deposit: ") # amount of the deposit
        amount = readline()
        amount = parse(Float64, amount)

        println("What date was the transaction made? Enter in the following format: dd mm yyyy") # date of the deposit
        strDate = readline()
        date = Dates.Date(strDate, "d m y")

        category = "Deposit"

        df = CSV.read(fileName, DataFrame)
        numRows = nrow(df) #how many rows are in the dataframe
        accountBalance = df[numRows, "AccountTotal"] #get the current account total
        newAccountBalance = accountBalance + amount # new account balance - add the money from the deposit

        push!(df, [date amount category newAccountBalance])  ##  push to the dataframe date, transactionAmount, category, AccountTotal
        println(df) #leaving this print in just to show dataframes
        CSV.write(fileName, df)

    
        printstyled("\nYour account balance is currently $newAccountBalance \n", color = :cyan) #print out a message with the account balance
    
        println("Would you like to enter another Deposit? Enter 1 for yes and 2 for no ")
        choice = readline()
        choice = parse(Int64, choice)
        if choice != 1
            g = "no"
        end # End if else
    end #End while loop
end #end function


function getStats(fileName)
    g = "yes"
    while g == "yes"
    println("What would you like to see? 1. Number of transactions by category 2. Total money per transaction category")
    choice = readline()
    choice = parse(Int64, choice)
    if choice == 1
        df = CSV.read(fileName, DataFrame)
        categoryCount = combine(groupby(df, :Category), nrow=>:count)
        bar(categoryCount.Category, categoryCount.count, title = "Number of Transactions by Category", color = :pink, legend = false)
        savefig("numTransactions.png")

    elseif choice == 2
        gdf = groupby(df, :Category)
        categorySum = combine(gdf, :TransactionAmount => sum)
        bar(categorySum.Category, categorySum.TransactionAmount_sum, title = "Total Money in Each Type of Transaction", color = :pink, legend = false)
        savefig("amountTransactions.png")
    end


    println("Would you like to see some more stats? Enter 1 for yes and 2 for no ")
    choice = readline()
    choice = parse(Int64, choice)
    if choice != 1
        g = "no"
    end # End if else


 end #end loop
    
end #end function


## main loop
kg = "yes"

printstyled("Welcome to the Bank of Julia!", color = :magenta)
printstyled("\nWhat would you like to do?\n", color = :magenta)

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

printstyled("\nThank you for using the Bank of Julia!", color = :cyan)


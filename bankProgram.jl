using CSV
using DataFrames
using Dates

function openFile(user)
    # code to open the file contatining the users info
end


function signIn()
    ### need to account for what to do if the user doesn't exist in the data set/ the password is incorrect

    println("Enter your name: ") # get the users name
    username = readline()
    df = CSV.read("userAccounts.csv", DataFrame) # dataframe of the users
    df2 = filter(:name => ==(username), df) # find the users name in the data set, make a data set of the users with that name
    println(df2)
    println("Enter your password: ") # get their password
    ########This is different for if its an int/string password!!!!!!!!!!!!1
    pass = readline()
    userRow = filter(:password => ==(pass), df2)
    println(userRow)


    #return(username, )




    # once they sign in -- have a second loop to select the other options

    # maybe this should return the file name of the users file??
end


function createAccount()
    # does this function do too much? it makes sense to me to have it all here
    println("Welcome! Thanks for opening a new account.")
    println("Enter your name: \n") # get the users name
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
    startBalance = parse(Int64, startBalance) #get an int of the start balance

    # create a file that will track their data
    timeStamp = Dates.now()
    timeStamp = Dates.format(timeStamp, "yyyy-mm-dd HH:MM:SS")

    println(timeStamp)

    userFileName = name * timeStamp *".csv"

    println(userFileName)

    # create an actual .csv file

    # write their data to the user file



    # -- after signing in, allow the user to do other things without having to quit and go through the whole loop again

end

function useProgram()
    #once a user signs in, they will be directed here so signing in isn't an option anymore
    #once they exit from this loop they will be back at the signin /exit screen


end


function enterTransaction()
    # i don't think this function will take input -- maybe the user's balance?
    # questions will be asked within the function
    # ask the user for the transaction date, amount, and category. other data TBD
    # write the data to a file
    # keeping track of the balance
end

function enterDeposit()
    # no input --- maybe the account balancce so that can be updated
    # questions will be asked within the function
    # ask the user for the deposit amount and date
    # update the account balance
end 

function setBudget()
    # will ask the user to select the category and set the percent of their budget to make the category
    # percents can not exceed 100%
end 

function getStats()
    # will give the user different options for stats they can get about their account
    # viewing spending by category, looking at data within a particular month, etc.
end

bank_users = [] #empty list of bank users, will be used to check for accounts? 

mutable struct User # decided to make a User struct to be able to keep track of different attributes
    # i might not need this if i'm using a data frame/csv to keep track of data?????????????
    name::String
    accountBalance::Float64
    password::String
    #accountFile::String  -- store the file as a string that can be read/opened?? 
end




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


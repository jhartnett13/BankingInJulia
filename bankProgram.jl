using CSV
using DataFrames

function openFile(user)
    # code to open the file contatining the users info
end


function signIn()

    csv_reader = CSV.file("C:\\Users\\julia\\OneDrive\\Documents\\School Work\\FA21\\CS330\\final project\\userAccounts.csv")
    for row in csv_reader
        println("values: $(row.col1), $(row.col2), $(row.col3)")
    end



end


function createAccount()
    println("Welcome! Thanks for opening a new account.")
    println("Enter your name: \n")



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
    name::String
    accountBalance::Float64
    #password::String
    #accountFile::String  -- store the file as a string that can be read/opened?? 
end

kg = "yes"

println("Welcome! What would you like to do? ")
while kg == "yes"
    println("1. Sign in to my account")
    println("2. Create a new account")
    choice = readline()
    choice = parse(Int64, choice)
    if choice == 1
        signIn()
    else
        createAccount()
    end

    global kg = "no"
end

println(bank_users)


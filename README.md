# DataAnalytics-Assessment
## Assessment_Q1
I explore the necessary tables (plans_plan and savings_savingsaccount) required for this question, to understand the structure of the data. I needed to get the count of savings and investment plans for each customer.
I then used Common Table Expression (CTE) to separate each count of savings and investments plan, and the users’ details. 
Each CTE for the plans was a count of the is_a_fund column for investment and is_regular_savings column for savings grouped by the id of each user (owner_id), where both columns are equal to 1.
Upon careful exploration, I found out there was a user whose deposits (confirmed_amount in the savings_savingsaccount table) have negative value. I then used a WHERE clause where deposits are greater or equal to 0. I converted the confimed_amount from kobo to naira by dividing by 100 for easier understanding of the figure.
Also, in the name column of the users_customuser table, there are numerous null values. Although the first_name and last_name columns both contain appropriate names.  I then used CONCAT function to join these columns instead of using the name column.
I joined the two CTEs created to the users_customuser table using common keys and then ordered in descending order by the total_deposits column.
## Challenges
One of the challenges I experienced was when trying to combine both savings and investment plans in a single query. I was getting an empty result. I tried using the WHERE clause (is_a_fund = 1 OR is_regular_savings = 1) in a single query. I first understood the question as if a user doesn’t have a savings then it will be investment. Then, I confirmed this by checking where is_a_fund = is_regular_savings to see if I would get a match. I saw that both columns can even be both 0 or both 1 i.e, it is neither a savings nor an investment plan. The AND function is, therefore, useless here as well.
This was where the idea of using a CTE to get each user’ plans separately and combining them afterwards using their IDs. In fact, this allowed me to perform the COUNT aggregation in each of them and then grouping by their id.

## Assessment_Q2
Using the CASE function in this question was easy, since I already known the different frequency categories I needed. 
Looking at the savings_savingsaccount, I saw that the transaction date is the needed column to get the number of transactions in a month. Transactions that occur in different day in a month will surely have similar month value. I then used the MONTH function to extract the month value from the transaction date. Now, if I group by month value it will give a count which is equivalent to transactions in a month.
I created a CTE for a frequency table where the frequency category for each customer is in a single column. Then, I aggregated these categories by counting the number of users than fall under each category using GROUP BY function.

## Challenges
One of the challenges faced was figuring out whether to do a COUNT of the transaction_date column or an AVERAGE. I decided to do an average for each customer and the averaging the average for each frequency.
I wanted to stop at the first CTE I created. This was, I will have a single query without even using CTE. This was where the expected output in the provided document was helpful. I realized I needed to group my result further for easy analysis

## Assessment_Q3 
This was the most challenging question for me. I will state the challenges before my explaining my approach.

## Challenges
I kept getting duplicated results! This was before the RANK windows function came to my mind. I already got my result for inactive users in the past 365 days. The main issue was trying to combine the plan_id and the owner_id, considering some users have more than one plans. 
Yes, I already got my maximum transaction date for each owner_id in a CTE. I also got maximum transaction date for each plan_id in a CTE. The issue was how to combine them together. I employed the transaction date column for each of them, trying to join both CTE using transaction date. It resulted in duplicated results. I figured some transaction dates from different users can even have similar dates.
Then the RANK function came to my head! For users with more than one plans, what if I ranked their plans in order of the transaction date. Even though the date is still more than 365 days, it will still be the maximum out of all of them. Then I used both the plan_id and owner_id for my JOINS (a two-factor authentication!). 

## Approach
From the savings_savingsaccount, I selected the plan_id and owner_id. I then get the maximum transaction date and also used DATEDIFF to get the difference between last transaction date and current date as my inactivity_days.
The reason I used the current date is to make the result dynamic. With this, some users that are not in my results while I write this might be there by the time you read this, especially if they are very close to being inactive, say 364 days. 
I created two CTEs to get the maximum transaction dates and to get for users with either a savings or an investment plan. In my last query, I joined the two CTEs using the plan_id and the owner_id and used a WHERE clause for ranking = 1.  That is, I want I want users who have been inactive for over 365 days. And if such users have more than one plans, I want the most recent one (ranking=1).

## Assessment_Q4 
Each transaction in the savings_savingsaccount table has a unique id (savings_id). I used a COUNT of the savings_id instead of that of the transaction date because there are some failed transactions (about 225) in the table. Transaction date would have included such in the count. The COUNT of the savings_id allowed for only successful transactions with failed transactions having not savings_id.
I counted the savings_id to get transactions volume (total transactions). Then multiplied the confirmed amount by 0.1% (0.001) to the total profit. Then, I did the average to get the average profit per transaction. This was all put in a CTE including the owner_id.
I also got the require details of the users from the users_customuser table. This includes the id, names and tenure_month. The tenure_month is gotten through the date joined. To calculate how long the users have been, I did a difference between the current time and the date joined. Again, this is dynamic as it allows for reusability of the query at any particular time.
I joined the two CTEs and then calculated the estimated_clv using the formula given.  I then ordered bythe estimated_clv in descending order.

## Challenges
I was not sure which column to use to get my total transactions (volume). I decided to use the savings_id because it is a good representation of transactions by users.
I also got some NULL values in my results of estimated_clv. I assume this is due to the tenure_months being zero for new users. I wrapped the calculation in IFNULL fuction to return zero after dividing the total_transactions by tenure_months if it results to zero. 

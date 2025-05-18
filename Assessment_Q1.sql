#to get the users with investment plans
WITH investment_plan AS (
	SELECT 
		DISTINCT  owner_id, 
		COUNT(is_a_fund) AS investment_count
	FROM
		plans_plan
	WHERE
		is_a_fund = 1
	GROUP BY owner_id),

#to get the users with savings plans
savings_plan AS (
	SELECT 
		DISTINCT owner_id, 
		COUNT(is_regular_savings) AS savings_count
	FROM
		plans_plan
	WHERE
		is_regular_savings = 1
	GROUP BY owner_id),

#the confirmed_amount is in kobo. I divided by 100 to convert to naira.
#the proper function is not available. I used upper,lower and substring functions instead
user_details AS (
	SELECT
		users.id,
		CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)), " ",
		UPPER(LEFT(last_name, 1)), LOWER(SUBSTRING(last_name, 2))) AS name,
		ROUND(SUM(confirmed_amount)/100, 2) AS total_deposits
	FROM users_customuser AS users
		JOIN savings_savingsaccount AS savings 
		ON users.id = savings.owner_id
	WHERE confirmed_amount >= 0
	GROUP BY  users.id,
			CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)), ' ',
			UPPER(LEFT(last_name, 1)), LOWER(SUBSTRING(last_name, 2))))

SELECT 
	savings_plan.owner_id,
	name,
	savings_count,
    investment_count,
    total_deposits
FROM investment_plan
	JOIN savings_plan 
	ON investment_plan.owner_id = savings_plan.owner_id
	JOIN user_details 
	ON investment_plan.owner_id = user_details.id
ORDER BY total_deposits DESC

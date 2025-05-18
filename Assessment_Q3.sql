#I used windows function, RANK,to get list of ranked plans for each user.
WITH max_transaction AS (
	SELECT 
		plan_id, 
		owner_id,
        RANK() OVER (PARTITION BY owner_id ORDER BY MAX(transaction_date) DESC) AS ranking,
		MAX(transaction_date) AS last_transaction_date,
		DATEDIFF(CURRENT_TIMESTAMP(), MAX(transaction_date)) AS inactivity_days
	FROM savings_savingsaccount 
	GROUP BY owner_id, plan_id 
	HAVING MAX(transaction_date) < (DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY))),

#this CTE gives multiple owner_id with different plans as result
plan_type AS (
	SELECT 
		id,
		owner_id,
		CASE WHEN is_a_fund = 1 THEN "Savings" 
        WHEN is_regular_savings = 1 THEN "Investment" END AS type
	FROM plans_plan
	WHERE is_a_fund = 1 OR is_regular_savings = 1)

#a JOIN of multiple keys- plan_id and owner_id
SELECT 
	plan_id,
    max_transaction.owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM max_transaction 
	JOIN plan_type 
	ON max_transaction.owner_id = plan_type.owner_id
	AND max_transaction.plan_id = plan_type.id
WHERE ranking = 1
WITH profit AS (
	SELECT 
		owner_id, 
		COUNT(savings_id) AS total_transactions,
		ROUND(AVG(confirmed_amount * 0.001), 2) AS avg_profit_per_transaction
	FROM savings_savingsaccount
	WHERE confirmed_amount >= 0 
	GROUP BY owner_id),

users AS (
	SELECT 
		id AS customer_id, 
		CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)), " ",
		UPPER(LEFT(last_name, 1)), LOWER(SUBSTRING(last_name, 2))) AS name, 
		TIMESTAMPDIFF(MONTH, date_joined, CURRENT_TIMESTAMP()) AS tenure_months
	FROM users_customuser WHERE is_active = 1)

#the avg_profit_per_transaction is in kobo, not converted to naira.
SELECT 
	customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(IFNULL((total_transactions/tenure_months) * 12 * avg_profit_per_transaction, 0), 2) AS estimated_clv
FROM profit 
	JOIN users 
	ON profit.owner_id=users.customer_id
ORDER BY estimated_clv DESC
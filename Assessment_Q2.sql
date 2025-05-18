WITH frequency AS (
	SELECT 
		users.id,
		COALESCE(ROUND(AVG(MONTH(DATE(transaction_date))), 0), 0) AS avg_transactions,
		CASE WHEN COALESCE(ROUND(AVG(MONTH(DATE(transaction_date))), 0), 0) >= 10 THEN "High Frequency"
		WHEN COALESCE(ROUND(AVG(MONTH(DATE(transaction_date))), 0), 0) BETWEEN 3 AND 9 THEN "Medium Frequency"
		WHEN COALESCE(ROUND(AVG(MONTH(DATE(transaction_date))), 0), 0) <= 2 THEN "Low Frequency" END AS frequency_category
		
	FROM savings_savingsaccount AS savings
		RIGHT JOIN users_customuser AS users 
		ON savings.owner_id = users.id
	GROUP BY users.id)

SELECT 
	frequency_category,
	COUNT(frequency.id) AS customer_count,
    ROUND(AVG(avg_transactions), 1) AS avg_transactions_per_month
FROM frequency 
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC
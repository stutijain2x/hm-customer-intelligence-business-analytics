USE hm_customer_intelligence;

DROP TEMPORARY TABLE IF EXISTS customer_spend;
DROP TEMPORARY TABLE IF EXISTS customer_recency;
DROP TEMPORARY TABLE IF EXISTS customer_purchase_frequency;
DROP TEMPORARY TABLE IF EXISTS rfm_scores;
DROP TEMPORARY TABLE IF EXISTS customer_channels;
-- Q1. Total number of transactions
SELECT COUNT(*) AS TOTAL_TRANSACTIONS
FROM transactions;
-- Q2. Number of unique customers who made purchases
SELECT COUNT(DISTINCT customer_id)
from transactions;
-- Q3. Customer participation rate
SELECT
    ROUND(
        COUNT(DISTINCT t.customer_id)
        / COUNT(DISTINCT c.customer_id) * 100,
        2
    ) AS customer_participation_pct
FROM customers AS c
LEFT JOIN transactions AS t
    ON c.customer_id = t.customer_id;
-- Q4. Total transaction value
SELECT SUM(price) AS total_transaction_value
FROM transactions;
-- Q5. Average transaction value
SELECT AVG(price) AS avg_transaction_value
FROM transactions;
-- Q6. Sales channel performance
SELECT
    CASE
        WHEN sales_channel_id = 1 THEN 'ONLINE'
        WHEN sales_channel_id = 2 THEN 'STORE'
        ELSE 'UNKNOWN'
    END AS sales_channel,
    COUNT(*) AS transaction_count,
    ROUND(SUM(price), 6) AS transaction_value
FROM transactions
GROUP BY sales_channel_id
ORDER BY transaction_value DESC;
-- Q7. Sales channel value contribution
SELECT
    CASE
        WHEN sales_channel_id = 1 THEN 'ONLINE'
        WHEN sales_channel_id = 2 THEN 'STORE'
        ELSE 'UNKNOWN'
    END AS sales_channel,

    ROUND(SUM(price), 6) AS transaction_value,

    ROUND(
        SUM(price) / SUM(SUM(price)) OVER () * 100,
        2
    ) AS value_contribution_pct

FROM transactions
GROUP BY sales_channel_id
ORDER BY transaction_value DESC;

	
    -- Q9. Membership status and purchasing performance
SELECT
    c.club_member_status,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT t.customer_id) AS purchasing_customers,
    ROUND(COALESCE(SUM(t.price), 0), 6) AS transaction_value
FROM customers AS c
LEFT JOIN transactions AS t
    ON c.customer_id = t.customer_id
GROUP BY c.club_member_status
ORDER BY transaction_value DESC;
-- Q10 Total transaction value per customer
CREATE TEMPORARY TABLE customer_spend AS
SELECT
    customer_id,
    SUM(price) AS total_spend
FROM transactions
GROUP BY customer_id;

-- Q11. Product-group commercial performance
SELECT
    a.product_group_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.price), 6) AS total_transaction_value,
    ROUND(AVG(t.price), 6) AS avg_transaction_value
FROM transactions AS t
JOIN articles AS a
    ON t.article_id = a.article_id
GROUP BY a.product_group_name
ORDER BY total_transaction_value DESC;
-- Q12. Department commercial performance
SELECT
    a.department_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.price), 6) AS transaction_value,
    ROUND(AVG(t.price), 6) AS avg_transaction_value
FROM transactions AS t
JOIN articles AS a
    ON t.article_id = a.article_id
GROUP BY a.department_name
ORDER BY transaction_value DESC
LIMIT 15;

-- Q13. Monthly transaction performance
SELECT
    DATE_FORMAT(t_dat, '%Y-%m') AS transaction_month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(price), 6) AS total_transaction_value,
    ROUND(AVG(price), 6) AS avg_transaction_value
FROM transactions
GROUP BY DATE_FORMAT(t_dat, '%Y-%m')
ORDER BY transaction_month;

-- Q14. Year-over-year transaction performance
WITH yearly_sales AS (
    SELECT
        YEAR(t_dat) AS transaction_year,
        SUM(price) AS total_transaction_value,
        COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY YEAR(t_dat)
),
yearly_change AS (
    SELECT
        transaction_year,
        total_transaction_value,
        transaction_count,
        LAG(total_transaction_value) OVER (
            ORDER BY transaction_year
        ) AS previous_year_value
    FROM yearly_sales
)
SELECT
    transaction_year,
    ROUND(total_transaction_value, 6) AS total_transaction_value,
    transaction_count,
    ROUND(
        (
            total_transaction_value - previous_year_value
        ) / NULLIF(previous_year_value, 0) * 100,
        2
    ) AS yoy_value_growth_pct
FROM yearly_change
ORDER BY transaction_year;
-- Q15. Compare transaction volume and average transaction value
SELECT
    YEAR(t_dat) AS transaction_year,
    COUNT(*) AS transaction_count,
    ROUND(AVG(price), 6) AS avg_transaction_value
FROM transactions
GROUP BY YEAR(t_dat)
ORDER BY transaction_year;

-- Q16. Purchasing customers by year
SELECT
    YEAR(t_dat) AS transaction_year,
    COUNT(DISTINCT customer_id) AS purchasing_customers
FROM transactions
GROUP BY YEAR(t_dat)
ORDER BY transaction_year;


-- Q17. Customer recency
SELECT
    customer_id,
    MAX(t_dat) AS last_purchase_date,
    DATEDIFF('2020-09-22', MAX(t_dat)) AS days_since_last_purchase
FROM transactions
GROUP BY customer_id
ORDER BY days_since_last_purchase DESC;


-- Q19. Customer inactivity distribution
CREATE TEMPORARY TABLE customer_recency AS
SELECT
    customer_id,
    MAX(t_dat) AS last_purchase_date,
    DATEDIFF('2020-09-22', MAX(t_dat)) AS days_since_last_purchase
FROM transactions
GROUP BY customer_id;

SELECT
    CASE
        WHEN days_since_last_purchase <= 30 THEN '0-30 days'
        WHEN days_since_last_purchase <= 90 THEN '31-90 days'
        WHEN days_since_last_purchase <= 180 THEN '91-180 days'
        ELSE '181+ days'
    END AS inactivity_group,
    COUNT(*) AS customer_count
FROM customer_recency
GROUP BY
    CASE
        WHEN days_since_last_purchase <= 30 THEN '0-30 days'
        WHEN days_since_last_purchase <= 90 THEN '31-90 days'
        WHEN days_since_last_purchase <= 180 THEN '91-180 days'
        ELSE '181+ days'
    END
ORDER BY customer_count DESC;

-- Q20. Transaction value by customer inactivity group
SELECT
    CASE
        WHEN cr.days_since_last_purchase <= 30 THEN '0-30 days'
        WHEN cr.days_since_last_purchase <= 90 THEN '31-90 days'
        WHEN cr.days_since_last_purchase <= 180 THEN '91-180 days'
        ELSE '181+ days'
    END AS inactivity_group,

    COUNT(*) AS customer_count,

    ROUND(SUM(cs.total_spend), 6) AS total_transaction_value,

    ROUND(AVG(cs.total_spend), 6) AS avg_customer_value

FROM customer_recency AS cr

JOIN customer_spend AS cs
    ON cr.customer_id = cs.customer_id

GROUP BY
    CASE
        WHEN cr.days_since_last_purchase <= 30 THEN '0-30 days'
        WHEN cr.days_since_last_purchase <= 90 THEN '31-90 days'
        WHEN cr.days_since_last_purchase <= 180 THEN '91-180 days'
        ELSE '181+ days'
    END

ORDER BY total_transaction_value DESC;

-- Q21A. Purchase frequency by customer
CREATE TEMPORARY TABLE customer_purchase_frequency AS
SELECT
    customer_id,
    COUNT(DISTINCT t_dat) AS purchase_count
FROM transactions
GROUP BY customer_id;
-- Q21 B. One-time vs repeat customers
SELECT
    CASE
        WHEN purchase_count = 1 THEN 'ONE-TIME'
        ELSE 'REPEAT'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_purchase_frequency
GROUP BY
    CASE
        WHEN purchase_count = 1 THEN 'ONE-TIME'
        ELSE 'REPEAT'
    END;
    -- Q22. Customer value by purchase type
SELECT
    CASE
        WHEN pf.purchase_count = 1 THEN 'ONE-TIME'
        ELSE 'REPEAT'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(AVG(cs.total_spend), 6) AS avg_customer_value
FROM customer_purchase_frequency AS pf
JOIN customer_spend AS cs
    ON pf.customer_id = cs.customer_id
GROUP BY
    CASE
        WHEN pf.purchase_count = 1 THEN 'ONE-TIME'
        ELSE 'REPEAT'
    END;
  
-- Q23. Repeat customers with prolonged inactivity
SELECT
    COUNT(*) AS inactive_repeat_customers
FROM customer_purchase_frequency AS pf
JOIN customer_recency AS cr
    ON pf.customer_id = cr.customer_id
WHERE pf.purchase_count > 1
  AND cr.days_since_last_purchase > 180;
  
  -- Q24. Historical value of inactive repeat customers
SELECT
    COUNT(*) AS inactive_repeat_customers,
    ROUND(SUM(cs.total_spend), 6) AS historical_transaction_value,
    ROUND(AVG(cs.total_spend), 6) AS average_customer_value
FROM customer_purchase_frequency AS pf
JOIN customer_recency AS cr
    ON pf.customer_id = cr.customer_id
JOIN customer_spend AS cs
    ON pf.customer_id = cs.customer_id
WHERE pf.purchase_count > 1
  AND cr.days_since_last_purchase > 180;
  
-- Q25. Highest-value inactive repeat customers
SELECT
    cs.customer_id,
    ROUND(cs.total_spend, 6) AS historical_customer_value,
    cr.days_since_last_purchase,
    pf.purchase_count
FROM customer_spend AS cs
JOIN customer_recency AS cr
    ON cs.customer_id = cr.customer_id
JOIN customer_purchase_frequency AS pf
    ON cs.customer_id = pf.customer_id
WHERE pf.purchase_count > 1
  AND cr.days_since_last_purchase > 180
ORDER BY cs.total_spend DESC
LIMIT 20;

    
    -- Q27. RFM scoring using NTILE
CREATE TEMPORARY TABLE rfm_scores AS
SELECT
    cr.customer_id,
    cr.days_since_last_purchase AS recency,
    pf.purchase_count AS frequency,
    cs.total_spend AS monetary,

    NTILE(5) OVER (
        ORDER BY cr.days_since_last_purchase DESC
    ) AS r_score,

    NTILE(5) OVER (
        ORDER BY pf.purchase_count
    ) AS f_score,

    NTILE(5) OVER (
        ORDER BY cs.total_spend
    ) AS m_score

FROM customer_recency AS cr
JOIN customer_purchase_frequency AS pf
    ON cr.customer_id = pf.customer_id
JOIN customer_spend AS cs
    ON cr.customer_id = cs.customer_id;
-- Q28. RFM segment performance
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'CHAMPIONS'
        WHEN r_score >= 4 AND f_score >= 3
            THEN 'LOYAL / ACTIVE'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'AT RISK'
        WHEN r_score <= 2 AND f_score <= 2
            THEN 'DORMANT'
        ELSE 'DEVELOPING'
    END AS rfm_segment,

    COUNT(*) AS customer_count,

    ROUND(SUM(monetary), 6) AS total_customer_value,

    ROUND(
        SUM(monetary)
        / SUM(SUM(monetary)) OVER () * 100,
        2
    ) AS value_contribution_pct

FROM rfm_scores

GROUP BY
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'CHAMPIONS'
        WHEN r_score >= 4 AND f_score >= 3
            THEN 'LOYAL / ACTIVE'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'AT RISK'
        WHEN r_score <= 2 AND f_score <= 2
            THEN 'DORMANT'
        ELSE 'DEVELOPING'
    END

ORDER BY total_customer_value DESC;

-- Q29. Top 3 customers within each RFM segment
WITH customer_segments AS (
    SELECT
        customer_id,
        monetary,
        r_score,
        f_score,
        m_score,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
                THEN 'CHAMPIONS'
            WHEN r_score >= 4 AND f_score >= 3
                THEN 'LOYAL / ACTIVE'
            WHEN r_score <= 2 AND f_score >= 3
                THEN 'AT RISK'
            WHEN r_score <= 2 AND f_score <= 2
                THEN 'DORMANT'
            ELSE 'DEVELOPING'
        END AS rfm_segment
    FROM rfm_scores
),
ranked_customers AS (
    SELECT
        customer_id,
        rfm_segment,
        monetary,
        ROW_NUMBER() OVER (
            PARTITION BY rfm_segment
            ORDER BY monetary DESC
        ) AS customer_rank
    FROM customer_segments
)
SELECT
    customer_id,
    rfm_segment,
    ROUND(monetary, 6) AS monetary_value,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 3
ORDER BY rfm_segment, customer_rank;
-- Q30. Product groups purchased by repeat customers
SELECT
    a.product_group_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.price), 6) AS transaction_value
FROM transactions AS t
JOIN customer_purchase_frequency AS pf
    ON t.customer_id = pf.customer_id
JOIN articles AS a
    ON t.article_id = a.article_id
WHERE pf.purchase_count > 1
GROUP BY a.product_group_name
ORDER BY transaction_value DESC;
-- Q31.A. Customer value by channel behaviour

-- Customer channel usage
CREATE TEMPORARY TABLE customer_channels AS
SELECT
    customer_id,
    COUNT(DISTINCT sales_channel_id) AS channel_count
FROM transactions
GROUP BY customer_id;
 -- Q31.B Customer value by channel behaviour
SELECT
    CASE
        WHEN cc.channel_count = 2 THEN 'BOTH CHANNELS'
        ELSE 'SINGLE CHANNEL'
    END AS customer_channel_type,
    COUNT(*) AS customer_count,
    ROUND(AVG(cs.total_spend), 6) AS avg_customer_value
FROM customer_channels AS cc
JOIN customer_spend AS cs
    ON cc.customer_id = cs.customer_id
GROUP BY
    CASE
        WHEN cc.channel_count = 2 THEN 'BOTH CHANNELS'
        ELSE 'SINGLE CHANNEL'
    END
ORDER BY avg_customer_value DESC;
-- Q32. Month-over-month transaction value change
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(t_dat, '%Y-%m') AS transaction_month,
        SUM(price) AS monthly_value
    FROM transactions
    GROUP BY DATE_FORMAT(t_dat, '%Y-%m')
),
monthly_change AS (
    SELECT
        transaction_month,
        monthly_value,
        LAG(monthly_value) OVER (
            ORDER BY transaction_month
        ) AS previous_month_value
    FROM monthly_sales
)
SELECT
    transaction_month,
    ROUND(monthly_value, 6) AS monthly_value,
    ROUND(previous_month_value, 6) AS previous_month_value,
    ROUND(
        (monthly_value - previous_month_value)
        / NULLIF(previous_month_value, 0) * 100,
        2
    ) AS mom_change_pct
FROM monthly_change
ORDER BY transaction_month;

-- Q33. Days between customer purchase occasions
WITH purchase_days AS (
    SELECT DISTINCT
        customer_id,
        t_dat
    FROM transactions
),
purchase_gaps AS (
    SELECT
        customer_id,
        t_dat AS purchase_date,
        LAG(t_dat) OVER (
            PARTITION BY customer_id
            ORDER BY t_dat
        ) AS previous_purchase_date
    FROM purchase_days
)
SELECT
    customer_id,
    purchase_date,
    previous_purchase_date,
    DATEDIFF(
        purchase_date,
        previous_purchase_date
    ) AS days_between_purchases
FROM purchase_gaps
ORDER BY customer_id, purchase_date;

-- Q34. Average gap between customer purchase occasions
WITH purchase_days AS (
    SELECT DISTINCT
        customer_id,
        t_dat
    FROM transactions
),
purchase_gaps AS (
    SELECT
        customer_id,
        DATEDIFF(
            t_dat,
            LAG(t_dat) OVER (
                PARTITION BY customer_id
                ORDER BY t_dat
            )
        ) AS days_between_purchases
    FROM purchase_days
)
SELECT
    ROUND(AVG(days_between_purchases), 2)
        AS avg_days_between_purchases
FROM purchase_gaps
WHERE days_between_purchases IS NOT NULL;

-- Q35. Top 3 products by transaction value within each department
WITH product_sales AS (
    SELECT
        a.department_name,
        a.article_id,
        a.prod_name,
        SUM(t.price) AS transaction_value
    FROM transactions AS t
    JOIN articles AS a
        ON t.article_id = a.article_id
    GROUP BY
        a.department_name,
        a.article_id,
        a.prod_name
),
ranked_products AS (
    SELECT
        department_name,
        article_id,
        prod_name,
        transaction_value,
        ROW_NUMBER() OVER (
            PARTITION BY department_name
            ORDER BY transaction_value DESC
        ) AS product_rank
    FROM product_sales
)
SELECT
    department_name,
    article_id,
    prod_name,
    ROUND(transaction_value, 6) AS transaction_value,
    product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY department_name, product_rank;
-- Q36. Top 5 product groups by transaction value within each sales channel
WITH channel_product_sales AS (
    SELECT
        CASE
            WHEN t.sales_channel_id = 1 THEN 'ONLINE'
            WHEN t.sales_channel_id = 2 THEN 'STORE'
            ELSE 'UNKNOWN'
        END AS sales_channel,
        a.product_group_name,
        SUM(t.price) AS transaction_value
    FROM transactions AS t
    JOIN articles AS a
        ON t.article_id = a.article_id
    GROUP BY
        t.sales_channel_id,
        a.product_group_name
),
ranked_products AS (
    SELECT
        sales_channel,
        product_group_name,
        transaction_value,
        RANK() OVER (
            PARTITION BY sales_channel
            ORDER BY transaction_value DESC
        ) AS product_rank
    FROM channel_product_sales
)
SELECT
    sales_channel,
    product_group_name,
    ROUND(transaction_value, 6) AS transaction_value,
    product_rank
FROM ranked_products
WHERE product_rank <= 5
ORDER BY sales_channel, product_rank;
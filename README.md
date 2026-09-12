# H&M Customer Intelligence & Business Analytics

SQL-driven analysis of H&M sales performance, customer behaviour, product and channel performance, customer value, segmentation, and retention patterns.

## Project Overview

This project analyzes H&M transaction data to understand business performance from both **commercial and customer perspectives**.

The analysis begins with overall transaction and sales trends, then moves into channel, product, and department performance before examining customer participation, purchasing behaviour, customer value, recency, inactivity, and repeat purchasing patterns. The final stages use RFM segmentation and SQL window functions to identify more meaningful customer and product-level patterns.

The objective is to move beyond individual metrics and build a connected view of **how sales are performing, how customers are behaving, where value is concentrated, and where potential opportunities for improvement exist**.

## Objectives
- Analyze overall transaction volume, transaction value, and average transaction value.
- Evaluate sales performance across different time periods, including monthly, year-over-year, and month-over-month changes.
- Compare Online and Store channels based on transaction activity and value contribution.
- Identify high-performing product groups, departments, and products within departments.
- Understand customer participation and distinguish one-time customers from repeat customers.
- Compare customer value across different purchasing behaviours.
- Analyze customer recency, inactivity, and purchase gaps to identify retention-related patterns.
- Identify high-value customers who may represent important reactivation opportunities.
- Segment customers using RFM analysis based on recency, frequency, and monetary value.
- Examine customer behaviour across sales channels and identify within-group rankings using SQL window functions.
- 
## Dataset & Scope

This project uses H&M transaction, customer, and article-level data to analyze sales performance, customer behaviour, product and channel performance, customer value, and retention patterns.

The analysis covers transaction activity, time trends, sales channels, products and departments, customer purchasing behaviour, inactivity, RFM segmentation, and purchase gaps.

### Analytical Assumption

The transaction data does not contain a unique basket or order ID. Therefore, distinct customer purchase dates are used as a practical proxy for purchase occasions when analyzing purchase frequency and purchase gaps.

## Tools

**MySQL** — SQL querying, joins, aggregations, CTEs, subqueries, temporary tables, and window functions.

## Key Business Questions

1. How is H&M's overall sales and transaction performance changing over time?

2. How are the Online and Store channels performing?

3. Which product groups and departments contribute most to transaction value?

4. How does purchasing behaviour differ between one-time and repeat customers?

5. What patterns in customer recency, inactivity, and purchase gaps indicate potential retention opportunities?

6. How can RFM segmentation help identify differences in customer value and engagement?

## Key Insights

### 1. The decline in 2020 was driven more by lower transaction activity than by a major change in transaction value

Transaction value increased from 1,312.05 in 2018 to 4,551.02 in 2019, before declining by 34.56% to 2,978.37 in 2020. Transaction volume followed a similar pattern, falling from 163,969 transactions in 2019 to 109,802 in 2020.

In comparison, average transaction value declined only slightly from 0.027755 in 2019 to 0.027125 in 2020. This suggests that the reduction in overall transaction value was more closely associated with lower transaction activity than with a major decline in the value of individual transactions.

*Note: 2018 and 2020 are partial years in the dataset, so year-over-year comparisons should be interpreted in that context.*

### 2. Store is the dominant sales channel, while Online contributes a meaningful secondary share

Store generated 224,184 transactions and 6,689.73 in transaction value, compared with 93,699 transactions and 2,151.71 Online.

Store therefore contributed 70.52% of transaction volume and 75.66% of total transaction value, while Online contributed 29.48% and 24.34%, respectively. The higher share of transaction value relative to volume also indicates that the Store channel had a higher average transaction value in the observed data.

### 3. Core apparel categories account for a large share of transaction value across both channels

Garment Upper Body was the leading product group in both Online and Store channels, followed by Garment Lower Body and Garment Full Body.

Together, these three product groups contributed approximately 79% of transaction value within each channel. The consistency across channels suggests that core apparel categories are important drivers of transaction value regardless of where the purchase takes place.

### 4. Product performance differs when measured by volume versus value

The department analysis highlights an important difference between transaction volume and transaction value. Swimwear recorded the highest transaction count among the listed departments at 24,867, while Trouser generated the highest transaction value at 609.79 despite having fewer transactions at 17,603.

Outwear showed an even stronger value-versus-volume contrast, with only 3,887 transactions but the highest average transaction value among the listed departments at 0.080564.

This indicates that category performance should be evaluated using both demand volume and transaction value rather than relying on transaction count alone.

### 5. One-time customers dominate the customer base, but repeat customers have substantially higher historical value

The analysis identified 179,519 one-time customers compared with 55,298 repeat customers. One-time customers therefore represented approximately 76.45% of purchasing customers.

However, average historical customer value was 0.027286 for one-time customers versus 0.071306 for repeat customers—around 2.6 times higher for repeat customers.

This creates an important customer-value pattern: although repeat customers represent a smaller share of the customer base, their observed historical value is substantially higher. Increasing movement from an initial purchase to subsequent purchases therefore represents a meaningful customer-value opportunity.

### 6. Retention and customer segmentation reveal clear groups for differentiated attention

The recency analysis found 161,792 customers inactive for more than 181 days, representing approximately 68.90% of customers in the recency analysis. More importantly, 29,487 customers who had previously purchased more than once were also inactive for more than 180 days.

These inactive repeat customers had a combined historical transaction value of 1,980.41 and an average historical customer value of 0.067162.

The RFM analysis adds another layer of prioritization: 27,863 customers were classified as Champions and contributed 26.18% of total customer value, while 92,121 customers were classified as At Risk and contributed 32.34% of total customer value.

Together, these findings suggest that customer management should not follow a one-size-fits-all approach. High-value engaged customers need to be protected, while previously valuable inactive customers and larger At Risk groups can be considered for targeted reactivation and retention efforts.


## Recommendations

- **Improve repeat-purchase conversion:** Since one-time customers make up the majority of the purchasing base while repeat customers show substantially higher historical value, increasing movement from a first purchase to subsequent purchases could be a meaningful customer-value opportunity.

- **Prioritize reactivation opportunities:** The inactive repeat-customer group can be segmented further using recency and historical value, allowing attention to be focused on customers who have previously demonstrated repeat purchasing behaviour.

- **Protect high-value customers:** Champions contribute a disproportionately high share of customer value, making continued engagement with this segment an important area for retention efforts.

- **Evaluate product performance through both volume and value:** High transaction volume does not always translate into the highest transaction value. Reviewing both measures together can provide a more balanced view of category performance.

- **Use channel behaviour as an additional customer lens:** Since Store accounts for the larger share of transaction value, comparing single-channel and multi-channel customers by historical value can help identify differences in customer behaviour that may be useful for future channel-focused analysis.

- ## Limitations & Assumptions

- The dataset does not contain a unique basket or order identifier. Distinct customer purchase dates are therefore used as a practical proxy for purchase occasions when analyzing purchase frequency and purchase gaps.

- Customer inactivity is measured relative to 22 September 2020, the reference date used in the analysis. A customer classified as inactive should not automatically be interpreted as permanently churned.

- Historical customer value reflects past transaction activity and should not be treated as a forecast of future revenue.

- The analysis is descriptive and identifies patterns and potential opportunities; it does not establish causal relationships between customer behaviour and sales outcomes.

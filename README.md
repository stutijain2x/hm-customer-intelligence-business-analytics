# H&M Customer Intelligence & Business Analytics

SQL-driven analysis of H&M sales performance, customer behaviour, product and channel performance, customer value, segmentation, and retention patterns.

## Project Overview
This project uses H&M transaction data to understand the business from both a sales and customer perspective.

I started with overall sales and transaction trends, then looked at channels, products, and departments. I then moved to customer-level analysis, covering purchasing behaviour, customer value, recency, inactivity, repeat purchases, and RFM segments.

The aim was to connect these areas and understand where transaction value comes from, how customers behave over time, and where there are potential opportunities to improve customer engagement and retention.

## Objectives

- Analyze transaction volume, transaction value, and average transaction value.
- Understand how sales performance changes over time.
- Compare Online and Store channel performance.
- Identify high-performing product groups, departments, and products.
- Understand customer participation and purchasing behaviour.
- Compare one-time and repeat customers by historical value.
- Analyze recency, inactivity, and purchase gaps.
- Identify previously repeat customers who may be relevant for reactivation.
- Segment customers using RFM analysis.
- Use SQL window functions for customer and product-level comparisons.

## Dataset & Scope

The project uses H&M transaction, customer, and article-level data.

The analysis covers sales activity, time trends, sales channels, products and departments, customer behaviour, customer value, inactivity, RFM segmentation, and purchase gaps.

### Analytical Assumption

The transaction data does not contain a unique basket or order ID. Therefore, distinct customer purchase dates are used as a practical proxy for purchase occasions when analyzing purchase frequency and purchase gaps.

## Tools

**MySQL** — SQL querying, joins, aggregations, CTEs, subqueries, temporary tables, and window functions.

## Key Business Questions

1. How is H&M's overall sales and transaction performance changing over time?

2. How are the Online and Store channels performing?

3. Which product groups and departments contribute most to transaction value?

4. How does purchasing behaviour differ between one-time and repeat customers?

5. What do customer recency, inactivity, and purchase gaps indicate about retention opportunities?

6. How can RFM segmentation help identify differences in customer value and engagement?

## Key Insights

### 1. The 2020 decline was mainly associated with lower transaction activity

Transaction value increased from 1,312.05 in 2018 to 4,551.02 in 2019, before falling by 34.56% to 2,978.37 in 2020. Transaction volume also fell from 163,969 in 2019 to 109,802 in 2020.

Average transaction value changed only slightly, from 0.027755 in 2019 to 0.027125 in 2020. This suggests that the fall in overall transaction value was more closely related to lower transaction activity than to a large change in transaction value per purchase.

*Note: 2018 and 2020 are partial years in the dataset, so these yearly comparisons should be viewed in that context.*

### 2. Store is the main transaction channel in the dataset

Store generated 224,184 transactions and 6,689.73 in transaction value, compared with 93,699 transactions and 2,151.71 Online.

Store accounted for 70.52% of transaction volume and 75.66% of total transaction value, while Online accounted for 29.48% and 24.34%.

The fact that Store's value share is higher than its transaction share also indicates a higher average transaction value in the observed data.

### 3. Product performance changes depending on whether we look at volume or value

The department analysis shows that transaction volume and transaction value do not always point to the same categories. Swimwear recorded the highest transaction count among the listed departments at 24,867, while Trouser generated the highest transaction value at 609.79 with 17,603 transactions.

Outwear had only 3,887 transactions but recorded the highest average transaction value among the listed departments at 0.080564.

At the broader product-group level, Garment Upper Body, Garment Lower Body, and Garment Full Body were the top three groups in both Online and Store. Together, they accounted for roughly 79% of transaction value within each channel.

### 4. One-time customers form most of the customer base, but repeat customers are much more valuable

The analysis identified 179,519 one-time customers compared with 55,298 repeat customers. One-time customers therefore made up approximately 76.45% of purchasing customers.

However, average historical customer value was 0.027286 for one-time customers compared with 0.071306 for repeat customers — around 2.6 times higher.

This makes repeat-purchase conversion an important customer-value opportunity in the observed data.

### 5. A large inactive customer group includes customers who had already returned before

161,792 customers had been inactive for more than 181 days. More importantly, 29,487 customers who had previously purchased more than once were also inactive for more than 180 days.

These inactive repeat customers had a combined historical transaction value of 1,980.41 and an average historical customer value of 0.067162.

Because these customers had already shown repeat purchasing behaviour, they provide a more relevant group to examine for reactivation than treating all inactive customers in the same way.

The average gap between observed customer purchase occasions was also approximately 180 days, which provides useful context when interpreting inactivity.

### 6. RFM segmentation shows that customer value is spread unevenly across the customer base

The RFM analysis classified 27,863 customers as Champions, 92,121 as At Risk, 108,623 as Developing, 4,403 as Loyal / Active, and 1,807 as Dormant.

Champions represented about 11.87% of the segmented customer base but contributed 26.18% of total customer value. At Risk customers represented about 39.23% of the segmented base and contributed 32.34% of total customer value.

This suggests that different customer groups need different levels of attention: high-value customers are worth protecting, while larger At Risk and Developing groups may offer opportunities for stronger engagement.

## Recommendations

- **Improve repeat-purchase conversion:** One-time customers make up the majority of the purchasing base, while repeat customers have much higher historical value. Encouraging a second purchase could therefore be an important customer-value opportunity.

- **Prioritize reactivation opportunities:** Inactive repeat customers can be further prioritized using recency and historical value, rather than treating every inactive customer in the same way.

- **Protect high-value customers:** Champions contribute a relatively large share of total customer value, making continued engagement with this group important.

- **Evaluate categories using both volume and value:** Transaction count alone does not always identify the strongest-value categories, so both measures should be considered when reviewing product performance.

- **Use channel behaviour as an additional customer lens:** Store contributes the larger share of transaction value, while customer-level channel behaviour can be examined alongside historical value to better understand single-channel and multi-channel customers.

## Limitations & Assumptions

- The dataset does not contain a unique basket or order identifier. Distinct customer purchase dates are therefore used as a practical proxy for purchase occasions when analyzing purchase frequency and purchase gaps.

- Customer inactivity is measured relative to 22 September 2020, the reference date used in the analysis. Inactivity should not automatically be interpreted as permanent churn.

- Historical customer value represents past transaction activity and should not be treated as a forecast of future revenue.

- The analysis is descriptive. It identifies patterns and potential opportunities, but does not establish causal relationships between customer behaviour and sales outcomes.

## Conclusion

This project looks at H&M from several connected angles — sales, products, channels, and customers — rather than focusing on a single metric.

The analysis shows a strong contribution from the Store channel, concentration of transaction value in core product groups, and an important difference between transaction volume and transaction value across categories. At the customer level, one-time buyers make up most of the purchasing base, while repeat customers show much higher historical value.

The retention analysis adds another layer: a large inactive customer base includes customers who had previously purchased more than once, while the RFM analysis shows that customer value and engagement vary considerably across segments.

Taken together, the findings suggest that looking at sales performance alongside customer behaviour gives a more useful picture of the business. Areas such as repeat-purchase conversion, customer reactivation, high-value customer engagement, and product performance by value can be explored further using the patterns identified in the data.

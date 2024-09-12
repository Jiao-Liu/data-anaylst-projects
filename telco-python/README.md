**About**: 
This analysis delves into customer data to uncover trends and relationships that impact revenue, retention, and churn for a telecom company. It examines how demographics, service usage, and satisfaction levels affect business outcomes. The goal is to optimize services and marketing strategies to improve customer satisfaction and reduce churn, enhancing long-term profitability.

---

**Questions**:
1. **Customer Behavior and Preferences**:
    How does monthly data consumption vary across different age groups?
    What general patterns can be identified in data usage based on customer demographics?
2. **Customer Loyalty and Financial Performance**:
     What is the relationship between customer tenure and their overall financial contributions such as charges and revenue? How does the length of            customer engagement correlate with their lifetime value?
3. **Service Features and Customer Churn**:
   Which categories of services are most commonly associated with higher churn rates?
   Are certain types of internet services, such as high-speed options, more prone to churn compared to others?
4. **Customer Satisfaction**:
   How does customer satisfaction influence churn rates across different service levels?
   Are there variations in churn risk based on differing levels of customer satisfaction?
5. **Marketing and Promotions**:
   Do specific types of promotional offers tend to result in higher churn rates, and what might be the reasons?
   How do different promotional strategies impact customer retention and acquisition?
6.**Customer Service**:
  How do customers generally perceive the quality of service provided?
  What improvements could be made to customer service practices to boost overall satisfaction and reduce churn?

----

**Findings**:

1. total customer 7,043, and churn rate 26.5%. 
![image](https://github.com/user-attachments/assets/0d4233f9-4c53-448c-9c95-7e729ece2b77)


2. we can see that between age 20-30 there is a greater average monthly GB download
   ![image](https://github.com/user-attachments/assets/b94296d3-050f-4d47-b423-9cca23975b65)

3. Tenure_Months and CLTV (Customer Lifetime Value): Correlation coefficient of 0.4, suggesting a moderate positive correlation between service tenure and CLTV.
4. total_Revenue and CLTV: Correlation coefficient of 0.35, suggesting a moderate positive relationship between total revenue and CLTV.
   ![image](https://github.com/user-attachments/assets/e3fad63b-7dfc-4958-9751-ce9b8c021932)

5. Low satisfaction score leading a high churn risk
   ![image](https://github.com/user-attachments/assets/feb1fc53-297b-4129-ad2d-03276ac5fb11)

6. Top 2 churned resason are  competitor had better devices,competitor had better devices
   ![image](https://github.com/user-attachments/assets/1965ad00-840e-4115-b442-51228387950a)

7. Offer E has a higher churn rate
   ![image](https://github.com/user-attachments/assets/13e91b63-0520-4a8a-addf-457e76a3201a)

8. internet service, streaming tv , streaming music have over 30% of churn rate
    ![image](https://github.com/user-attachments/assets/09391893-a86b-41ae-ae86-a8151c705c5c)

9. Fiber Optic internet type has the highestt churn rate

    ![image](https://github.com/user-attachments/assets/d7c00793-9cc5-4016-a586-f9b531678d75)

10. Over 1 year tenure have a higher stayed rate
    ![image](https://github.com/user-attachments/assets/69314011-88f1-458d-893d-be7457137306)





---

Insights:

**Service Tenure and Charges**: The data reveals a robust positive correlation between service tenure and both long-distance charges (0.78) and total revenue (0.85). This suggests that the longer customers stay, the more they contribute financially through both recurring charges and additional services like long-distance calls.

**Revenue and Monthly Charges**: The correlation between monthly charges and total revenue (0.59) highlights that monthly subscription fees are a key driver of revenue. This relationship underscores the importance of subscription pricing strategies in revenue generation.

Long-Distance Charges and Revenue: The strong correlation between long-distance charges and total revenue (0.78) indicates that long-distance services remain a significant revenue source.

**Moderate Correlations and CLTV**: Moderate correlations between tenure, total revenue, and Customer Lifetime Value (CLTV) (ranging from 0.35 to 0.4) suggest that longer tenure and higher revenue are moderately predictive of higher CLTV.

**Churn and Satisfaction**: The negative correlation (-0.5) between churn and satisfaction points to dissatisfaction as a significant predictor of customer turnover. The highest churn rates are noted among users of Fiber Optic internet services, suggesting possible issues with this service affecting customer satisfaction.

**Specific Issues Leading to Churn**: The top reasons for churn include competitors offering better devices and services. Also, specific offers like Offer E are associated with higher churn rates, indicating that these may not be aligning well with customer expectations or needs.

**Age and Usage Patterns**: Younger users, particularly those between 20-30 years old, have higher average monthly GB downloads, indicating higher data consumption that could be tied to lifestyle or tech-savviness.


---
Recommendations:

**Review Pricing Strategies**: Given the strong link between monthly charges and revenue, consider reviewing pricing strategies to ensure they are competitive yet profitable, especially for services with high churn rates like Fiber Optic internet.

**Enhance Fiber Optic Services**: Address the high churn rates in Fiber Optic services by improving service reliability and customer support, and consider conducting targeted satisfaction surveys to identify specific issues.

**Improve Customer Retention Programs**: Enhance customer satisfaction and retention programs by focusing on personalized experiences and loyalty rewards, particularly for long-tenure customers, to increase their CLTV.

**Competitor Analysis and Device Offers**: Regularly analyze competitor offers and ensure that your device and service offerings are competitive. Consider introducing new features or technologies that address the reasons customers are leaving.

***Targeted Marketing for Young Users**: Capitalize on the high data usage among younger users by crafting targeted marketing campaigns focusing on data-heavy plans and promoting services like streaming that align with their consumption patterns.

**Reevaluate Offer E**: Analyze the specific aspects of Offer E leading to higher churn rates. A/B testing of new offer structures may help in understanding what changes could make these offers more attractive.

**Focus on Service Quality**: Since low satisfaction is a clear predictor of churn, prioritize improvements in service quality across all touchpoints. Regular training for customer service representatives could help enhance the quality of customer interactions.


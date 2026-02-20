# 📊 Analyzing Customer Churn and Retention Patterns in a UK Based Multinational Retail Bank  
### Data-Driven Customer Segmentation & Churn Intelligence for Strategic Decision-Making

![Repo Size](https://img.shields.io/badge/Repo%20Size-Auto-informational?style=for-the-badge\&logo=github)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge\&logo=opensourceinitiative)
![Top Language](https://img.shields.io/badge/Top%20Language-SQL-blue?style=for-the-badge\&logo=postgresql)
![SQL Pipeline](https://img.shields.io/badge/SQL%20Pipeline-Included-success?style=for-the-badge\&logo=mysql)
![Dashboard](https://img.shields.io/badge/Dashboard-Power%20BI-yellow?style=for-the-badge\&logo=powerbi)


---

# 📑 Table of Contents
- [Business Context](#business-context)
- [Purpose of the Project](#purpose-of-the-project)
- [Dataset Description](#dataset-description)
- [SQL Transformation Logic](#sql-transformation-logic)
- [Methodology (CRISP-DM)](#methodology-crisp-dm)
- [Data Cleaning & Preparation](#data-cleaning--preparation)
- [Key KPIs & Metrics](#key-kpis--metrics)
- [Visual Dashboard](#visual-dashboard)
- [Presentation Slides](#presentation-slides)
- [Key Insights](#key-insights)
- [Strategic Recommendations](#strategic-recommendations)
- [Tools & Technologies](#tools--technologies)
- [Repository Structure](#repository-structure)
- [Conclusion](#conclusion)
- [Author](#author)

---

# 🏦 Business Context
In today’s competitive retail banking environment, customer churn is one of the most critical threats to profitability. Financial institutions face increasing pressure from digital-only banks, fintech startups, and personalized financial platforms.

Customer segmentation plays a vital role in identifying behavioral patterns, understanding risk profiles, and predicting attrition. By leveraging analytics, organizations can proactively engage high-risk customers, improve retention, and increase customer lifetime value.

---

# 🎯 Purpose of the Project
This project analyzes customer demographics, engagement behavior, financial attributes, and account activity to:

- Identify patterns among churned customers  
- Segment customers by churn risk level  
- Detect high-value customers at risk  
- Enable targeted retention strategies  
- Support executive decision-making using interactive dashboards  

---

# 📂 Dataset Description

### Raw Data Sources
- 📄 [AccountInfo.xlsx](data/raw/AccountInfo.csv)
- 📄 [CustomerInfo.xlsx](data/raw/CustomerInfo.csv)

### Processed Dataset
- 📊 [solution.xlsx](data/processed/solution.xlsx)

---

# 🧾 SQL Transformation Logic

To ensure full reproducibility and transparency, the entire data preparation workflow was implemented using SQL.

📜 **Full SQL Script:**  
👉 [View SQL Procedures](data/processed/Veritasdb.sql)

This script includes:

- Data quality checks  
- Duplicate detection  
- Null validation  
- Feature engineering  
- Derived column logic  
- Segmentation rules  
- Analytical views creation  
- Risk scoring framework  

Anyone can replicate the full transformation pipeline by running this script in MySQL Workbench.

---

# 🔄 Methodology (CRISP-DM)

1. Business Understanding  
2. Data Understanding  
3. Data Preparation  
4. Modeling  
5. Evaluation  
6. Deployment  

---

# 🧹 Data Cleaning & Preparation

Performed using SQL:

- Duplicate validation  
- Missing value detection  
- Outlier checks  
- Negative balance validation  
- Derived categorical fields  
- Analytical view creation  

Result: **Analytics-ready dataset optimized for BI modeling**

---

# 📊 Key KPIs & Metrics

- Total Customers  
- Total Churned Customers  
- Churn Rate %  
- Avg Engagement Score  
- Avg Risk Score  
- Avg Balance  
- Avg Credit Score  
- Risk Distribution  
- Estimated Customer Value  
- Value at Risk  

---

# 📈 Visual Dashboard

- 📊 [Executive Dashboard](dashboard/pics_1.png)
- 📊 [Driver Analysis](dashboard/pics_2.png)
- 📊 [Retention Insights](dashboard/pics_3.png)
- 📊 [Risk Segmentation](dashboard/pics_4.png)
- 📊 [Customer Value Analysis](dashboard/pics_5.png)

---

# 🧾 Presentation Slides
📥 [Download Presentation](slides/Customer_Churn_Presentation.pptx)

---

# 🔎 Key Insights

- Low engagement strongly correlates with churn  
- Customers with fewer products churn more  
- High-value customers can still be high risk  
- Germany & France show higher attrition risk  
- Credit score significantly influences retention probability  

---

# 📌 Strategic Recommendations

- Deploy predictive churn monitoring  
- Launch targeted retention campaigns  
- Incentivize engagement for low-activity customers  
- Prioritize high-value high-risk clients  
- Introduce loyalty programs for long-tenure customers  

---

# 🛠 Tools & Technologies

- MySQL Workbench  
- SQL  
- Power BI  
- DAX  
- Data Modeling  
- Excel  
- Analytical Storytelling  

---

# 📁 Repository Structure

```plaintext
Analyzing Customer Churn and Retention Patterns in a UK Based Multinational Retail Bank/
│
├── raw/
│   ├── [AccountInfo.xlsx](raw/AccountInfo.xlsx)
│   ├── [CustomerInfo.xlsx](raw/CustomerInfo.xlsx)
│   └── processed/
│       └── [Veritasdb.sql](raw/processed/Veritasdb.sql)
│
├── processed/
│   └── [solution.xlsx](processed/solution.xlsx)
│
├── dashboard/
│   ├── [pics_1.png](dashboard/pics_1.png)
│   ├── [pics_2.png](dashboard/pics_2.png)
│   ├── [pics_3.png](dashboard/pics_3.png)
│   ├── [pics_4.png](dashboard/pics_4.png)
│   └── [pics_5.png](dashboard/pics_5.png)
│
├── slides/
│   └── [recommendation.pptx](slides/recommendation.pptx)
│
├── README.md
└── LICENSE

```

---

## 🏁 Conclusion
This project demonstrates how Excel-based customer segmentation and data analytics can significantly improve production planning and supply chain efficiency. By adopting a customer-centric, data-driven approach, organizations can reduce operational costs, improve demand alignment, and enhance overall supply chain performance.

---

## 👩‍💻 Author
**Charles Walton**  
Data Analyst Consultant | SQL | Power BI | Python | ETL 
📧 cwalton1335@gmail.com
🔗 https://linkedin.com/in/cwalton1335
💻 https://github.com/cwalton133


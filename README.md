# 🍔 FASOS SQL Analytics Project

## 📊 Project Overview
FASOS is a food delivery company specializing in customizable rolls. This project leverages SQL to perform in-depth analysis of customer behavior, delivery operations, and ingredient usage. The goal is to generate actionable business insights using structured relational data.

## 🗂️ Dataset Summary
The project uses the following tables:

- `driver(driver_id, reg_date)` - Drivers and registration dates.
- `ingredients(ingredients_id, ingredients_name)` - Ingredient master list.
- `rolls(roll_id, roll_name)` - Roll types (Veg/Non-Veg).
- `rolls_recipes(roll_id, ingredients)` - Ingredients used in each roll.
- `driver_order(order_id, driver_id, pickup_time, distance, duration, cancellation)` - Driver performance data.
- `customer_orders(order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date)` - Customer orders.

## 🎯 Business Questions Answered

1. Which are the most ordered rolls?
2. What is the peak ordering time?
3. Which driver has the most cancellations?
4. What is the average delivery time per driver?
5. Which ingredients are most commonly excluded or added?
6. What is the overall order cancellation rate?
7. What is the frequency of ingredient usage across all rolls?

## 🧠 Key Insights

- 🥇 **Most Ordered Roll**: Non-Veg Roll
- ⏰ **Peak Ordering Time**: 6–9 PM
- 🚫 **Most Cancellations**: Driver ID 2
- 🚀 **Best Performance**: Driver ID 1
- 🧅 **Common Exclusions**: Cheese, Onions
- 🌶️ **Popular Extras**: BBQ Chicken, Kebab
- 📉 **Cancellation Rate**: ~30%
- 📆 **Orders Peak**: On weekends

## 🛠️ Tech Stack

- SQL (MySQL)
- ER Diagram (dbdiagram.io or drawSQL)
- Microsoft Word for reporting
- GitHub for project hosting

## 📁 Folder Structure

```
FASOS_SQL_Project/
├── FASOS_DB_Creation.sql
├── FASOS_Insights_Queries.sql
├── FASOS_SQL_Project_Report.docx
├── ER_Diagram.png
└── README.md
```

## 📌 Author

Sarthak Chaudhary  
📅 June 08, 2025  
🚀 [Connect on LinkedIn](https://www.linkedin.com/in/sarthakchaudhary09/) | 🌐 [GitHub](https://github.com/sarthakchaudhary-11)



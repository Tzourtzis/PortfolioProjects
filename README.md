# Cyclistic Data Warehouse and ETL Project

## Project Overview
This project involves building an end-to-end data warehouse pipeline for Cyclistic, a bike-share company in Chicago. The objective is to analyze how annual members and casual riders use Cyclistic bikes differently, with the ultimate goal of designing marketing strategies to convert casual riders into annual members.

## Project Components
Data Warehouse Setup:
- Database: PostgreSQL
- Tables: Created tables to store raw and processed ride data.

## Data Ingestion and Processing:
- ETL Tool: Pentaho Data Integration (PDI)
- Processes: Automated monthly data loads, data cleaning, and transformation tasks.

## Data Analysis and Visualization:
- Tools: PowerBI
- Visualizations: Created dashboards to visualize ride patterns, user behavior, and trends.

## Steps and Tools Used
Data Warehouse Creation:
- Used PostgreSQL to set up a local data warehouse.
- Created tables to store initial and processed ride data.

## ETL Processes:
- Used Pentaho Data Integration (PDI) to automate ETL tasks.
- Loaded monthly ride data into the warehouse.
- Cleaned and transformed data to ensure consistency and accuracy.

## Data Analysis:
- Analyzed ride data to identify patterns and trends.
- Calculated key metrics such as average ride duration, ride frequency, and popular routes.

## Data Visualization:
- Created interactive dashboards in PowerBI to present insights.
- Visualized differences in usage patterns between annual members and casual riders.

## Key Findings
- User Type Distribution: Annual members constitute 64.11% of total rides, while casual riders make up 35.89%.
- Average Ride Duration: Casual riders have an average ride duration of 21 minutes, compared to 13 minutes for members.
- Peak Usage Times: Members ride more frequently on weekdays, whereas casual riders prefer weekends.
- Bike Type Preference: Majority of the rides use classic bikes (48.68%) and electric bikes (50.08%).

## Recommendations
- Targeted Marketing Campaigns: Focus on converting casual riders who ride frequently on weekends by offering weekend-specific membership deals.
- Incentive Programs: Introduce incentives for casual riders to try out membership benefits, such as discounts on annual memberships.
- Enhanced User Engagement: Use digital media to engage casual riders with personalized offers and updates on new bike types and stations.

## SQL Code
The SQL code used in this project includes table creation, data loading, and validation scripts. The detailed SQL code with comments is provided in the project files.

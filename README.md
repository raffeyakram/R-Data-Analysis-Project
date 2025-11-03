# Data Science Portfolio Project: Comprehensive Data Analysis with R

## Project: DSC 441 - Data Exploration and Transformation

This project showcases fundamental data science skills using **R** and the **Tidyverse** ecosystem, focusing on **Exploratory Data Analysis (EDA)**, **Data Transformation**, and **Visualization**.

The analysis is performed on two datasets: the **Adult Income** dataset (US Census data) and a **US State Population** dataset.

---

### **Key Data Science Skills Demonstrated**

| Skill Area | Description of Task | R Packages Used |
| :--- | :--- | :--- |
| **Exploratory Data Analysis (EDA)** | Summarized numerical/categorical variables, visualized distributions (boxplots) and pairwise correlations (scatterplot matrices). | `ggplot2`, `GGally` |
| **Data Wrangling** | Joined disparate datasets (`population_even.csv`, `population_odd.csv`), cleaned messy column names, and **Imputed missing values** using interpolation logic. | `dplyr`, `tidyr` |
| **Data Transformation** | Reshaped time-series data from **wide to long format** for visualization and performed complex **row-wise aggregation** (max and total population). | `tidyr::pivot_longer`, `dplyr::rowwise` |
| **Data Visualization** | Generated clear, publication-quality visualizations to communicate key findings, such as the relationship between Education and Income. | `ggplot2` |

### **Analysis Highlights & Insights**

* **Income vs. Education:** Confirmed a strong positive correlation, with higher education levels (Masters, Doctorate) corresponding to a significantly greater proportion of individuals in the `>50K` income bracket.
* **Data Quality:** Identified and addressed **extreme outliers** in the `hours.per.week` variable, and successfully cleaned and imputed missing population data using a two-point averaging method.
* **Population Trends:** Visualized population growth trends in key US states, demonstrating time-series data handling capability.

---
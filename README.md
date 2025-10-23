# Automated PowerPoint Report Generator 📊

An **R-based automation tool** that generates fully formatted PowerPoint reports using live data from a **PostgreSQL** database.
This project dramatically streamlines the reporting process — reducing a 4-hour manual task to just **5 minutes**, and tripling the Customer Success team’s capacity from **10 to 30 customers per employee**.

---

## 🚀 Overview

This project automates the end-to-end creation of customer performance reports:

1. **Takes input parameters** such as:

   * Date ranges
   * Categories
   * Customer IDs or names
2. **Connects to a PostgreSQL database**
3. **Fetches and processes data** into metrics
4. **Generates charts** using `ggplot2`
5. **Populates a PowerPoint report** using the [`officer`](https://davidgohel.github.io/officer/) R package and a customizable PowerPoint template

The result is a professional, data-rich presentation ready for delivery — without manual intervention.

---

## 🧠 Key Features

* **Parameter-driven automation** — define the report scope (date, category, customer) via input parameters
* **Database integration** — securely connects to PostgreSQL to query live data
* **Visual analytics** — uses `ggplot2` to produce publication-quality charts
* **Dynamic PowerPoint generation** — leverages the `officer` package to fill in a template with custom slides, titles, tables, and visuals
* **Template-based design** — consistent layout and branding with editable PowerPoint templates
* **Massive efficiency gains** — cut report generation time by 98%, enabling scalable customer reporting

---

## 🧩 Tech Stack

* **Language:** R
* **Database:** PostgreSQL
* **Libraries:**

  * `RPostgres` — for database connectivity
  * `dplyr`, `tidyr`, `lubridate` — for data manipulation
  * `ggplot2` — for data visualization
  * `officer` — for PowerPoint report creation

---

## 🖼️ Example Output

Example slides include:

* Overview dashboard
* KPI trend charts
* Category breakdowns
* Customer-level metrics

Each report slide is generated dynamically based on the selected parameters.

---

## 📈 Impact

| Metric                    | Before        | After                   |
| ------------------------- | ------------- | ----------------------- |
| Report creation time      | ~4 hours      | **5 minutes**           |
| Customers handled per CSM | 10            | **30**                  |
| Error rate                | High (manual) | **Minimal (automated)** |



---

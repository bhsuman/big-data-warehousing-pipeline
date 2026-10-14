-- Which states have the highest loan default rates?
SELECT 
    b.borrower_state,
    COUNT(f.loan_key) AS total_loans,
    SUM(f.is_default) AS total_defaults,
    ROUND(AVG(f.is_default) * 100, 2) AS default_rate_pct,
    ROUND(AVG(f.loan_amnt), 2) AS avg_loan_amount
FROM workspace.default.fact_loans f
JOIN workspace.default.dim_borrower b ON f.loan_key = b.loan_key
GROUP BY b.borrower_state
HAVING COUNT(f.loan_key) > 100 -- Filters out states with very low volume
ORDER BY default_rate_pct DESC
LIMIT 10;

-- Which loan purposes(credit card, home improvement, debt consolidation) carry the highest risk?
SELECT 
    d.purpose,
    COUNT(f.loan_key) AS total_loans,
    ROUND(AVG(f.is_default) * 100, 2) AS default_rate_pct,
    ROUND(AVG(f.loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(f.int_rate), 2) AS avg_interest_rate
FROM workspace.default.fact_loans f
JOIN workspace.default.dim_loan_details d ON f.loan_key = d.loan_key
GROUP BY d.purpose
ORDER BY default_rate_pct DESC;

-- How does home ownership status impact borrower risk and annual income?
SELECT 
    b.home_ownership,
    COUNT(f.loan_key) AS total_loans,
    ROUND(AVG(f.annual_inc), 2) AS avg_annual_income,
    ROUND(AVG(f.dti), 2) AS avg_dti_ratio,
    ROUND(AVG(f.is_default) * 100, 2) AS default_rate_pct
FROM workspace.default.fact_loans f
JOIN workspace.default.dim_borrower b ON f.loan_key = b.loan_key
GROUP BY b.home_ownership
ORDER BY default_rate_pct DESC;

-- How does a borrower's employment length affect default risk and loan size?
SELECT 
    b.emp_length,
    COUNT(f.loan_key) AS total_loans,
    ROUND(AVG(f.is_default) * 100, 2) AS default_rate_pct,
    ROUND(AVG(f.loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(f.annual_inc), 2) AS avg_annual_income
FROM workspace.default.fact_loans f
JOIN workspace.default.dim_borrower b ON f.loan_key = b.loan_key
GROUP BY b.emp_length
ORDER BY default_rate_pct DESC;

Describe default.dim_borrower;
DESCRIBE default.dim_loan_details;

SELECT 
  COUNT(*) AS total_rows, 
  COUNT(DISTINCT borrower_key) AS unique_ids 
FROM default.dim_borrower;

SELECT * FROM default.fact_loans LIMIT 10;
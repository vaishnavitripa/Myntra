-- check for any missing value in a table 
SELECT COUNT(*) as MissingValues
From myntra_products_catalog
WHERE productname IS null OR productbrand IS NULL or price is NULL

-- Find the number of brands listed on site. 

SELECT COUNT( DISTINCT productbrand) As BrandCount
FROM myntra_products_catalog 

-- Find the number of brands per gender 

SELECT gender,
COUNT (DISTINCT productbrand) as BrandCount
FROM myntra_products_catalog
group by gender 

--Find the most expensive product for each categogy(gender wise). 

SELECT productid, 
productname, 
price
FROM ( 
      SELECT productid,
      productname,
      price,
      Rank () OVER (PARTITION by gender ORDER BY price DESC) as rank
      FROM myntra_products_catalog 
      ) as A 
where a.rank = 1      

-- Add a new column 'category' to the table. 

ALTER TABLE myntra_products_catalog
ADD COLUMN category VARCHAR(255);

-- Update the 'category' column based on the 'Productname'demo

UPDATE myntra_products_catalog
SET category = 
    CASE 
    when LOWER(productname) LIKE '%shirts%' or '%t-shirt%' THEN 'Shirts'
    when LOWER(productname) like '%skirt%' then 'skirt'
    when LOWER(productname) like '%Dress%' OR '%jumpsuit' THEN 'Dress'
    when LOWER(productname) like '%Top%' or '%bra%' then 'Top'
    when LOWER(productname) like '%jeans%'  or '%cargo%' then 'Bottom wear'
    when LOWER(productname) like '%saree%' or '%kurta%' OR '%dupatta%' or '%lehenga%' or '%blouse%' then 'Indian wear'
    when LOWER(productname) LIKE '%jacket%' or '%sweater%' or '%cardigan%' THEN 'Winter Wear'
    when LOWER(productname) LIKE '%heels%'  OR '%parfume%' OR '%bracelet%' or '%handbag%' or '%bag%' then 'accessories'
    when LOWER(gender) LIKE '%Unisex%' then 'Decore'
ELSE 'other'
end;

-- Find out number of products per category. 

SELECT category, COUNT(*) AS NumsCategory
FROM myntra_products_catalog 
GROUP by category 
order by NumsCategory desc 

-- Identifying most expensive product based on each category. 

SELECT productid, 
productname, 
category,
price
FROM ( 
      SELECT productid,
      productname,
      price, 
      category,
      Rank () OVER (PARTITION by category ORDER BY price DESC) as rank
      FROM myntra_products_catalog 
      ) as A 
where a.rank = 1   

--Check if there is a correlation between the length of descrription & price 

SELECT CASE 
       when length(description) < 500 THEN 'short'
       when length(description) BETWEEN 500 and 1000 then 'Medium'
       else 'Long'
       end as description_length_bucket,
       avg(price) as average_price
from myntra_products_catalog as a 
GROUP by description 
order by price DESC 



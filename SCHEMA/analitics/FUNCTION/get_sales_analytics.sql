CREATE OR REPLACE FUNCTION analitics.get_sales_analytics(p_start_date timestamp with time zone, p_end_date timestamp with time zone, p_group_by_type text = 'Category'::text) RETURNS TABLE(group_name text, total_sum_sales numeric, total_items_sold bigint, average_price numeric, median_price numeric, price_stddev numeric, item_sold_variance numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    query TEXT;
BEGIN
    IF p_group_by_type NOT IN ('Category', 'Manufacturer', 'Model', 'Product', 'ALL') THEN
        RAISE EXCEPTION 'Invalid group_by_type.  Must be Category, Manufacturer, Model, Product, or ALL.';
    END IF;

    query := format(
        'WITH sales_data AS (
            SELECT DISTINCT
                %s AS group_name,
                p.c_price AS product_price,
                p.id
            FROM storages.t_inventory i
            JOIN products.t_product_instance pi ON i.id_product_instance = pi.id
            JOIN products.t_product p ON p.id = pi.id_product
            %s
            WHERE i.c_event_type = ''Sold''
              AND i.c_upd_at BETWEEN %L AND %L
        ),
        ranked_sales AS (
            SELECT
                group_name,
                product_price,
                ROW_NUMBER() OVER (PARTITION BY group_name ORDER BY product_price) AS row_num,
                COUNT(*) OVER (PARTITION BY group_name) AS total_items
            FROM sales_data
        ),
        median_data AS (
            SELECT
                group_name,
                AVG(product_price) AS median_price
            FROM ranked_sales
            WHERE row_num BETWEEN (total_items + 1) / 2 AND (total_items + 2) / 2
            GROUP BY group_name
        )
        SELECT
            sd.group_name,
            SUM(sd.product_price) AS total_sum_sales,
            COUNT(*) AS total_items_sold,
            AVG(sd.product_price) AS average_price,
            md.median_price AS median_price,
            STDDEV(sd.product_price) AS price_stddev,
            VAR_POP(sd.product_price) AS item_sold_variance
        FROM sales_data sd
        JOIN median_data md ON sd.group_name = md.group_name
        GROUP BY sd.group_name, md.median_price
        ORDER BY total_sum_sales DESC;',
        CASE
            WHEN p_group_by_type = 'Category' THEN 'c.c_name'
            WHEN p_group_by_type = 'Manufacturer' THEN 'mfr.c_name'
            WHEN p_group_by_type = 'Model' THEN 'm.c_name'
            WHEN p_group_by_type = 'Product' THEN 'p.c_name'
            ELSE '''ALL'''  -- For ALL, group by a constant, so there's only one group
        END,
        CASE
            WHEN p_group_by_type = 'Category' THEN 'JOIN products.t_product_property pp ON pp.id_product = p.id
           JOIN
         categories.t_category_property cp ON pp.id_category_property = cp.id
           JOIN
         categories.t_category c ON cp.id_category = c.id'
            WHEN p_group_by_type = 'Manufacturer' THEN 'JOIN products.t_model m ON p.id_model = m.id JOIN products.t_manufacturer mfr ON m.id_manufacturer = mfr.id'
            WHEN p_group_by_type = 'Model' THEN 'JOIN products.t_model m ON p.id_model = m.id'
            WHEN p_group_by_type = 'Product' THEN ''  --No join needed
            ELSE '' --No join needed
        END,
        p_start_date,
        p_end_date
    );

    RETURN QUERY EXECUTE query;
END;
$$;

ALTER FUNCTION analitics.get_sales_analytics(p_start_date timestamp with time zone, p_end_date timestamp with time zone, p_group_by_type text) OWNER TO maindb;

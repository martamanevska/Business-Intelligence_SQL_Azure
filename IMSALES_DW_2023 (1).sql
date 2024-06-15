/* ============================================================================
 * Script file for BI I 2023-2024
 * ============================================================================
 * Creation of the IMSales Data Warehouse for use in BI Labs ("IMSALES DW 2023") 
 * ----------------------------------------------------------------------------
 *
 * Instructions: 
 *	 1. Open Microsoft Fabric and navigate to (or create) appropriate Workspace
 *   2. Use the existing Warehouse or create a new one ("+ Warehouses" button)
 *	 3. copy this entire SQL script to a "New SQL query" pane 
 *	 4. Execute this script (use the RUN button or use CTRL + ENTER shortcut)
 */
 
/* ----------------------------------------------------------------------------
 * General notes on the tables being created.
 * ----------------------------------------------------------------------------
 *
 * Note that we will use only the 4 "major" data-types:
 *	 1. Text or text-like types: VARCHAR(n) -- we cannot use VARCHAR in Fabric!
 *	 2. Dates: DATE
 *	 3. Whole (natural) numbers: INT 
 *	 4. Decimal numbers (incl. money): DECIMAL(18,2)
 * 
 * Notice that we are keeping both the Business Key (BK), as ingested and used
 * in the Staging Area, and the new Surrogate Keys (SK) that are typical of DW 
 * designs. This respects classic DW design considerations, better isolating
 * future needs for SCDs, numeric FK in the Fact table (lookup's), etc.
 *
 * IMPORTANT! Microsoft Fabric DOES NOT make use of referential integrity, so it
 * does not truly enforce Primary Keys and does not even allow Foreign Keys!
 *
 * We are GOING TO ASSUME THAT THESE STILL MAKE SENSE - so we WILL USE THEM...!
 * We will use ETL techniques to guarantee referential integrity in our tables.
 */

/* ----------------------------------------------------------------------------
 * Clearing the WAREHOUSE of existing tables, so we can run the CREATE script
 * ----------------------------------------------------------------------------
 *
 * Need to CLEAR the tables from the WAREHOUSE, so that you can run this script?
 * Highlight these and RUN them:
 *
        DROP TABLE fact_inventory;
        DROP TABLE fact_sales;
        DROP TABLE dim_client;
        DROP TABLE dim_product;
        DROP TABLE dim_shipper;
        DROP TABLE dim_staff;
        DROP TABLE dim_date;
 *
 */

-- the dimension table for clients, with 4 descriptive attributes (columns)
 CREATE TABLE dim_client (
	sk_client               INT             NOT NULL,   -- plays the role of the SK
	bk_client               VARCHAR(10)     NOT NULL,   -- plays the role of the BK
	client_name             VARCHAR(100)    NULL,
	client_contact_name     VARCHAR(100)    NULL,
	client_city             VARCHAR(50)     NULL,
	client_country          VARCHAR(50)     NULL
);

-- products dimension table, with several descriptive attributes (incl. product type)
CREATE TABLE dim_product (
	sk_product              INT             NOT NULL,   -- plays the role of the SK
	bk_product              INT             NOT NULL,   -- plays the role of the BK
	product_name            VARCHAR(50)     NULL,
	product_ship_quantity   VARCHAR(30)     NULL,
	product_size            VARCHAR(30)     NULL,
	product_unitprice       DECIMAL(18, 2)  NULL,
	product_discontinued    INT             NULL,
	producttype_name        VARCHAR(50)     NULL,
	supplier_name           VARCHAR(50)     NULL,
	supplier_country        VARCHAR(50)     NULL
);

-- the dimension table for shippers, representing a very POOR (few columns) dimension
CREATE TABLE dim_shipper (
	sk_shipper              INT             NOT NULL,   -- plays the role of the SK
	bk_shipper              INT             NOT NULL,   -- plays the role of the BK
	shipper_name            VARCHAR(50)     NULL,
	shipper_coverage        VARCHAR(50)     NULL,
	shipper_low_temp        VARCHAR(3)      NULL
);

-- the dimension table for staff, with as much information as we can get from the DB
CREATE TABLE dim_staff (
	sk_staff                INT             NOT NULL,   -- plays the role of the SK
	bk_staff                INT             NOT NULL,   -- plays the role of the BK
	staff_surname           VARCHAR(50)     NULL,
	staff_full_name         VARCHAR(100)    NULL,
	staff_age               INT             NULL,
	staff_seniority         INT             NULL,
	staff_primary_territory VARCHAR(50)     NULL,
	staff_region            VARCHAR(50)     NULL,
	staff_country           VARCHAR(50)     NULL
);

-- our classic Date dimension table, which we will populate ourselves (our own data)
CREATE TABLE dim_date (
	sk_date                 INT             NOT NULL,   -- plays the role of the SK
	proper_date             DATE            NOT NULL,   -- plays the role of the BK
	full_date               VARCHAR(50)     NOT NULL,
	monthday_number         INT             NOT NULL,
	weekday_number          INT             NOT NULL,
	weekday_name            VARCHAR(50)     NOT NULL,
	day_name_short          VARCHAR(50)     NOT NULL,
	weekday_type            VARCHAR(10)     NOT NULL,
	is_special              VARCHAR(30)     NOT NULL,
	month_number            INT             NOT NULL,
	month_name              VARCHAR(50)     NOT NULL,
	month_name_short        VARCHAR(50)     NOT NULL,
	quarter_number          INT             NOT NULL,
	quarter_name_short      VARCHAR(10)     NOT NULL,
	quarter_name            VARCHAR(50)     NOT NULL,
	semester_number         INT             NOT NULL,
	semester_name_short     VARCHAR(10)     NOT NULL,
	semester_name           VARCHAR(50)     NOT NULL,
	year                    INT             NOT NULL
);

-- the Facts table for the Inventory measures (has 2 FK granularity, would be the composite PK)
CREATE TABLE fact_inventory (
	fk_date             INT             NOT NULL,   -- plays FK referencing dim_date(sk_date)
	fk_product          INT             NOT NULL,   -- plays FK referencing dim_product(sk_product),
	cost_units_stocked  DECIMAL(18, 2)  NOT NULL,
	qty_units_stocked   INT             NOT NULL
);

-- the Facts table for our four Sales measures (has 5 FK granularity, would be the composite PK)
CREATE TABLE fact_sales (
	fk_date             INT             NOT NULL,   -- plays FK referencing dim_date(sk_date),
	fk_product          INT             NOT NULL,   -- plays FK referencing dim_product(sk_product),
	fk_shipper          INT             NOT NULL,   -- plays FK referencing dim_shipper(sk_shipper),
	fk_client           INT             NOT NULL,   -- plays FK referencing dim_client(sk_client),
	fk_staff            INT             NOT NULL,   -- plays FK referencing dim_staff(sk_staff),
	sales_unit_price    DECIMAL(18, 2)  NOT NULL,
	sales_unit_qty      INT             NOT NULL,
    sales_discount_perc DECIMAL(18,4)   NOT NULL
);

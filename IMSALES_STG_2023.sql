/* ============================================================================
 * Script file for BI I 2023-2024
 * ============================================================================
 * Creation of the IMSales Staging Area for use in BI Labs ("IMSALES STG 2023") 
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
 * Please also see the notes left in the DW SQL script.
 */

/* ----------------------------------------------------------------------------
 * Clearing the STG AREA of existing tables, so we can run the CREATE script
 * ----------------------------------------------------------------------------
 *
 * Need to CLEAR the tables from the STG AREA, so that you can run this script?
 * Highlight these and RUN them:
 *
        DROP TABLE stg_fact_inventory;
        DROP TABLE stg_fact_sales;
        DROP TABLE stg_dim_client;
        DROP TABLE stg_dim_product;
        DROP TABLE stg_dim_shipper;
        DROP TABLE stg_dim_staff;
        DROP TABLE stg_dim_date;
 *
 */

-- the Staging Area dimension table for clients
 CREATE TABLE stg_dim_client (
	bk_client               VARCHAR(10)     NOT NULL,   -- plays the role of the BK
	client_name             VARCHAR(100)    NULL,
	client_contact_name     VARCHAR(100)    NULL,
	client_city             VARCHAR(50)     NULL,
	client_country          VARCHAR(50)     NULL
);

-- Staging Area products dimension table
CREATE TABLE stg_dim_product (
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

-- the Staging Area dimension table for shippers
CREATE TABLE stg_dim_shipper (
	bk_shipper              INT             NOT NULL,   -- plays the role of the BK
	shipper_name            VARCHAR(50)     NULL,
	shipper_coverage        VARCHAR(50)     NULL,
	shipper_low_temp        VARCHAR(3)      NULL
);

-- the Staging Area dimension table for staff
CREATE TABLE stg_dim_staff (
	bk_staff                INT             NOT NULL,   -- plays the role of the BK
	staff_surname           VARCHAR(50)     NULL,
	staff_full_name         VARCHAR(100)    NULL,
	staff_age               INT             NULL,
	staff_seniority         INT             NULL,
	staff_primary_territory VARCHAR(50)     NULL,
	staff_region            VARCHAR(50)     NULL,
	staff_country           VARCHAR(50)     NULL
);

-- our Staging Area Date dimension table (note that it already has SK in STG!!)
CREATE TABLE stg_dim_date (
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

-- the Staging Area Facts table for the Inventory measures
CREATE TABLE stg_fact_inventory (
	fk_date             DATE            NOT NULL,
	fk_product          INT             NOT NULL,
	cost_units_stocked  DECIMAL(18, 2)  NOT NULL,
	qty_units_stocked   INT             NOT NULL
);

-- the Staging Area Facts table for our four Sales measures
CREATE TABLE stg_fact_sales (
	fk_date             DATE            NOT NULL,
	fk_product          INT             NOT NULL,
	fk_shipper          INT             NOT NULL,
	fk_client           VARCHAR(10)     NOT NULL,
	fk_staff            INT             NOT NULL,
	sales_unit_price    DECIMAL(18, 2)  NOT NULL,
	sales_unit_qty      INT             NOT NULL,
    sales_discount_perc DECIMAL(18,4)   NOT NULL
);

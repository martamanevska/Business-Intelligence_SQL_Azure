/* ----------------------------------------------------------------------------
 * Clearing the DW of existing tables, so we can run the CREATE script
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


/* ### List of main Objects to be created in Microsoft Fabric ###

 BI I 2023 Labs for IMSALES <your initials or student ID> (the workspace to be used in each Lab)
 
 IMSALES_DW_2023 (the definitive and final Data Warehouse for the IMSALES project)
 
 IMSALES_STG_2023 (the STAGING AREA warehouse, to be used for ETL we need to develop in the Labs)
 
 LH_IMSALES_SOURCES (the Lakehouse that will store the raw source flat files, as well as source tables)
 
 PL_IMSALES_LOAD_STG (the Fabric Pipeline that will be used for ETL that loads the STG)
 
*/


/* ### Pipeline SQL statements to use in clearing STG tables

	delete from stg_fact_inventory;
	delete from stg_fact_sales;
	
	delete from stg_dim_client;
	delete from stg_dim_product;
	delete from stg_dim_date;
	delete from stg_dim_shipper;
	delete from stg_dim_staff;

*/


/* ### List function to generate all dates from 2017 to 2020 ###
 
 List.Dates(#date(2017,1,1), Number.From(#date(2021,1,1)) - Number.From(#date(2017,1,1)), #duration(1,0,0,0))
 
*/


/* ### custom "is_special" column for some Public Holiday dates ###

 if [monthday_number] = 25 and [month_number] = 12 then "Christmas Day" else
 if [monthday_number] = 1 and [month_number] = 1 then "New Year's Day" else ""

*/


/* ### custom "full_date" column for full-text date representation ###

 [weekday_name] & ", " & Text.From([monthday_number]) 
 & " of " & [month_name] & " of " & Text.From([year])

*/


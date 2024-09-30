-- models/staging/tpch/stg_tpch_customers.sql
-- Staging model for TPCH customer data

{{ config(
    materialized = 'view',
    tags = ['tpch', 'customer']
) }}

with source as (

    select * from {{ source('tpch', 'customer') }}

),

renamed as (

    select
        -- Primary key
        c_custkey as customer_id,

        -- Foreign keys
        c_nationkey as nation_id,

        -- Other columns
        c_name as customer_name,
        c_address as address,
        c_phone as phone,
        c_acctbal as account_balance,
        c_mktsegment as market_segment,
        c_comment as comment,

        -- Boolean flags
        case
            when cast(c_acctbal as float) > 0 then true
            else false
        end as is_acct_bal_positive,

        -- Type casting
        cast(c_acctbal as float) as account_balance_float,

        -- Handling nulls
        coalesce(c_comment, 'No comment') as comment_non_null

    from source

)

select * from renamed
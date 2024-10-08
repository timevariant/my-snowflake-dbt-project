with source as (

    select * from {{ source('tpch', 'lineitem') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['l_orderkey', 'l_linenumber']) }} as order_item_key,
        l_orderkey as order_key,
        l_partkey as part_key,
        l_suppkey as supplier_key,
        l_linenumber as line_number,
        l_quantity as quantity,
        l_extendedprice as extended_price,
        l_discount as discount_percentage,
        l_tax as tax_rate,
        l_returnflag as return_flag,
        l_linestatus as status_code,
        l_shipdate as ship_date,
        l_commitdate as commit_date,
        l_receiptdate as receipt_date,
        l_shipinstruct as ship_instructions,
        l_shipmode as ship_mode,
        case when l_quantity <= 0 then 1 else 0 end as is_invalid_quantity,
        case when l_extendedprice < 0 then 1 else 0 end as is_negative_price,
        case when l_discount < 0 or l_discount > 1 then 1 else 0 end as is_invalid_discount

    from source

)

select * from renamed
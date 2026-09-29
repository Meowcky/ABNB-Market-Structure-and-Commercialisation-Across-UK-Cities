-- Grouping neighbourhood_group by host category
SELECT
    neighbourhood_group,
    `Host Category`,
    SUM(`No of Host`) AS `No of Host`,
    SUM(`No of Listings`) AS `No of Listings`
FROM (

    -- Combine the four source tables
    SELECT
        neighbourhood_group,
        calculated_host_listings_count,
        COUNT(*) / calculated_host_listings_count AS `No of Host`,
        COUNT(*) AS `No of Listings`,

        CASE
            WHEN calculated_host_listings_count = 1
                THEN '1 property'

            WHEN calculated_host_listings_count BETWEEN 2 AND 10
                THEN '2-10 properties'

            WHEN calculated_host_listings_count BETWEEN 11 AND 50
                THEN '11-50 properties'

            WHEN calculated_host_listings_count BETWEEN 51 AND 100
                THEN '51-100 properties'

            WHEN calculated_host_listings_count BETWEEN 101 AND 200
                THEN '101-200 properties'

            WHEN calculated_host_listings_count > 200
                THEN '>200 properties'
        END AS `Host Category`

    FROM (

        -- London
        SELECT
            neighbourhood_group,
            calculated_host_listings_count
        FROM listingLondonCleanDrop

        UNION ALL

        -- Greater Manchester
        SELECT
            neighbourhood_group,
            calculated_host_listings_count
        FROM listinggreatermanchestercleandrop

        UNION ALL

        -- Bristol
        SELECT
            neighbourhood_group,
            calculated_host_listings_count
        FROM listingsbristolcleandrop

        UNION ALL

        -- Edinburgh
        SELECT
            neighbourhood_group,
            calculated_host_listings_count
        FROM listingedinburghdropclean

    ) AS CombinedListings

    GROUP BY
        neighbourhood_group,
        calculated_host_listings_count

) AS HostSummary

GROUP BY
    neighbourhood_group,
    `Host Category`

ORDER BY
    neighbourhood_group,
    CASE `Host Category`
        WHEN '1 property' THEN 1
        WHEN '2-10 properties' THEN 2
        WHEN '11-50 properties' THEN 3
        WHEN '51-100 properties' THEN 4
        WHEN '101-200 properties' THEN 5
        WHEN '>200 properties' THEN 6
    END;
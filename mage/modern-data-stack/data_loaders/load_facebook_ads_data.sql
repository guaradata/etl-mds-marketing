-- Docs: https://docs.mage.ai/guides/sql-blocks
SELECT         
    apd.date_start as dt_day,
    apd.publisher_platform,
    apd.impressions,
    apd.inline_link_clicks as clicks,
    apd.platform_position,
    apd.reach,
    apd.impression_device,
    apd.spend
    FROM ads_insights_platform_and_device as apd
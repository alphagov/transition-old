/*

  All hosts and their URLs

*/

SELECT host, count(url) as url_count
FROM raw_urls
GROUP BY host
ORDER BY url_count DESC
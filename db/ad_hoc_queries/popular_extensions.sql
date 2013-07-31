/*

  Popular extensions
  
*/

SELECT extension, count(url) as url_count
FROM raw_urls
GROUP BY extension
ORDER BY url_count DESC
/*

	Key names in query strings per host

*/

SELECT u.host, q.key, count(*) usages
FROM raw_query_parts q
INNER JOIN raw_urls u on q.raw_url_id = u.id
GROUP BY u.host, q.key
ORDER BY u.host, q.key, usages
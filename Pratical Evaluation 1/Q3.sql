-- JUSTIFICATION: COUNT(t.ticket_id) counts tickets sold; COUNT(DISTINCT t.customer_id) counts different
-- customers, since the same customer may buy several tickets for one event (the two values can diverge).
-- All three conditions depend on per-event aggregates, so they go in HAVING: WHERE runs before
-- GROUP BY and cannot use aggregate functions. Grouping by event_id and title returns both columns.
-- The INNER JOIN with ticket excludes events with no tickets, which could never meet the thresholds.
SELECT e.event_id, e.title,
       COUNT(t.ticket_id) AS total_tickets,
       SUM(t.price) AS revenue,
       COUNT(DISTINCT t.customer_id) AS unique_customers
FROM event e
JOIN ticket t ON t.event_id = e.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(t.ticket_id) >= 4
   AND SUM(t.price) > 150
   AND COUNT(DISTINCT t.customer_id) >= 3
ORDER BY revenue DESC, e.title ASC;

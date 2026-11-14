-- JUSTIFICATION: There are two calculation universes: the per-event average (AVG with GROUP BY, compared
-- in HAVING) and the global average over all tickets of 'scheduled' events (scalar subquery, no GROUP BY).
-- They are not equivalent: the global average weights each ticket, so events with more tickets weigh more;
-- an average of per-event averages would give every event the same weight.
-- Both universes filter status = 'scheduled'; the INNER JOIN with ticket ensures at least one ticket sold.
SELECT e.event_id, e.title, AVG(t.price) AS avg_price
FROM event e
JOIN ticket t ON t.event_id = e.event_id
WHERE e.status = 'scheduled'
GROUP BY e.event_id, e.title
HAVING AVG(t.price) > (SELECT AVG(t2.price)
                       FROM ticket t2
                       JOIN event e2 ON e2.event_id = t2.event_id
                       WHERE e2.status = 'scheduled')
ORDER BY avg_price DESC, e.title ASC;

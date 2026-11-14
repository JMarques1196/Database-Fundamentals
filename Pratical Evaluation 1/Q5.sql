-- JUSTIFICATION: Filter: event with status 'completed' and a ticket with checkin_at IS NOT NULL (actual attendance).
-- The "no review" condition uses a correlated NOT EXISTS on customer_id AND event_id of the SAME event,
-- so a review by the customer for a different event does not exclude the pair.
-- A customer with several tickets for the same event would produce repeated rows; DISTINCT guarantees
-- each customer-event pair appears only once.
SELECT DISTINCT c.customer_id, c.name, e.event_id, e.title
FROM customer c
JOIN ticket t ON t.customer_id = c.customer_id
JOIN event e  ON e.event_id = t.event_id
WHERE e.status = 'completed'
  AND t.checkin_at IS NOT NULL
  AND NOT EXISTS (SELECT 1
                  FROM review r
                  WHERE r.customer_id = c.customer_id
                    AND r.event_id = e.event_id)
ORDER BY c.name ASC, e.title ASC;

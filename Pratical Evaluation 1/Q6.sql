-- AI_AUDIT: Error 1: COUNT(t.ticket_id) counts tickets, not events; it should be COUNT(DISTINCT t.event_id).
-- Error 2: it does not filter t.checkin_at IS NOT NULL, so it counts purchases, not actual attendance.
-- Counterexample: customer X has 2 tickets for the SAME event E1 and no check-in. The AI query returns
-- total_eventos = 2 (passes HAVING >= 2), but X attended 0 events; the corrected query excludes X.
SELECT c.customer_id, c.name, COUNT(DISTINCT t.event_id) AS total_eventos
FROM customer c
JOIN ticket t ON t.customer_id = c.customer_id
WHERE t.checkin_at IS NOT NULL
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT t.event_id) >= 2
ORDER BY total_eventos DESC, c.name ASC;

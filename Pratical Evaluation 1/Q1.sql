-- JUSTIFICATION: The filters restrict the results to events with status 'scheduled', with event_date
-- strictly after 2026-11-01, held at venues in Lisboa or Porto (IN).
-- The city is not stored in event, so an INNER JOIN with venue on event.venue_id = venue.venue_id is
-- required; every event has a venue (NOT NULL), so no rows are lost.
-- Ordering by event_date and then title (tie-break) follows the specification.
SELECT e.title, e.event_date, v.name AS venue_name, v.city
FROM event e
JOIN venue v ON v.venue_id = e.venue_id
WHERE e.status = 'scheduled'
  AND e.event_date > '2026-11-01'
  AND v.city IN ('Lisboa', 'Porto')
ORDER BY e.event_date ASC, e.title ASC;

-- JUSTIFICATION: The LEFT JOIN starting from venue keeps every venue, even those without scheduled events.
-- The filter e.status = 'scheduled' is in the ON clause, not in WHERE: in WHERE it would discard the
-- NULL-padded rows and venues with no scheduled events would vanish (the outer join would become an inner join).
-- COUNT(e.event_id) is used instead of COUNT(*): it ignores the NULL of unmatched rows and returns 0,
-- with no need for COALESCE. Grouping by venue_id, name and city exposes the requested columns.
SELECT v.venue_id, v.name, v.city, COUNT(e.event_id) AS total_scheduled
FROM venue v
LEFT JOIN event e
       ON e.venue_id = v.venue_id
      AND e.status = 'scheduled'
GROUP BY v.venue_id, v.name, v.city
ORDER BY v.name ASC;

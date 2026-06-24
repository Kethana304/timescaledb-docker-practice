# TimescaleDB Docker Practice

Hands-on setup of PostgreSQL + TimescaleDB using Docker, done in preparation 
for a Database Support Engineer role.

## What I did
- Pulled and ran `timescale/timescaledb-ha:pg16` via Docker
- Connected using psql inside the container
- Created a hypertable and inserted time-series sensor data
- Ran `time_bucket()` aggregation queries
- Practiced container lifecycle: stop/start, logs, exec

## Setup
```bash
docker run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=mypassword timescale/timescaledb-ha:pg16
docker exec -it timescaledb psql -U postgres
```

## What is a hypertable?
[2–3 sentences in your own words — this shows you understood it, not just copied commands]

## Sample query
```sql
SELECT time_bucket('1 hour', time) AS hour, sensor_id, AVG(temperature)
FROM sensor_data
GROUP BY hour, sensor_id;
```

## Key learnings
- [1–2 honest takeaways — e.g. "learned how Docker port mapping isolates container networking"]

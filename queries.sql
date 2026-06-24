CREATE EXTENSION IF N-- TimescaleDB Docker Practice
-- Setup: PostgreSQL + TimescaleDB running via Docker on Windows/WSL2

-- 1. Enable the TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Verify extension installed
SELECT extversion FROM pg_extension WHERE extname = 'timescaledb';


-- 2. Create a regular table to hold time-series sensor data
CREATE TABLE sensor_data (
    time TIMESTAMPTZ NOT NULL,
    sensor_id TEXT NOT NULL,
    temperature DOUBLE PRECISION NULL,
    humidity DOUBLE PRECISION NULL
);

-- 3. Convert the table into a hypertable, partitioned by time
SELECT create_hypertable('sensor_data', 'time');

-- Optional: add an index for faster lookups by sensor
CREATE INDEX ON sensor_data (sensor_id, time DESC);


-- 4. Insert sample data
INSERT INTO sensor_data (time, sensor_id, temperature, humidity)
VALUES
    (NOW(), 'sensor_1', 23.5, 45.0),
    (NOW(), 'sensor_2', 24.1, 46.2),
    (NOW(), 'sensor_1', 23.8, 45.5);


-- 5. Basic query: view all data, most recent first
SELECT * FROM sensor_data ORDER BY time DESC;


-- 6. TimescaleDB-specific query: aggregate data into 1-hour buckets
SELECT 
    time_bucket('1 hour', time) AS hour,
    sensor_id,
    AVG(temperature) AS avg_temp,
    AVG(humidity) AS avg_humidity
FROM sensor_data
GROUP BY hour, sensor_id
ORDER BY hour DESC;


-- 7. Check chunk information for the hypertable (shows TimescaleDB's auto-partitioning)
SELECT * FROM timescaledb_information.chunks
WHERE hypertable_name = 'sensor_data';OT EXISTS timescaledb;
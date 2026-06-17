-- ============================================================
--   RIDE-SHARING ANALYTICS PLATFORM (OLA/UBER STYLE)
--   Advanced SQL Portfolio Project
--   Author: Aman | GitHub Portfolio
-- ============================================================

-- ============================================================
-- SECTION 1: SCHEMA DESIGN
-- ============================================================

CREATE DATABASE IF NOT EXISTS rideshare_db;
USE rideshare_db;

-- Users Table
CREATE TABLE users (
    user_id       INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone         VARCHAR(15),
    city          VARCHAR(50),
    signup_date   DATE,
    user_type     ENUM('rider', 'driver', 'both') DEFAULT 'rider',
    rating        DECIMAL(3,2),
    is_active     BOOLEAN DEFAULT TRUE
);

-- Vehicles Table
CREATE TABLE vehicles (
    vehicle_id    INT PRIMARY KEY AUTO_INCREMENT,
    driver_id     INT,
    vehicle_type  ENUM('mini', 'sedan', 'suv', 'auto', 'bike') NOT NULL,
    model         VARCHAR(100),
    plate_number  VARCHAR(20) UNIQUE,
    year          INT,
    is_available  BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (driver_id) REFERENCES users(user_id)
);

-- Rides Table
CREATE TABLE rides (
    ride_id          INT PRIMARY KEY AUTO_INCREMENT,
    rider_id         INT NOT NULL,
    driver_id        INT NOT NULL,
    vehicle_id       INT NOT NULL,
    pickup_location  VARCHAR(200),
    drop_location    VARCHAR(200),
    pickup_city      VARCHAR(50),
    requested_at     DATETIME,
    started_at       DATETIME,
    completed_at     DATETIME,
    status           ENUM('requested','accepted','ongoing','completed','cancelled') DEFAULT 'requested',
    distance_km      DECIMAL(6,2),
    fare_amount      DECIMAL(10,2),
    surge_multiplier DECIMAL(3,2) DEFAULT 1.00,
    payment_method   ENUM('cash', 'wallet', 'card', 'upi'),
    FOREIGN KEY (rider_id)   REFERENCES users(user_id),
    FOREIGN KEY (driver_id)  REFERENCES users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id     INT PRIMARY KEY AUTO_INCREMENT,
    ride_id        INT UNIQUE,
    amount         DECIMAL(10,2),
    payment_method ENUM('cash', 'wallet', 'card', 'upi'),
    payment_status ENUM('pending', 'success', 'failed', 'refunded'),
    paid_at        DATETIME,
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id)
);

-- Ratings Table
CREATE TABLE ratings (
    rating_id    INT PRIMARY KEY AUTO_INCREMENT,
    ride_id      INT,
    rated_by     INT,
    rated_to     INT,
    score        DECIMAL(2,1) CHECK (score BETWEEN 1.0 AND 5.0),
    comment      TEXT,
    rated_at     DATETIME,
    FOREIGN KEY (ride_id)   REFERENCES rides(ride_id),
    FOREIGN KEY (rated_by)  REFERENCES users(user_id),
    FOREIGN KEY (rated_to)  REFERENCES users(user_id)
);

-- Promotions Table
CREATE TABLE promotions (
    promo_id       INT PRIMARY KEY AUTO_INCREMENT,
    promo_code     VARCHAR(20) UNIQUE,
    discount_pct   DECIMAL(5,2),
    max_discount   DECIMAL(8,2),
    valid_from     DATE,
    valid_to       DATE,
    usage_limit    INT,
    times_used     INT DEFAULT 0
);


-- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================

INSERT INTO users (name, email, phone, city, signup_date, user_type, rating, is_active) VALUES
('Rahul Sharma',   'rahul@gmail.com',   '9811000001', 'Delhi',   '2022-01-15', 'rider',  4.8,  TRUE),
('Priya Singh',    'priya@gmail.com',   '9811000002', 'Mumbai',  '2022-03-22', 'rider',  4.5,  TRUE),
('Amit Verma',     'amit@gmail.com',    '9811000003', 'Delhi',   '2021-07-10', 'driver', 4.7,  TRUE),
('Neha Gupta',     'neha@gmail.com',    '9811000004', 'Bangalore','2022-05-18','rider',  4.2,  TRUE),
('Raj Kumar',      'raj@gmail.com',     '9811000005', 'Delhi',   '2021-11-30', 'driver', 4.9,  TRUE),
('Sunita Devi',    'sunita@gmail.com',  '9811000006', 'Mumbai',  '2023-01-05', 'rider',  3.9,  TRUE),
('Vivek Tiwari',   'vivek@gmail.com',   '9811000007', 'Pune',    '2022-08-14', 'driver', 4.6,  TRUE),
('Anjali Mehta',   'anjali@gmail.com',  '9811000008', 'Delhi',   '2023-02-20', 'rider',  4.1,  FALSE),
('Deepak Nair',    'deepak@gmail.com',  '9811000009', 'Bangalore','2021-09-01','driver', 4.8,  TRUE),
('Kavita Joshi',   'kavita@gmail.com',  '9811000010', 'Delhi',   '2022-12-11', 'rider',  4.3,  TRUE);

INSERT INTO vehicles (driver_id, vehicle_type, model, plate_number, year, is_available) VALUES
(3, 'sedan', 'Swift Dzire',   'DL01AB1234', 2020, TRUE),
(5, 'suv',   'Ertiga',        'DL02CD5678', 2021, TRUE),
(7, 'mini',  'Alto',          'MH03EF9012', 2019, TRUE),
(9, 'sedan', 'Honda City',    'KA04GH3456', 2022, TRUE);

INSERT INTO rides (rider_id, driver_id, vehicle_id, pickup_location, drop_location, pickup_city,
                   requested_at, started_at, completed_at, status, distance_km, fare_amount,
                   surge_multiplier, payment_method) VALUES
(1,  3, 1, 'Connaught Place', 'Lajpat Nagar',   'Delhi',     '2024-01-10 08:00', '2024-01-10 08:05', '2024-01-10 08:35', 'completed', 12.5, 185.00, 1.0,  'upi'),
(2,  5, 2, 'Andheri',         'Bandra',          'Mumbai',    '2024-01-10 09:00', '2024-01-10 09:08', '2024-01-10 09:30', 'completed', 8.2,  145.00, 1.5,  'card'),
(4,  9, 4, 'Koramangala',     'Whitefield',      'Bangalore', '2024-01-11 10:00', '2024-01-11 10:10', '2024-01-11 11:00', 'completed', 20.0, 310.00, 1.0,  'wallet'),
(6,  7, 3, 'Dadar',           'Worli',           'Mumbai',    '2024-01-11 11:00', '2024-01-11 11:05', '2024-01-11 11:20', 'completed', 5.5,  90.00,  1.0,  'cash'),
(10, 3, 1, 'Dwarka',          'Saket',           'Delhi',     '2024-01-12 07:30', '2024-01-12 07:38', '2024-01-12 08:15', 'completed', 16.0, 240.00, 1.2,  'upi'),
(1,  5, 2, 'Hauz Khas',       'IGI Airport',     'Delhi',     '2024-01-13 05:00', '2024-01-13 05:10', '2024-01-13 06:00', 'completed', 22.0, 420.00, 2.0,  'card'),
(2,  9, 4, 'MG Road',         'Electronic City', 'Bangalore', '2024-01-14 18:00', '2024-01-14 18:15', '2024-01-14 19:10', 'completed', 18.5, 280.00, 1.5,  'upi'),
(4,  3, 1, 'Rohini',          'Nehru Place',     'Delhi',     '2024-01-15 09:00', NULL,               NULL,               'cancelled', NULL, NULL,   1.0,  NULL),
(6,  7, 3, 'Kothrud',         'Hinjewadi',       'Pune',      '2024-01-16 08:30', '2024-01-16 08:40', '2024-01-16 09:20', 'completed', 14.0, 195.00, 1.0,  'cash'),
(10, 5, 2, 'Vasant Kunj',     'Noida Sector 18', 'Delhi',     '2024-01-17 19:00', '2024-01-17 19:05', '2024-01-17 20:00', 'completed', 25.0, 375.00, 1.8,  'wallet');

INSERT INTO payments (ride_id, amount, payment_method, payment_status, paid_at) VALUES
(1,  185.00, 'upi',    'success', '2024-01-10 08:36'),
(2,  145.00, 'card',   'success', '2024-01-10 09:31'),
(3,  310.00, 'wallet', 'success', '2024-01-11 11:01'),
(4,  90.00,  'cash',   'success', '2024-01-11 11:21'),
(5,  240.00, 'upi',    'success', '2024-01-12 08:16'),
(6,  420.00, 'card',   'success', '2024-01-13 06:01'),
(7,  280.00, 'upi',    'success', '2024-01-14 19:11'),
(9,  195.00, 'cash',   'success', '2024-01-16 09:21'),
(10, 375.00, 'wallet', 'success', '2024-01-17 20:01');

INSERT INTO ratings (ride_id, rated_by, rated_to, score, comment, rated_at) VALUES
(1,  1,  3,  5.0, 'Very smooth ride',          '2024-01-10 09:00'),
(2,  2,  5,  4.5, 'Good driver, AC was great', '2024-01-10 10:00'),
(3,  4,  9,  5.0, 'Excellent!',                '2024-01-11 12:00'),
(4,  6,  7,  3.5, 'Took longer route',         '2024-01-11 12:30'),
(5,  10, 3,  4.0, 'Decent ride',               '2024-01-12 09:00'),
(6,  1,  5,  5.0, 'Perfect airport drop',      '2024-01-13 07:00'),
(7,  2,  9,  4.5, 'Night ride was smooth',     '2024-01-14 20:00'),
(9,  6,  7,  4.0, 'On time',                   '2024-01-16 10:00'),
(10, 10, 5,  5.0, 'Great for long distance',   '2024-01-17 21:00');


-- ============================================================
-- SECTION 3: ADVANCED SQL QUERIES
-- ============================================================

-- -------------------------------------------------------
-- Q1: TOP DRIVERS BY REVENUE (with ride count & avg fare)
-- -------------------------------------------------------
SELECT
    u.user_id,
    u.name                              AS driver_name,
    u.city,
    COUNT(r.ride_id)                    AS total_rides,
    ROUND(SUM(r.fare_amount), 2)        AS total_revenue,
    ROUND(AVG(r.fare_amount), 2)        AS avg_fare,
    ROUND(AVG(rt.score), 2)             AS avg_rating
FROM users u
JOIN rides r    ON u.user_id = r.driver_id AND r.status = 'completed'
LEFT JOIN ratings rt ON r.ride_id = rt.ride_id AND rt.rated_to = u.user_id
WHERE u.user_type = 'driver'
GROUP BY u.user_id, u.name, u.city
ORDER BY total_revenue DESC;


-- -------------------------------------------------------
-- Q2: SURGE PRICING ANALYSIS USING WINDOW FUNCTIONS
-- -------------------------------------------------------
SELECT
    ride_id,
    pickup_city,
    fare_amount,
    surge_multiplier,
    ROUND(fare_amount / surge_multiplier, 2)             AS base_fare,
    ROUND(AVG(fare_amount) OVER (PARTITION BY pickup_city), 2) AS city_avg_fare,
    RANK() OVER (PARTITION BY pickup_city ORDER BY fare_amount DESC) AS city_rank,
    CASE
        WHEN surge_multiplier >= 2.0 THEN 'High Surge'
        WHEN surge_multiplier >= 1.5 THEN 'Medium Surge'
        WHEN surge_multiplier > 1.0  THEN 'Low Surge'
        ELSE 'Normal'
    END AS surge_category
FROM rides
WHERE status = 'completed'
ORDER BY pickup_city, city_rank;


-- -------------------------------------------------------
-- Q3: RIDER RETENTION — FIRST vs REPEAT RIDERS (CTE)
-- -------------------------------------------------------
WITH rider_ride_counts AS (
    SELECT
        rider_id,
        COUNT(*) AS total_rides,
        MIN(requested_at) AS first_ride_date,
        MAX(requested_at) AS last_ride_date
    FROM rides
    WHERE status = 'completed'
    GROUP BY rider_id
),
rider_segments AS (
    SELECT
        rrc.*,
        u.name,
        u.city,
        CASE
            WHEN total_rides = 1 THEN 'One-Time'
            WHEN total_rides BETWEEN 2 AND 4 THEN 'Occasional'
            ELSE 'Loyal'
        END AS rider_segment,
        DATEDIFF(last_ride_date, first_ride_date) AS active_days
    FROM rider_ride_counts rrc
    JOIN users u ON rrc.rider_id = u.user_id
)
SELECT
    rider_segment,
    COUNT(*) AS rider_count,
    ROUND(AVG(total_rides), 1) AS avg_rides,
    ROUND(AVG(active_days), 0) AS avg_active_days
FROM rider_segments
GROUP BY rider_segment
ORDER BY avg_rides DESC;


-- -------------------------------------------------------
-- Q4: RUNNING TOTAL REVENUE PER DAY (Window Function)
-- -------------------------------------------------------
WITH daily_revenue AS (
    SELECT
        DATE(completed_at)           AS ride_date,
        COUNT(ride_id)               AS rides_completed,
        SUM(fare_amount)             AS daily_revenue
    FROM rides
    WHERE status = 'completed'
    GROUP BY DATE(completed_at)
)
SELECT
    ride_date,
    rides_completed,
    daily_revenue,
    ROUND(SUM(daily_revenue) OVER (ORDER BY ride_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_revenue,
    ROUND(AVG(daily_revenue) OVER (ORDER BY ride_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3day_avg
FROM daily_revenue
ORDER BY ride_date;


-- -------------------------------------------------------
-- Q5: DRIVER PERFORMANCE SCORECARD (Multi-CTE)
-- -------------------------------------------------------
WITH ride_stats AS (
    SELECT
        driver_id,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)  AS completed_rides,
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END)  AS cancelled_rides,
        COUNT(*)                                       AS total_rides,
        ROUND(SUM(fare_amount), 2)                    AS total_earnings,
        ROUND(AVG(distance_km), 2)                    AS avg_distance,
        ROUND(
            TIMESTAMPDIFF(MINUTE, started_at, completed_at) / NULLIF(distance_km, 0)
        , 2)                                           AS avg_min_per_km
    FROM rides
    GROUP BY driver_id
),
rating_stats AS (
    SELECT
        rated_to AS driver_id,
        ROUND(AVG(score), 2)   AS avg_rating,
        COUNT(*)               AS total_ratings
    FROM ratings r
    JOIN rides rd ON r.ride_id = rd.ride_id
    WHERE rd.driver_id = r.rated_to
    GROUP BY rated_to
)
SELECT
    u.name                                                           AS driver_name,
    u.city,
    rs.completed_rides,
    rs.cancelled_rides,
    ROUND(rs.completed_rides * 100.0 / NULLIF(rs.total_rides, 0), 1) AS completion_rate_pct,
    rs.total_earnings,
    rs.avg_distance,
    rt.avg_rating,
    rt.total_ratings,
    CASE
        WHEN rt.avg_rating >= 4.8 AND rs.completion_rate_pct >= 90 THEN 'Elite'
        WHEN rt.avg_rating >= 4.5 AND rs.completion_rate_pct >= 80 THEN 'Gold'
        WHEN rt.avg_rating >= 4.0                                   THEN 'Silver'
        ELSE 'Standard'
    END AS driver_tier
FROM users u
JOIN ride_stats   rs ON u.user_id = rs.driver_id
JOIN rating_stats rt ON u.user_id = rt.driver_id
WHERE u.user_type = 'driver'
ORDER BY rs.total_earnings DESC;


-- -------------------------------------------------------
-- Q6: CITY-WISE PAYMENT METHOD PREFERENCE (PIVOT-STYLE)
-- -------------------------------------------------------
SELECT
    pickup_city,
    COUNT(*)                                                    AS total_rides,
    SUM(CASE WHEN payment_method = 'upi'    THEN 1 ELSE 0 END) AS upi_rides,
    SUM(CASE WHEN payment_method = 'card'   THEN 1 ELSE 0 END) AS card_rides,
    SUM(CASE WHEN payment_method = 'cash'   THEN 1 ELSE 0 END) AS cash_rides,
    SUM(CASE WHEN payment_method = 'wallet' THEN 1 ELSE 0 END) AS wallet_rides,
    ROUND(SUM(CASE WHEN payment_method = 'upi'    THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS upi_pct
FROM rides
WHERE status = 'completed'
GROUP BY pickup_city
ORDER BY total_rides DESC;


-- -------------------------------------------------------
-- Q7: PEAK HOUR ANALYSIS (Hour-wise ride demand)
-- -------------------------------------------------------
SELECT
    HOUR(requested_at)                          AS hour_of_day,
    COUNT(*)                                    AS total_requests,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(AVG(surge_multiplier), 2)             AS avg_surge,
    ROUND(AVG(fare_amount), 2)                  AS avg_fare,
    CASE
        WHEN HOUR(requested_at) BETWEEN 7  AND 10 THEN 'Morning Rush'
        WHEN HOUR(requested_at) BETWEEN 17 AND 20 THEN 'Evening Rush'
        WHEN HOUR(requested_at) BETWEEN 23 AND 23
          OR HOUR(requested_at) BETWEEN 0  AND 4  THEN 'Late Night'
        ELSE 'Off-Peak'
    END AS time_slot
FROM rides
GROUP BY HOUR(requested_at)
ORDER BY total_requests DESC;


-- -------------------------------------------------------
-- Q8: CHURN DETECTION — RIDERS INACTIVE > 7 DAYS
-- -------------------------------------------------------
WITH last_activity AS (
    SELECT
        rider_id,
        MAX(requested_at) AS last_ride_date
    FROM rides
    GROUP BY rider_id
)
SELECT
    u.user_id,
    u.name,
    u.city,
    la.last_ride_date,
    DATEDIFF('2024-01-18', la.last_ride_date) AS days_inactive,
    CASE
        WHEN DATEDIFF('2024-01-18', la.last_ride_date) > 30 THEN 'High Risk Churn'
        WHEN DATEDIFF('2024-01-18', la.last_ride_date) > 14 THEN 'Medium Risk'
        WHEN DATEDIFF('2024-01-18', la.last_ride_date) > 7  THEN 'Low Risk'
        ELSE 'Active'
    END AS churn_risk
FROM users u
JOIN last_activity la ON u.user_id = la.rider_id
WHERE u.user_type = 'rider'
ORDER BY days_inactive DESC;


-- -------------------------------------------------------
-- Q9: INDEXING STRATEGY FOR PERFORMANCE
-- -------------------------------------------------------
-- Index on frequently filtered/joined columns
CREATE INDEX idx_rides_driver    ON rides(driver_id);
CREATE INDEX idx_rides_rider     ON rides(rider_id);
CREATE INDEX idx_rides_status    ON rides(status);
CREATE INDEX idx_rides_city_date ON rides(pickup_city, requested_at);
CREATE INDEX idx_ratings_ride    ON ratings(ride_id);
CREATE INDEX idx_payments_ride   ON payments(ride_id);
-- Composite index for dashboard queries
CREATE INDEX idx_rides_driver_status_date ON rides(driver_id, status, completed_at);


-- -------------------------------------------------------
-- Q10: STORED PROCEDURE — CALCULATE DYNAMIC FARE
-- -------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE CalculateFare(
    IN  p_distance_km     DECIMAL(6,2),
    IN  p_vehicle_type    VARCHAR(20),
    IN  p_hour_of_day     INT,
    OUT p_final_fare      DECIMAL(10,2)
)
BEGIN
    DECLARE base_rate    DECIMAL(5,2);
    DECLARE surge        DECIMAL(3,2);
    DECLARE min_fare     DECIMAL(8,2);

    -- Base rate per km by vehicle type
    SET base_rate = CASE p_vehicle_type
        WHEN 'mini'  THEN 8.00
        WHEN 'sedan' THEN 12.00
        WHEN 'suv'   THEN 16.00
        WHEN 'auto'  THEN 6.00
        WHEN 'bike'  THEN 4.00
        ELSE 10.00
    END;

    -- Surge multiplier by time
    SET surge = CASE
        WHEN p_hour_of_day BETWEEN 7  AND 10 THEN 1.5
        WHEN p_hour_of_day BETWEEN 17 AND 20 THEN 1.8
        WHEN p_hour_of_day BETWEEN 23 AND 23
          OR p_hour_of_day BETWEEN 0  AND 4  THEN 1.3
        ELSE 1.0
    END;

    SET min_fare     = 50.00;
    SET p_final_fare = GREATEST((p_distance_km * base_rate * surge), min_fare);
END$$
DELIMITER ;

-- Test the procedure
CALL CalculateFare(12.5, 'sedan', 8, @fare);
SELECT @fare AS calculated_fare;


-- ============================================================
-- SECTION 4: ANALYTICAL VIEWS (for dashboards)
-- ============================================================

CREATE VIEW vw_driver_dashboard AS
SELECT
    u.user_id,
    u.name,
    u.city,
    u.rating,
    COUNT(r.ride_id)              AS total_rides,
    ROUND(SUM(r.fare_amount), 2)  AS total_earnings,
    ROUND(AVG(rt.score), 2)       AS avg_customer_rating
FROM users u
LEFT JOIN rides r   ON u.user_id = r.driver_id AND r.status = 'completed'
LEFT JOIN ratings rt ON r.ride_id = rt.ride_id
WHERE u.user_type = 'driver'
GROUP BY u.user_id, u.name, u.city, u.rating;

CREATE VIEW vw_city_summary AS
SELECT
    pickup_city,
    COUNT(*)                     AS total_rides,
    ROUND(SUM(fare_amount), 2)   AS total_revenue,
    ROUND(AVG(fare_amount), 2)   AS avg_fare,
    ROUND(AVG(distance_km), 2)   AS avg_distance,
    ROUND(AVG(surge_multiplier), 2) AS avg_surge
FROM rides
WHERE status = 'completed'
GROUP BY pickup_city;

-- ============================================================
-- END OF PROJECT
-- ============================================================
